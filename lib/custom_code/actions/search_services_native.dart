// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<ServicePackageStruct>> searchServicesNative(
  String queryText,
) async {
  try {
    // Обращаемся к RPC-функции напрямую через родной клиент Supabase
    final response = await SupaFlow.client.rpc(
      'search_services',
      params: {'query': queryText},
    );

    if (response == null || response is! List) return [];

    // Безопасно преобразуем ответ базы данных в Data Type
    List<ServicePackageStruct> results = [];
    for (var item in response) {
      if (item is Map<String, dynamic>) {
        final struct = ServicePackageStruct.maybeFromMap(item);
        if (struct != null) {
          results.add(struct);
        }
      }
    }
    return results;
  } catch (e) {
    debugPrint('Ошибка поиска: $e');
    // В случае ЛЮБОГО сбоя - возвращаем пустой список (спасает от серого экрана)
    return [];
  }
}
