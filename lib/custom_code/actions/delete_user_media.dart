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

Future deleteUserMedia() async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return;

  // Имя твоего bucket (замени на своё)
  const bucketName = 'support';

  // Папка пользователя (путь внутри bucket)
  final folderPath = '$userId/';

  // Получаем список файлов в папке пользователя
  final List<FileObject> files =
      await supabase.storage.from(bucketName).list(path: userId);

  if (files.isEmpty) return;

  // Формируем полные пути для удаления
  final List<String> filePaths =
      files.map((file) => '$folderPath${file.name}').toList();

  // Удаляем все файлы
  await supabase.storage.from(bucketName).remove(filePaths);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
