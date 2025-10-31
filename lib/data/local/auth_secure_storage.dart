import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';

class AuthSecureStorage {
  AuthSecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
              mOptions: MacOsOptions(
                accessibility: KeychainAccessibility.first_unlock,
                useDataProtectionKeyChain: true,
              ),
              webOptions: WebOptions(
                dbName: 'FerlianSecureStorage',
                publicKey: 'FerlianSecureStorageKey',
              ),
            );

  final FlutterSecureStorage _storage;
  final Map<String, String?> _memoryFallback = <String, String?>{};

  static const String _sessionKey = 'auth_session';

  Future<void> writeSession(String sessionJson) async {
    try {
      await _storage.write(key: _sessionKey, value: sessionJson);
      _memoryFallback.remove(_sessionKey);
    } on MissingPluginException {
      _memoryFallback[_sessionKey] = sessionJson;
    }
  }

  Future<String?> readSession() async {
    try {
      final value = await _storage.read(key: _sessionKey);
      if (value != null) {
        _memoryFallback.remove(_sessionKey);
        return value;
      }
      return _memoryFallback[_sessionKey];
    } on MissingPluginException {
      return _memoryFallback[_sessionKey];
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _sessionKey);
    } on MissingPluginException {
      // fall back to memory store
    } finally {
      _memoryFallback.remove(_sessionKey);
    }
  }

  Future<bool> hasSession() async {
    try {
      final contains = await _storage.containsKey(key: _sessionKey);
      if (contains) return true;
    } on MissingPluginException {
      // ignore and fall back to memory store
    }
    return _memoryFallback.containsKey(_sessionKey);
  }

  FlutterSecureStorage get storage => _storage;
}
