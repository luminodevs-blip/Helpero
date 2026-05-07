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

Future deleteAll() async {
  final supabase = SupaFlow.client;

  // 1. Получаем ID текущего авторизованного пользователя
  final userId = supabase.auth.currentUser?.id;

  // Если пользователь не авторизован, прерываем удаление, чтобы ничего не сломать
  if (userId == null) {
    print('Ошибка: Пользователь не авторизован');
    return;
  }

  try {
    // 2. УДАЛЯЕМ ТОЛЬКО СООБЩЕНИЯ ЭТОГО ПОЛЬЗОВАТЕЛЯ
    // Ищем в таблице 'support_messages' строки, где колонка 'user_id' совпадает с ID юзера
    await supabase.from('support_messages').delete().eq('user_id', userId);

    print('История чата успешно удалена для пользователя: $userId');
  } catch (e) {
    print('Ошибка удаления: $e');
  }
}
