import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_order_provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import '../models/work_order.dart';
import '../models/work_order_model.dart';

class WorkOrderDetailScreen extends StatefulWidget {
  const WorkOrderDetailScreen({super.key});

  @override
  State<WorkOrderDetailScreen> createState() => _WorkOrderDetailScreenState();
}

class _WorkOrderDetailScreenState extends State<WorkOrderDetailScreen> {
  final _notesController = TextEditingController();
  final _supervisorNotesController = TextEditingController();
  final _sparePartNameController = TextEditingController();
  final _sparePartCodeController = TextEditingController();
  final _sparePartQtyController = TextEditingController(text: '1');
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final woId = ModalRoute.of(context)?.settings.arguments as String?;
      if (woId != null) {
        context.read<WorkOrderProvider>().selectWorkOrder(woId);
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _supervisorNotesController.dispose();
    _sparePartNameController.dispose();
    _sparePartCodeController.dispose();
    _sparePartQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Work Order'),
      ),
      body: Consumer<WorkOrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.selectedWorkOrder == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final wo = provider.selectedWorkOrder;
          if (wo == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(provider.error ?? 'Work order tidak ditemukan'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.selectWorkOrder(wo.id),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card
                _HeaderCard(workOrder: wo),
                const SizedBox(height: 16),

                // Machine Info
                _SectionCard(
                  title: 'Informasi Mesin',
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.precision_manufacturing_outlined,
                        label: 'Nama Mesin',
                        value: wo.machineName,
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        icon: Icons.qr_code_outlined,
                        label: 'Kode Mesin',
                        value: wo.machineCode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Schedule Info
                _SectionCard(
                  title: 'Jadwal',
                  child: Column(
                    children: [
                      _DetailRow(
                        icon: Icons.play_arrow_outlined,
                        label: 'Mulai',
                        value: wo.scheduledStart != null
                            ? _formatDateTime(wo.scheduledStart!)
                            : '-',
                      ),
                      const Divider(height: 16),
                      _DetailRow(
                        icon: Icons.stop_outlined,
                        label: 'Selesai',
                        value: wo.scheduledEnd != null
                            ? _formatDateTime(wo.scheduledEnd!)
                            : '-',
                      ),
                      if (wo.assignedToName != null) ...[
                        const Divider(height: 16),
                        _DetailRow(
                          icon: Icons.person_outlined,
                          label: 'Ditugaskan Ke',
                          value: wo.assignedToName!,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                if (wo.description.isNotEmpty)
                  _SectionCard(
                    title: 'Deskripsi',
                    child: Text(wo.description),
                  ),
                const SizedBox(height: 12),

                // Action Buttons
                if (wo.status == 'OPEN')
                  _buildStartButton(provider, wo)
                else if (wo.status == 'IN_PROGRESS' && wo.assignedTo == context.read<AuthProvider>().user?.id)
                  _buildCompleteSection(provider, wo),

                // Checklist Items
                if (wo.checklistItems.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Checklist',
                    child: Column(
                      children: wo.checklistItems.map((item) {
                        return CheckboxListTile(
                          title: Text(item.name),
                          value: item.isChecked,
                          onChanged: wo.status == 'IN_PROGRESS'
                              ? (value) {
                                  setState(() {
                                    item.isChecked = value ?? false;
                                  });
                                }
                              : null,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
                ],

                // Photo Section
                if (wo.status == 'IN_PROGRESS') ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Foto',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _PhotoPlaceholder(
                                label: 'Sebelum',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PhotoPlaceholder(
                                label: 'Sesudah',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // Spare Parts
                if (wo.status == 'IN_PROGRESS') ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Penggunaan Spare Part',
                    child: Column(
                      children: [
                        if (wo.spareParts.isNotEmpty)
                          ...wo.spareParts.map((sp) => ListTile(
                                dense: true,
                                title: Text(sp.partName),
                                subtitle: Text(
                                    '${sp.partCode} x${sp.quantity}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18),
                                  onPressed: () {
                                    setState(() {
                                      // Remove logic
                                    });
                                  },
                                ),
                              )),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _sparePartNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Spare Part',
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _sparePartCodeController,
                                decoration: const InputDecoration(
                                  labelText: 'Kode',
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _sparePartQtyController,
                                decoration: const InputDecoration(
                                  labelText: 'Qty',
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Add spare part
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Spare part ditambahkan'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Tambah Spare Part'),
                        ),
                      ],
                    ),
                  ),
                ],

                // Notes
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Catatan',
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan catatan...',
                      border: OutlineInputBorder(),
                    ),
                    enabled: wo.status == 'IN_PROGRESS',
                  ),
                ),

                // Supervisor Verification
                if (wo.status == 'COMPLETED' && !wo.isVerified) ...[
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Verifikasi Supervisor',
                    child: Column(
                      children: [
                        TextField(
                          controller: _supervisorNotesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Catatan Verifikasi',
                            hintText: 'Masukkan catatan supervisor...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: _isVerifying
                              ? null
                              : () => _handleVerification(provider, wo.id),
                          icon: _isVerifying
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.verified_rounded),
                          label: const Text('Verifikasi'),
                        ),
                      ],
                    ),
                  ),
                ],

                // Verified badge
                if (wo.isVerified) ...[
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.verified_rounded,
                              color: Colors.green.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Terverifikasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                if (wo.supervisorNotes != null)
                                  Text(
                                    wo.supervisorNotes!,
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartButton(WorkOrderProvider provider, WorkOrder wo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: () async {
                final success = await provider.startWorkOrder(wo.id);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pekerjaan dimulai'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Mulai Pekerjaan'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteSection(WorkOrderProvider provider, WorkOrder wo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton.icon(
              onPressed: () => _confirmCompletion(provider, wo.id),
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('Selesaikan Pekerjaan'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCompletion(
      WorkOrderProvider provider, String woId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menyelesaikan pekerjaan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await provider.completeWorkOrder(woId, {
        'notes': _notesController.text,
      });
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pekerjaan selesai'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleVerification(
      WorkOrderProvider provider, String woId) async {
    setState(() => _isVerifying = true);
    final success = await provider.verifyWorkOrder(
      woId,
      _supervisorNotesController.text,
    );
    setState(() => _isVerifying = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Work order diverifikasi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

// ============ Sub-widgets ============

class _HeaderCard extends StatelessWidget {
  final WorkOrder workOrder;

  const _HeaderCard({required this.workOrder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.getStatusColor(workOrder.status);
    final priorityColor = AppTheme.getPriorityColor(workOrder.priority);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    workOrder.woNumber,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: priorityColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        workOrder.priority == 'HIGH'
                            ? Icons.arrow_upward_rounded
                            : workOrder.priority == 'LOW'
                                ? Icons.arrow_downward_rounded
                                : Icons.remove_rounded,
                        size: 16,
                        color: priorityColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppTheme.getPriorityLabel(workOrder.priority),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: priorityColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.category_outlined,
                    size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  workOrder.type == 'BREAKDOWN' ? 'Kerusakan' : 'Rutin',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Chip(
                  label: Text(
                    AppTheme.getStatusLabel(workOrder.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (workOrder.title.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                workOrder.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value ?? '-',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PhotoPlaceholder({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 28,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Tap untuk foto',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
