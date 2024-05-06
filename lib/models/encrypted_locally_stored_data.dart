import 'dart:convert';
import 'dart:io';

import 'package:day_planner/utils/utils.dart';
// import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';

/// Stored user data, in json format, but the whole file needs to be decrypted first
class EncryptedLocallyStoredDataModel {
  static const saveFileName = "data.sav";

  /// Encryption/Decryption key, remove during production, useful during testing
//   final String encryptionKey = "Yaba Daba Doo";

  /// If provided, we can use it to log in the user
  String? loginToken;

  /// Saves data to stored file. Returns false on fail
  Future<bool> saveToStorage() async {
    Directory? appDir = await getAppDir();

    if (appDir == null) return false;

    try {
      final jsonData = jsonEncode({
        "loginToken": loginToken,
      });

      final newFile = await File("${appDir.path}/$saveFileName").create();

      // todo encrypt
      //   final encryptedData = Encryptor.encrypt(encryptionKey, jsonData);

      await newFile.writeAsString(
        jsonData,
        mode: FileMode.write,
      );

      return true;
    } catch (err) {
      debugPrint(err.toString());
    }

    return false;
  }

  /// Load data from file, if failed, it will return false
  Future<bool> loadFromStorage() async {
    final Directory? appDir = await getAppDir();

    if (appDir == null) return false;

    final File saveFile = File("${appDir.path}/$saveFileName");

    if (!saveFile.existsSync()) {
      await saveToStorage();
      return true;
    }

    final saveData = await saveFile.readAsString();

    // final decryptedData = Encryptor.decrypt(encryptionKey, saveData);

    final userDataJson = jsonDecode(saveData);

    if (userDataJson['loginToken'] != null) {
      // not decoding it will leave quotes in the string
      loginToken = userDataJson['loginToken'].toString();
    }

    return true;
  }
}
