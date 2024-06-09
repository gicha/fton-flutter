import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserKeyData {
  UserKeyData(
    this.mnemonic,
    this.seed,
  );

  factory UserKeyData.fromJson(Map<String, dynamic> json) => UserKeyData(
        (json['mnemonic'] as List).map((e) => e as String).toList(),
        Uint8List.fromList(
          (json['seed'] as List).map((e) => e as int).toList(),
        ),
      );

  final List<String> mnemonic;
  final Uint8List seed;

  Map<String, dynamic> toJson() => {
        'mnemonic': mnemonic,
        'seed': seed,
      };
}

class DataEncryptionController {
  final _store = const FlutterSecureStorage();
  final _key = 'encryption_key';

  Future<void> saveMnemonic(List<String> mnemonic) async {
    final valid = bip39.validateMnemonic(mnemonic.join(' '));
    if (!valid) throw 'Invalid mnemonic';
    final seed = bip39.mnemonicToSeed(mnemonic.join(' '));
    final data = UserKeyData(mnemonic, seed).toJson();
    final dataJson = jsonEncode(data);
    await _store.write(
      key: _key,
      value: dataJson,
    );
  }

  Future<UserKeyData> getData() async {
    final dataJson = await _store.read(key: _key);
    if (dataJson != null) {
      final data = jsonDecode(dataJson) as Map<String, dynamic>;
      return UserKeyData.fromJson(data);
    } else {
      final mnemonic = bip39.generateMnemonic();
      await saveMnemonic(mnemonic.split(' '));
      return getData();
    }
  }

  Future<UserKeyData> generateNew() async {
    final mnemonic = bip39.generateMnemonic();
    await saveMnemonic(mnemonic.split(' '));
    return getData();
  }
}
