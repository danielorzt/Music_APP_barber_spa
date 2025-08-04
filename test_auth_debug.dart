import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lib/core/services/auth_api_service.dart';
import 'lib/features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 === DEBUG AUTHENTICATION STATUS ===');
  
  // Verificar tokens almacenados
  final prefs = await SharedPreferences.getInstance();
  final jwtToken = prefs.getString('jwt_token');
  final userData = prefs.getString('user_data');
  
  print('🔑 JWT Token: ${jwtToken != null ? '✅ Presente' : '❌ No encontrado'}');
  if (jwtToken != null) {
    print('   Token: ${jwtToken.substring(0, 20)}...');
  }
  
  print('👤 User Data: ${userData != null ? '✅ Presente' : '❌ No encontrado'}');
  if (userData != null) {
    try {
      final user = jsonDecode(userData);
      print('   Usuario: ${user['nombre'] ?? 'N/A'}');
      print('   Email: ${user['email'] ?? 'N/A'}');
    } catch (e) {
      print('   ❌ Error parseando user data: $e');
    }
  }
  
  // Probar servicio de autenticación
  final authService = AuthApiService();
  
  print('\n🔐 === TESTING AUTH SERVICE ===');
  
  try {
    final currentUser = await authService.getCurrentUser();
    print('👤 Current User API: ${currentUser != null ? '✅ Encontrado' : '❌ No encontrado'}');
    if (currentUser != null) {
      print('   Nombre: ${currentUser['nombre'] ?? 'N/A'}');
      print('   Email: ${currentUser['email'] ?? 'N/A'}');
    }
  } catch (e) {
    print('❌ Error obteniendo usuario actual: $e');
  }
  
  // Probar AuthProvider
  print('\n🏗️ === TESTING AUTH PROVIDER ===');
  
  final authProvider = AuthProvider();
  
  // Esperar un poco para que se inicialice
  await Future.delayed(Duration(seconds: 2));
  
  print('🔐 Is Authenticated: ${authProvider.isAuthenticated}');
  print('👤 Current User: ${authProvider.currentUser != null ? '✅ Presente' : '❌ No encontrado'}');
  if (authProvider.currentUser != null) {
    print('   Nombre: ${authProvider.currentUser!['nombre'] ?? 'N/A'}');
    print('   Email: ${authProvider.currentUser!['email'] ?? 'N/A'}');
  }
  print('🌐 API Available: ${authProvider.isApiAvailable}');
  print('❌ Error: ${authProvider.error ?? 'Ninguno'}');
  
  print('\n✅ === DEBUG COMPLETED ===');
} 