import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProfileCache {
  const UserProfileCache({
    required this.email,
    this.fullName,
    this.avatarUrl,
    required this.updatedAt,
  });

  final String email;
  final String? fullName;
  final String? avatarUrl;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static UserProfileCache? fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return null;
    final email = map['email'] as String?;
    if (email == null || email.isEmpty) return null;
    return UserProfileCache(
      email: email,
      fullName: map['fullName'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal(),
    );
  }
}

class ProfileLocalDataSource {
  ProfileLocalDataSource();

  static const String _boxName = 'profile_box';
  static const String _profileKey = 'profile';

  Box<Map<dynamic, dynamic>>? _profileBox;

  Future<void> init() async {
    if (Hive.isBoxOpen(_boxName)) {
      _profileBox = Hive.box<Map<dynamic, dynamic>>(_boxName);
    } else {
      _profileBox = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
    }
  }

  @visibleForTesting
  bool get isInitialized => _profileBox != null;

  Box<Map<dynamic, dynamic>> get _box {
    final box = _profileBox;
    if (box == null) {
      throw StateError('ProfileLocalDataSource has not been initialized.');
    }
    return box;
  }

  UserProfileCache? readProfile() {
    final data = _box.get(_profileKey);
    return UserProfileCache.fromMap(data);
  }

  Future<void> writeProfile(UserProfileCache profile) async {
    await _box.put(_profileKey, profile.toMap());
  }

  Future<void> clear() async {
    await _box.delete(_profileKey);
  }
}
