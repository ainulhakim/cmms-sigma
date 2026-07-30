import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?.name ?? 'Pengguna';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $userName',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Selamat datang di CMMS SIGMA',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildDashboardContent() : _buildPlaceholder(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          _handleNavigation(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing_rounded),
            label: 'Mesin',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'WO',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/machines');
        break;
      case 2:
        Navigator.pushNamed(context, '/work-orders');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Widget _buildDashboardContent() {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        if (dashboard.isLoading && dashboard.todayScheduleCount == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        if (dashboard.error != null && dashboard.todayScheduleCount == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(dashboard.error!),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => dashboard.loadDashboardData(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => dashboard.loadDashboardData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _DashboardCard(
                      icon: Icons.calendar_today_rounded,
                      label: 'Jadwal Hari Ini',
                      value: '${dashboard.todayScheduleCount}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashboardCard(
                      icon: Icons.pending_actions_rounded,
                      label: 'WO Tertunda',
                      value: '${dashboard.pendingWOCount}',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DashboardCard(
                icon: Icons.precision_manufacturing_rounded,
                label: 'Total Mesin',
                value: '${dashboard.totalMachineCount}',
                color: Colors.teal,
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Aksi Cepat',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_task_rounded,
                      label: 'Laporan\nKerusakan',
                      onTap: () => Navigator.pushNamed(context, '/breakdown-report'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan\nQR Mesin',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur scan QR segera hadir'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.history_rounded,
                      label: 'Riwayat\nPerawatan',
                      onTap: () => Navigator.pushNamed(context, '/machines'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Aktivitas Terbaru',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _ActivityItem(
                title: 'WO-2026-0002 dimulai',
                subtitle: 'Mesin Injection Molding - Perbaikan Pemanas',
                time: '30 menit lalu',
                icon: Icons.play_circle_filled,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              _ActivityItem(
                title: 'WO-2026-0003 selesai',
                subtitle: 'Mesin CNC Milling - Kalibrasi Sumbu X',
                time: '2 jam lalu',
                icon: Icons.check_circle_filled,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 8),
              _ActivityItem(
                title: 'WO-2026-0004 dibuat',
                subtitle: 'Kompresor Udara - Overhaul Kompresor',
                time: '1 hari lalu',
                icon: Icons.add_circle_filled,
                iconColor: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Text('Pilih menu dari navigasi bawah'),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            Text(
              time,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
