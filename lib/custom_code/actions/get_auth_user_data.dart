import 'dart:convert';
import '/backend/supabase/supabase.dart';

Future<dynamic> getAuthUserData() async {
  // Получаем текущего аутентифицированного пользователя из Supabase
  final user = SupaFlow.client.auth.currentUser;
  
  if (user == null) {
    return null;
  }

  // Извлекаем метаданные, которые Supabase получает от провайдеров (Google, Apple и т.д.)
  final metadata = user.userMetadata;
  if (metadata == null) {
    return {
      'email': user.email,
    };
  }

  String? firstName = metadata['given_name'] ?? metadata['first_name'];
  String? lastName = metadata['family_name'] ?? metadata['last_name'];

  // Обработка Apple и других провайдеров, которые могут передавать полное имя одной строкой
  if (metadata['full_name'] != null) {
    final fullName = metadata['full_name'];
    
    // Apple иногда присылает объект {"firstName": "...", "lastName": "..."}
    if (fullName is Map) {
      firstName ??= fullName['firstName']?.toString();
      lastName ??= fullName['lastName']?.toString();
    } 
    // Если это просто строка и мы еще не получили имя/фамилию
    else if (fullName is String && firstName == null) {
      final parts = fullName.trim().split(' ');
      if (parts.isNotEmpty) {
        firstName = parts.first;
        if (parts.length > 1) {
          lastName = parts.sublist(1).join(' ');
        }
      }
    }
  }

  // Запасной вариант для поля 'name'
  if (firstName == null && metadata['name'] != null) {
    final parts = metadata['name'].toString().trim().split(' ');
    firstName = parts.first;
    if (parts.length > 1) {
      lastName = parts.sublist(1).join(' ');
    }
  }

  // Возвращаем JSON объект для использования в FlutterFlow
  return {
    'firstName': firstName ?? '',
    'lastName': lastName ?? '',
    'email': user.email ?? '',
    'phoneNumber': user.phone ?? '',
    'avatarUrl': metadata['avatar_url'] ?? metadata['picture'] ?? '',
  };
}
