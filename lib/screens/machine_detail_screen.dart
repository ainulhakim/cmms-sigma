import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/machine_provider.dart';
import '../providers/maintenance_history_provider.dart';
import '../config/theme.dart';
import '../models/machine.dart';
import '../models/work_order_model.dart';

class MachineDetailScreen extends StatefulWidget {
  const MachineDetailScreen({super.key});

  @override
  State<MachineDetailScreen> createState() => _MachineDetailScreenState();
}

class _MachineDetailScreenState extends State<MachineDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final machineId = ModalRoute.of(context)?.settings.arguments as String?;
      if (machineId != null) {
        context.read<MachineProvider>().selectMachine(machineId);
        context.read<MaintenanceHistoryProvider>().loadHistory(machineId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mesin'),
      ),
      body: Consumer2<MachineProvider, MaintenanceHistoryProvider>(
        builder: (context, machineProvider, historyProvider, _) {
          if (machineProvider.isLoading && machineProvider.selectedMachine == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final machine = machineProvider.selectedMachine;
          if (machine == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(machineProvider.error ?? 'Mesin tidak ditemukan'),
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
            onRefresh: () async {
              await machineProvider.selectMachine(machine.id);
              await historyProvider.loadHistory(machine.id);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Machine Info Card
                _MachineInfoCard(machine: machine),
                const SizedBox(height: 16),

                // QR Code Section
                _QRCodeSection(machine: machine),
                const SizedBox(height: 16),

                // Action Button
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/create-work-order',
                      arguments: machine,
                    );
                  },
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Buat Work Order'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 24),

                // Maintenance History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Perawatan',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/maintenance-history',
                          arguments: machine.id,
                        );
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (historyProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (historyProvider.error != null)
                  Center(
                    child: Text(
                      historyProvider.error!,
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  )
                else if (historyProvider.historyItems.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 40,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada riwayat perawatan',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...historyProvider.historyItems.take(3).map(
                    (item) => _HistoryItemCard(item: item),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MachineInfoCard extends StatelessWidget {
  final Machine machine;

  const _MachineInfoCard({required this.machine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = AppTheme.getStatusColor(machine.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing_rounded,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        machine.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${machine.code} • ${machine.line}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    AppTheme.getStatusLabel(machine.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide.none,
                ),
              ],
            ),
            const Divider(height: 32),

            // Info rows
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Lokasi',
              value: machine.location.isEmpty ? '-' : machine.location,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.description_outlined,
              label: 'Deskripsi',
              value: machine.description ?? '-',
            ),
            if (machine.lastMaintenance != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.build_circle_outlined,
                label: 'Terakhir Dirawat',
                value: _formatDate(machine.lastMaintenance!),
              ),
            ],
            if (machine.nextMaintenance != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.calendar_month_outlined,
                label: 'Jadwal Berikutnya',
                value: _formatDate(machine.nextMaintenance!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QRCodeSection extends StatelessWidget {
  final Machine machine;

  const _QRCodeSection({required this.machine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'QR Code Mesin',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code_rounded,
                  size: 80,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              machine.code,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // In production: generate and share actual QR
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR Code disimpan ke galeri'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('Bagikan QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  final MaintenanceHistoryItem item;

  const _HistoryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.getStatusColor(item.status);
    final typeLabel = item.type == 'BREAKDOWN' ? 'Kerusakan' : 'Rutin';
    final typeColor = item.type == 'BREAKDOWN'
        ? Colors.red.shade700
        : Colors.teal;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.type == 'BREAKDOWN'
                    ? Icons.warning_rounded
                    : Icons.build_rounded,
                color: typeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.woNumber,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$typeLabel • ${item.technicianName ?? '-'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (item.completedAt != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(item.completedAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Chip(
                  label: Text(
                    AppTheme.getStatusLabel(item.status),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                if (item.duration != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${item.duration!.inHours} jam ${item.duration!.inMinutes.remainder(60)} mnt',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
