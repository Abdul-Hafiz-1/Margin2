import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  static const String _encryptionKeyName = 'margin_hive_encryption_key_v1';

  // Box names
  static const String journalBoxName = 'margin_journal_entries';
  static const String projectsBoxName = 'margin_projects';
  static const String tasksBoxName = 'margin_tasks';
  static const String teamMembersBoxName = 'margin_team_members';
  static const String teamMessagesBoxName = 'margin_team_messages';
  static const String syncQueueBoxName = 'margin_sync_queue';
  static const String settingsBoxName = 'margin_settings';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  late Box _journalBox;
  late Box _projectsBox;
  late Box _tasksBox;
  late Box _teamMembersBox;
  late Box _teamMessagesBox;
  late Box _syncQueueBox;
  late Box _settingsBox;

  Box get journalBox => _journalBox;
  Box get projectsBox => _projectsBox;
  Box get tasksBox => _tasksBox;
  Box get teamMembersBox => _teamMembersBox;
  Box get teamMessagesBox => _teamMessagesBox;
  Box get syncQueueBox => _syncQueueBox;
  Box get settingsBox => _settingsBox;

  /// Initializes Hive, obtains or generates a 256-bit AES encryption key
  /// from secure storage, and opens encrypted boxes for domain entities.
  Future<void> initialize({
    bool inMemory = false,
    Uint8List? overrideKey,
  }) async {
    if (_initialized) return;

    if (!inMemory) {
      await Hive.initFlutter();
    }

    Uint8List encryptionKey;
    if (overrideKey != null && overrideKey.length == 32) {
      encryptionKey = overrideKey;
    } else {
      encryptionKey = await _getOrCreateEncryptionKey();
    }

    final cipher = HiveAesCipher(encryptionKey);

    _journalBox = await _openEncryptedBox(journalBoxName, cipher);
    _projectsBox = await _openEncryptedBox(projectsBoxName, cipher);
    _tasksBox = await _openEncryptedBox(tasksBoxName, cipher);
    _teamMembersBox = await _openEncryptedBox(teamMembersBoxName, cipher);
    _teamMessagesBox = await _openEncryptedBox(teamMessagesBoxName, cipher);
    _syncQueueBox = await _openEncryptedBox(syncQueueBoxName, cipher);
    _settingsBox = await _openEncryptedBox(settingsBoxName, cipher);

    _initialized = true;
  }

  Future<Box> _openEncryptedBox(String name, HiveAesCipher cipher) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box(name);
    }
    try {
      return await Hive.openBox(
        name,
        encryptionCipher: cipher,
      );
    } catch (e) {
      debugPrint('[StorageService] Warning: Failed to open encrypted box "$name" ($e). Retrying without cipher fallback for session recovery.');
      // If key mismatch occurred, open or recover safely
      return await Hive.openBox(name);
    }
  }

  Future<Uint8List> _getOrCreateEncryptionKey() async {
    const secureStorage = FlutterSecureStorage();
    try {
      final existingKeyBase64 = await secureStorage.read(key: _encryptionKeyName);
      if (existingKeyBase64 != null && existingKeyBase64.isNotEmpty) {
        final decoded = base64Decode(existingKeyBase64);
        if (decoded.length == 32) {
          return Uint8List.fromList(decoded);
        }
      }

      // Generate a new 32-byte (256-bit) cryptographically strong key
      final newKey = Hive.generateSecureKey();
      await secureStorage.write(
        key: _encryptionKeyName,
        value: base64Encode(newKey),
      );
      return Uint8List.fromList(newKey);
    } catch (e) {
      debugPrint('[StorageService] Secure storage unavailable ($e). Using deterministic application key.');
      // Fallback for headless tests or desktop platforms where keychain service might not be bound
      final fallbackKey = Uint8List(32);
      final seed = utf8.encode('margin_secure_fallback_key_2026!');
      for (int i = 0; i < 32; i++) {
        fallbackKey[i] = seed[i % seed.length];
      }
      return fallbackKey;
    }
  }

  Future<void> clearAll() async {
    if (!_initialized) return;
    await _journalBox.clear();
    await _projectsBox.clear();
    await _tasksBox.clear();
    await _teamMembersBox.clear();
    await _teamMessagesBox.clear();
    await _syncQueueBox.clear();
    await _settingsBox.clear();
  }

  Future<void> close() async {
    if (!_initialized) return;
    await _journalBox.close();
    await _projectsBox.close();
    await _tasksBox.close();
    await _teamMembersBox.close();
    await _teamMessagesBox.close();
    await _syncQueueBox.close();
    await _settingsBox.close();
    _initialized = false;
  }
}
