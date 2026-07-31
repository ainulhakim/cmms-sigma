import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'database_service.dart';
import 'supabase_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseService _supabase = SupabaseService();
  final DatabaseService _db = DatabaseService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  final StreamController<AuthStatus> _statusController =
      StreamController<AuthStatus>.broadcast();
  Stream<AuthStatus> get statusStream => _statusController.stream;

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isSupervisor => _currentUser?.isSupervisor ?? false;
  bool get isTechnician => _currentUser?.isTechnician ?? false;

  /// Initialize the auth service and check for existing session
  Future<void> initialize() async {
    _setStatus(AuthStatus.loading);

    try {
      // Listen to auth state changes
      _supabase.authStateChanges.listen((authState) async {
        final session = authState.session;
        if (session != null) {
          await _loadUser(session.user.id);
        } else {
          _currentUser = null;
          _setStatus(AuthStatus.unauthenticated);
        }
      });

      // Check for existing session
      final session = _supabase.client.auth.currentSession;
      if (session != null) {
        await _loadUser(session.user.id);
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
    }
  }

  /// Load user profile from Supabase or local DB
  Future<void> _loadUser(String userId) async {
    try {
      // Try fetching from Supabase first
      final profile = await _supabase.getProfile(userId);
      if (profile != null) {
        _currentUser = profile;
        // Cache locally
        await _db.insert('profiles', profile.toMap());
      } else {
        // Fallback to local cache
        final localProfile = await _db.getById('profiles', userId);
        if (localProfile != null) {
          _currentUser = UserModel.fromMap(localProfile);
        } else {
          _currentUser = UserModel(id: userId);
        }
      }
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      // Try local cache on error
      try {
        final localProfile = await _db.getById('profiles', userId);
        if (localProfile != null) {
          _currentUser = UserModel.fromMap(localProfile);
          _setStatus(AuthStatus.authenticated);
          return;
        }
      } catch (_) {}

      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    try {
      final response = await _supabase.signInWithEmail(email, password);
      final user = response.user;
      if (user != null) {
        await _loadUser(user.id);
        return true;
      } else {
        _errorMessage = 'No user returned from authentication';
        _setStatus(AuthStatus.unauthenticated);
        return false;
      }
    } on AuthException catch (e) {
      _errorMessage = _mapAuthError(e.message);
      _setStatus(AuthStatus.unauthenticated);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.unauthenticated);
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'technician',
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;

    try {
      final response = await _supabase.signUpWithEmail(
        email,
        password,
        {
          'full_name': fullName,
          'role': role,
        },
      );
      final user = response.user;
      if (user != null) {
        // Profile is created via database trigger
        _setStatus(AuthStatus.authenticated);
        return true;
      } else {
        // Email confirmation might be required
        _setStatus(AuthStatus.unauthenticated);
        return true; // Account created, may need email verification
      }
    } on AuthException catch (e) {
      _errorMessage = _mapAuthError(e.message);
      _setStatus(AuthStatus.unauthenticated);
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.unauthenticated);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.signOut();
      _currentUser = null;
      _setStatus(AuthStatus.unauthenticated);
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
    }
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return false;

    try {
      await _supabase.updateProfile(_currentUser!.id, data);
      _currentUser = _currentUser!.copyWith(
        fullName: data['full_name'] as String? ?? _currentUser!.fullName,
        phone: data['phone'] as String? ?? _currentUser!.phone,
        avatarUrl: data['avatar_url'] as String? ?? _currentUser!.avatarUrl,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Refresh current user profile
  Future<void> refreshProfile() async {
    if (_currentUser != null) {
      await _loadUser(_currentUser!.id);
    }
  }

  /// Map auth errors to user-friendly messages
  String _mapAuthError(String error) {
    final lower = error.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid email or password')) {
      return 'Invalid email or password';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please verify your email address';
    }
    if (lower.contains('user already registered')) {
      return 'An account with this email already exists';
    }
    if (lower.contains('password')) {
      return 'Password must be at least 6 characters';
    }
    if (lower.contains('rate limit')) {
      return 'Too many attempts. Please try again later';
    }
    return error;
  }

  void _setStatus(AuthStatus newStatus) {
    _status = newStatus;
    _statusController.add(newStatus);
  }

  /// Reset the auth service
  void dispose() {
    _statusController.close();
  }
}
