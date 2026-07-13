import 'package:flutter/material.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  AsyncResult<String> saveData(String key, String value) async {
    debugPrint('saveData $key');

    // Time de 500ms para simular latencia da rede
    // await Future.delayed(const Duration(milliseconds: 100));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return Success(value);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<String> getData(String key) async {
    // Time de 500ms para simular latencia da rede
    // await Future.delayed(const Duration(milliseconds: 100));

    debugPrint('getData $key');

    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (value != null) {
        return Success(value);
      } else {
        return Failure(
          LocalStorageException('Nenhum dado encontrado para a chave: $key'), //
        );
      }
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }

  AsyncResult<Unit> deleteData(String key) async {
    debugPrint('deleteData $key');

    // Time de 2s para simular latencia da rede
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return Success(unit);
    } catch (e, s) {
      return Failure(LocalStorageException(e.toString(), s));
    }
  }
}
