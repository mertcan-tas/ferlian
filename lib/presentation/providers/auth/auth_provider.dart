import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/local/profile_local_data_source.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  AuthProvider(
    this._client, {
    required ProfileLocalDataSource profileStorage,
  }) : _profileStorage = profileStorage {
    unawaited(_init());
  }

  final SupabaseClient _client;
  final ProfileLocalDataSource _profileStorage;
  StreamSubscription<AuthState>? _authSubscription;

  Session? _session;
  AuthStatus _status = AuthStatus.unknown;
  bool _isBusy = false;
  String? _errorMessage;
  UserProfileCache? _cachedProfile;

  Session? get session => _session;
  AuthStatus get status => _status;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;
  UserProfileCache? get cachedProfile => _cachedProfile;

  void clearError() {
    _setError(null);
  }

  Future<void> _init() async {
    _cachedProfile = _profileStorage.readProfile();
    _session = _client.auth.currentSession;
    _status = _session != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    if (_session != null) {
      _cacheSessionProfile(_session!);
    }
    notifyListeners();

    _authSubscription =
        _client.auth.onAuthStateChange.listen((data) => _applySession(
              data.session,
            ));
  }

  Future<bool> signIn({required String email, required String password}) async {
    return _guardedAction(() async {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _applySession(response.session);
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return _guardedAction(() async {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null && fullName.isNotEmpty
            ? {'full_name': fullName}
            : null,
      );
      _applySession(response.session);
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    _applySession(null);
  }

  Future<void> updateCachedProfile({
    String? email,
    String? fullName,
    String? avatarUrl,
  }) async {
    final currentEmail = email ?? _cachedProfile?.email ?? _session?.user.email;
    if (currentEmail == null || currentEmail.isEmpty) return;

    final profile = UserProfileCache(
      email: currentEmail,
      fullName: fullName ?? _cachedProfile?.fullName,
      avatarUrl: avatarUrl ?? _cachedProfile?.avatarUrl,
      updatedAt: DateTime.now(),
    );
    _cachedProfile = profile;
    await _profileStorage.writeProfile(profile);
    notifyListeners();
  }

  Future<bool> _guardedAction(Future<void> Function() action) async {
    if (_isBusy) return false;
    _setBusy(true);
    _setError(null);

    const maxAttempts = 3;
    var attempt = 0;
    var shouldContinue = true;

    while (shouldContinue && attempt < maxAttempts) {
      try {
        await action();
        _setBusy(false);
        return true;
      } on AuthRetryableFetchException catch (_) {
        attempt += 1;
        if (attempt >= maxAttempts) {
          _setError(
            'Sunucuya ulaşılamadı. Lütfen bağlantını kontrol edip tekrar dene.',
          );
          shouldContinue = false;
        } else {
          await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
        }
      } on AuthException catch (error) {
        _setError(error.message);
        shouldContinue = false;
      } catch (error) {
        _setError(error.toString());
        shouldContinue = false;
      }
    }

    _setBusy(false);
    return false;
  }

  void _applySession(Session? session) {
    _session = session;
    _status = session != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    if (session != null) {
      _cacheSessionProfile(session);
    } else {
      _cachedProfile = null;
      unawaited(_profileStorage.clear());
    }
    notifyListeners();
  }

  void _cacheSessionProfile(Session session) {
    final user = session.user;
    final email = user.email;
    if (email == null || email.isEmpty) return;
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final profile = UserProfileCache(
      email: email,
      fullName: (metadata['full_name'] as String?)?.trim(),
      avatarUrl: metadata['avatar_url'] as String?,
      updatedAt: DateTime.now(),
    );
    _cachedProfile = profile;
    unawaited(_profileStorage.writeProfile(profile));
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
