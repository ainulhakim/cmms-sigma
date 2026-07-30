import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machine_provider.dart';
import '../providers/dashboard_provider.dart';
import '../config/theme.dart';
import '../models/work_order_model.dart';

class BreakdownReportScreen extends StatefulWidget {
  const BreakdownReportScreen({super.key});

  @override
  State<BreakdownReportScreen> createState() => _BreakdownReportScreenState();
}

class _BreakdownReportScreenState extends State<BreakdownReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  final _reporterController = TextEditingController();

  String? _selectedMachineId;
  String _selectedMachineName = '';
  String _priority = 'HIGH';
  bool _productionStoppage = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MachineProvider>().loadMachines();
    });
  }

  @override
  void dispose() {
    _problemController.dispose();
    _reporterController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMachineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih mesin terlebih dahulu'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final report = BreakdownReportModel(
      machineId: _selectedMachineId!,
      machineName: _selectedMachineName,
      problemDescription: _problemController.text.trim(),
      priority: _priority,
      productionStoppage: _productionStoppage,
      reporterName: _reporterController.text.trim(),
    );

    final dashboardProvider = context.read<DashboardProvider>();
    await dashboardProvider.submitBreakdownReport(report);

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan kerusakan berhasil dikirim'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Kerusakan'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning_rounded,
                          color: Colors.red.shade700, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Laporkan Kerusakan',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                            Text(
                              'Isi form dengan detail kerusakan yang terjadi',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Machine Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Mesin *',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Consumer<MachineProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: _selectedMachineId,
                            decoration: const InputDecoration(
                              labelText: 'Mesin',
                              hintText: 'Pilih mesin',
                              prefixIcon:
                                  Icon(Icons.precision_manufacturing_outlined),
                            ),
                            items: provider.allMachines.map((m) {
                              return DropdownMenuItem(
                                value: m.id,
                                child: Text('${m.name} (${m.code})'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMachineId = value;
                                final machine = provider.allMachines
                                    .firstWhere((m) => m.id == value);
                                _selectedMachineName = machine.name;
                              });
                            },
                            validator: (value) {
                              if (value == null) return 'Pilih mesin';
                              return null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Problem Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi Masalah *',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _problemController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Kerusakan',
                          hintText: 'Jelaskan detail kerusakan yang terjadi...',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          if (value.trim().length < 10) {
                            return 'Deskripsi minimal 10 karakter';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Photo Attachment
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur kamera akan segera hadir'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 36,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap untuk mengambil foto',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Bukti visual kerusakan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Priority + Toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prioritas',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'HIGH',
                            label: Text('Tinggi'),
                            icon: Icon(Icons.arrow_upward_rounded),
                          ),
                          ButtonSegment(
                            value: 'MEDIUM',
                            label: Text('Sedang'),
                            icon: Icon(Icons.remove_rounded),
                          ),
                          ButtonSegment(
                            value: 'LOW',
                            label: Text('Rendah'),
                            icon: Icon(Icons.arrow_downward_rounded),
                          ),
                        ],
                        selected: {_priority},
                        onSelectionChanged: (value) {
                          setState(() => _priority = value.first);
                        },
                      ),
                      const Divider(height: 32),
                      SwitchListTile(
                        title: const Text('Stoppage Produksi'),
                        subtitle: const Text(
                          'Apakah mesin berhenti berproduksi?',
                        ),
                        value: _productionStoppage,
                        onChanged: (value) {
                          setState(() => _productionStoppage = value);
                        },
                        secondary: Icon(
                          _productionStoppage
                              ? Icons.block_rounded
                              : Icons.play_circle_outline_rounded,
                          color: _productionStoppage
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Reporter Name
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Identitas Pelapor *',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _reporterController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pelapor',
                          hintText: 'Masukkan nama Anda',
                          prefixIcon: Icon(Icons.person_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              Consumer<DashboardProvider>(
                builder: (context, dashboard, _) {
                  return FilledButton.icon(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                      _isSubmitting ? 'Mengirim...' : 'Kirim Laporan',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.red.shade700,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
