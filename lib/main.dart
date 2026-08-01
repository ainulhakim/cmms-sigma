import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
import 'services/database_service.dart';
import 'services/sync_service.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/machine_provider.dart';
import 'providers/work_order_provider.dart';
import 'providers/maintenance_history_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/machine_list_screen.dart';
import 'screens/machine_detail_screen.dart';
import 'screens/work_order_list_screen.dart';
import 'screens/work_order_detail_screen.dart';
import 'screens/checklist_form_screen.dart';
import 'screens/breakdown_report_screen.dart';
import 'screens/maintenance_history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/qr_scanner_screen.dart';

/// Global flag so providers can check whether Supabase initialized OK.
bool supabaseReady = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize local database for offline support ────────────────────
  await DatabaseService().initialize();

  // ── Initialize Supabase ──────────────────────────────────────────────
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    supabaseReady = true;
    debugPrint('✅ Supabase initialized OK');
  } catch (e) {
    supabaseReady = false;
    debugPrint('⚠️ Supabase init failed: $e');
  }

  // ── Initialize connectivity / sync service ───────────────────────────
  try {
    await SyncService().initialize();
  } catch (e) {
    debugPrint('⚠️ SyncService init failed (non-critical): $e');
  }

  runApp(const CmmsSigmaApp());
}

/// Root widget for CMMS SIGMA.
class CmmsSigmaApp extends StatelessWidget {
  const CmmsSigmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => MachineProvider()),
        ChangeNotifierProvider(create: (_) => WorkOrderProvider()),
        ChangeNotifierProvider(create: (_) => MaintenanceHistoryProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/login',
            routes: <String, WidgetBuilder>{
              '/login': (_) => const LoginScreen(),
              '/dashboard': (_) => const DashboardScreen(),
              '/machines': (_) => const MachineListScreen(),
              '/machine-detail': (_) => const MachineDetailScreen(),
              '/work-orders': (_) => const WorkOrderListScreen(),
              '/work-order-detail': (_) => const WorkOrderDetailScreen(),
              '/breakdown-report': (_) => const BreakdownReportScreen(),
              '/maintenance-history': (_) => const MaintenanceHistoryScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/qr-scanner': (_) => const QrScannerScreen(),
            },
            onGenerateRoute: (RouteSettings settings) {
              final Uri uri = Uri.parse(settings.name ?? '');
              final String? id = uri.queryParameters['id'];

              switch (uri.path) {
                case '/checklist-form':
                  return MaterialPageRoute(
                    builder: (_) => ChecklistFormScreen(
                      workOrderId: id ?? '',
                    ),
                    settings: settings,
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const _NotFoundScreen(),
                    settings: settings,
                  );
              }
            },
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder: (_) => const _NotFoundScreen(),
                settings: settings,
              );
            },
          );
        },
      ),
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 - Tidak Ditemukan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Halaman tidak ditemukan',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}
