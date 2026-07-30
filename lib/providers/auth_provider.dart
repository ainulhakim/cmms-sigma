import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isSupervisor => _user?.isSupervisor ?? false;
  bool get isTechnician => _user?.isTechnician ?? false;

  /// Initialize the provider and listen to auth changes
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();

    _authService.statusStream.listen((status) {
      _status = status;
      _user = _authService.currentUser;
      _isLoading = false;
      notifyListeners();
    });

    await _authService.initialize();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.signIn(
      email: email,
      password: password,
    );

    _isLoading = false;
    if (!success) {
      _errorMessage = _authService.errorMessage;
    } else {
      _user = _authService.currentUser;
    }
    notifyListeners();
    return success;
  }

  /// Register a new account
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String role = 'technician',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.signUp(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );

    _isLoading = false;
    if (!success) {
      _errorMessage = _authService.errorMessage;
    }
    notifyListeners();
    return success;
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Update profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.updateProfile(data);
    if (success) {
      _user = _authService.currentUser;
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Refresh user profile
  Future<void> refreshProfile() async {
    await _authService.refreshProfile();
    _user = _authService.currentUser;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
