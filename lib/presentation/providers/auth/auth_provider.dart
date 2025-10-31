import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  AuthProvider(this._client) {
    unawaited(_init());
  }

  final SupabaseClient _client;
  StreamSubscription<AuthState>? _authSubscription;

  Session? _session;
  AuthStatus _status = AuthStatus.unknown;
  bool _isBusy = false;
  String? _errorMessage;

  Session? get session => _session;
  AuthStatus get status => _status;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void clearError() {
    _setError(null);
  }

  Future<void> _init() async {
    _session = _client.auth.currentSession;
    _status = _session != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();

    _authSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      _session = session;
      _status = session != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return _guardedAction(() async {
      await _client.auth.signInWithPassword(email: email, password: password);
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return _guardedAction(() async {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null && fullName.isNotEmpty
            ? {'full_name': fullName}
            : null,
      );
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<bool> _guardedAction(Future<void> Function() action) async {
    if (_isBusy) return false;
    _setBusy(true);
    _setError(null);
    try {
      await action();
      return true;
    } on AuthException catch (error) {
      _setError(error.message);
    } catch (error) {
      _setError(error.toString());
    } finally {
      _setBusy(false);
    }
    return false;
  }

  void _setBusy(bool value) {
    if (_isBusy != value) {
      _isBusy = value;
      notifyListeners();
    }
  }

  void _setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
