import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_order_provider.dart';
import '../config/theme.dart';

class ChecklistFormScreen extends StatefulWidget {
  final String workOrderId;

  const ChecklistFormScreen({super.key, required this.workOrderId});

  @override
  State<ChecklistFormScreen> createState() => _ChecklistFormScreenState();
}

class _ChecklistFormScreenState extends State<ChecklistFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _measurementControllers = [];
  final List<TextEditingController> _notesControllers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WorkOrderProvider>();
      provider.selectWorkOrder(widget.workOrderId);

      // Listen for data load to initialize controllers
      provider.addListener(_onProviderUpdate);
    });
  }

  void _onProviderUpdate() {
    final provider = context.read<WorkOrderProvider>();
    if (provider.selectedWorkOrder != null && _measurementControllers.isEmpty) {
      final items = provider.selectedWorkOrder!.checklistItems;
      for (final item in items) {
        _measurementControllers.add(TextEditingController(text: item.measurementValue ?? ''));
        _notesControllers.add(TextEditingController(text: item.notes ?? ''));
      }
      provider.removeListener(_onProviderUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final c in _measurementControllers) {
      c.dispose();
    }
    for (final c in _notesControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Checklist'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text('Simpan'),
          ),
        ],
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
                  Text(provider.error ?? 'Data tidak ditemukan'),
                ],
              ),
            );
          }

          final items = wo.checklistItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist_rounded,
                      size: 48, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada item checklist',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wo.woNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          wo.machineName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          wo.title,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Progress indicator
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${items.where((i) => i.isChecked).length}/${items.length}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: items.isEmpty
                                ? 0
                                : items.where((i) => i.isChecked).length /
                                    items.length,
                            minHeight: 8,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Checklist Items
                Text(
                  'Item Checklist',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox + Name
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: item.isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    item.isChecked = value ?? false;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        decoration: item.isChecked
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: item.isChecked
                                            ? colorScheme.onSurfaceVariant
                                            : null,
                                      ),
                                    ),
                                    // Measurement Field (if applicable)
                                    if (item.name.toLowerCase().contains(
                                            'suhu') ||
                                        item.name
                                            .toLowerCase()
                                            .contains('tekanan') ||
                                        item.name
                                            .toLowerCase()
                                            .contains('getaran') ||
                                        item.name
                                            .toLowerCase()
                                            .contains('voltase') ||
                                        item.name
                                            .toLowerCase()
                                            .contains('arus') ||
                                        item.name
                                            .toLowerCase()
                                            .contains('kecepatan')) ...[
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _measurementControllers[
                                            index],
                                        decoration: InputDecoration(
                                          labelText: 'Nilai Pengukuran',
                                          hintText: 'Masukkan nilai...',
                                          isDense: true,
                                          prefixIcon: const Icon(
                                              Icons.straighten_rounded,
                                              size: 18),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Notes field
                          Padding(
                            padding: const EdgeInsets.only(left: 44),
                            child: TextFormField(
                              controller: _notesControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Catatan',
                                hintText: 'Tambahkan catatan...',
                                isDense: true,
                                prefixIcon: const Icon(Icons.notes_rounded,
                                    size: 18),
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Save Button
                FilledButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Simpan Checklist'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSave() {
    final provider = context.read<WorkOrderProvider>();
    final wo = provider.selectedWorkOrder;

    if (wo == null) return;

    // Update checklist items with form data
    for (int i = 0; i < wo.checklistItems.length; i++) {
      if (i < _measurementControllers.length) {
        wo.checklistItems[i].measurementValue =
            _measurementControllers[i].text;
      }
      if (i < _notesControllers.length) {
        wo.checklistItems[i].notes = _notesControllers[i].text;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checklist berhasil disimpan'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, wo.checklistItems);
  }
}
