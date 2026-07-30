import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/maintenance_history_provider.dart';
import '../providers/machine_provider.dart';
import '../config/theme.dart';
import '../models/work_order_model.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final machineId = ModalRoute.of(context)?.settings.arguments as String?;
      if (machineId != null) {
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
        title: const Text('Riwayat Perawatan'),
      ),
      body: Consumer2<MaintenanceHistoryProvider, MachineProvider>(
        builder: (context, historyProvider, machineProvider, _) {
          if (historyProvider.isLoading && historyProvider.historyItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (historyProvider.error != null &&
              historyProvider.historyItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(historyProvider.error!),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final machineId =
                          ModalRoute.of(context)?.settings.arguments as String?;
                      if (machineId != null) {
                        historyProvider.loadHistory(machineId);
                      }
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final items = historyProvider.historyItems;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded,
                      size: 48, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat perawatan',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Riwayat perawatan akan muncul setelah work order selesai',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Calculate stats
          final totalItems = items.length;
          final breakdownCount =
              items.where((i) => i.type == 'BREAKDOWN').length;
          final routineCount =
              items.where((i) => i.type == 'ROUTINE').length;
          final totalDuration = items.fold<Duration>(
            Duration.zero,
            (sum, item) => sum + (item.duration ?? Duration.zero),
          );

          return RefreshIndicator(
            onRefresh: () async {
              final machineId =
                  ModalRoute.of(context)?.settings.arguments as String?;
              if (machineId != null) {
                await historyProvider.loadHistory(machineId);
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _StatItem(
                              icon: Icons.build_rounded,
                              label: 'Total',
                              value: '$totalItems',
                              color: colorScheme.primary,
                            ),
                            _StatItem(
                              icon: Icons.warning_rounded,
                              label: 'Kerusakan',
                              value: '$breakdownCount',
                              color: Colors.red,
                            ),
                            _StatItem(
                              icon: Icons.handyman_rounded,
                              label: 'Rutin',
                              value: '$routineCount',
                              color: Colors.teal,
                            ),
                            _StatItem(
                              icon: Icons.timer_outlined,
                              label: 'Total Jam',
                              value:
                                  '${totalDuration.inHours}j',
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // History List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${items.length} item',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // History Items
                ...items.map((item) => _HistoryDetailCard(item: item)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryDetailCard extends StatelessWidget {
  final MaintenanceHistoryItem item;

  const _HistoryDetailCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = AppTheme.getStatusColor(item.status);

    final typeLabel = item.type == 'BREAKDOWN' ? 'Kerusakan' : 'Rutin';
    final typeIcon = item.type == 'BREAKDOWN'
        ? Icons.warning_rounded
        : Icons.build_rounded;
    final typeColor =
        item.type == 'BREAKDOWN' ? Colors.red.shade700 : Colors.teal;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.woNumber,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        typeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: typeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    AppTheme.getStatusLabel(item.status),
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 20),

            // Details
            Row(
              children: [
                Icon(Icons.person_outlined,
                    size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  item.technicianName ?? '-',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  item.completedAt != null
                      ? _formatDate(item.completedAt!)
                      : '-',
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                if (item.duration != null) ...[
                  Icon(Icons.timer_outlined,
                      size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${item.duration!.inHours}j ${item.duration!.inMinutes.remainder(60)}m',
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
