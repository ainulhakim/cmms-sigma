/// Centralized route path constants for the application.
///
/// All named routes used with [Navigator.pushNamed] should be defined here
/// to avoid string duplication and typos.
abstract class AppRoutes {
  AppRoutes._();

  // ── Auth Flow ─────────────────────────────────────────────────────────

  /// Splash / loading screen.
  static const String splash = '/';

  /// Login screen.
  static const String login = '/login';

  /// Registration / sign-up screen.
  static const String register = '/register';

  // ── Main App ──────────────────────────────────────────────────────────

  /// Main scaffold with bottom navigation (home).
  static const String home = '/home';

  /// Dashboard overview.
  static const String dashboard = '/dashboard';

  // ── Work Orders ───────────────────────────────────────────────────────

  /// List of all work orders.
  static const String workOrders = '/work-orders';

  /// Single work order detail.
  static const String workOrderDetail = '/work-orders/detail';

  /// Create a new work order.
  static const String workOrderCreate = '/work-orders/create';

  /// Edit an existing work order.
  static const String workOrderEdit = '/work-orders/edit';

  // ── Assets / Equipment ────────────────────────────────────────────────

  /// List of all equipment / assets.
  static const String assets = '/assets';

  /// Single asset detail.
  static const String assetDetail = '/assets/detail';

  /// Create a new asset.
  static const String assetCreate = '/assets/create';

  /// Edit an existing asset.
  static const String assetEdit = '/assets/edit';

  // ── Preventive Maintenance ────────────────────────────────────────────

  /// List of preventive maintenance schedules.
  static const String preventiveMaintenance = '/pm';

  /// Single PM schedule detail.
  static const String preventiveMaintenanceDetail = '/pm/detail';

  /// Create a new PM schedule.
  static const String preventiveMaintenanceCreate = '/pm/create';

  /// Edit an existing PM schedule.
  static const String preventiveMaintenanceEdit = '/pm/edit';

  // ── Inventory / Parts ─────────────────────────────────────────────────

  /// List of inventory parts.
  static const String inventory = '/inventory';

  /// Single part detail.
  static const String inventoryDetail = '/inventory/detail';

  // ── QR Scanner ────────────────────────────────────────────────────────

  /// QR code scanner screen.
  static const String qrScanner = '/qr-scanner';

  // ── Settings ──────────────────────────────────────────────────────────

  /// Application settings.
  static const String settings = '/settings';

  /// User profile.
  static const String profile = '/profile';

  /// About screen.
  static const String about = '/about';

  // ── Helpers ───────────────────────────────────────────────────────────

  /// Returns a parameterized work order detail route.
  static String workOrderDetailById(String id) => '/work-orders/detail?id=$id';

  /// Returns a parameterized asset detail route.
  static String assetDetailById(String id) => '/assets/detail?id=$id';

  /// Returns a parameterized PM detail route.
  static String preventiveMaintenanceDetailById(String id) => '/pm/detail?id=$id';

  /// Returns a parameterized inventory detail route.
  static String inventoryDetailById(String id) => '/inventory/detail?id=$id';
}
