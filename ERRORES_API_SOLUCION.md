# Errores de API y Soluciones Implementadas

## 🔍 Problemas Identificados

### 1. Error 404 - Endpoints No Encontrados
**Problema**: Los endpoints de la API estaban usando rutas complejas que no existen en el servidor Laravel.

**Errores específicos**:
- `404 Not Found` en `/Client_usuarios/auth/login`
- `404 Not Found` en `/Catalog_servicios/servicios`
- `404 Not Found` en múltiples endpoints

**Causa**: Los endpoints estaban configurados con rutas muy específicas que no coinciden con la estructura real del backend Laravel.

### 2. Error "Error al iniciar sesión"
**Problema**: El servidor devuelve un mensaje genérico de error en lugar de información específica.

**Respuesta del servidor**:
```json
{
  "message": "Error al iniciar sesión"
}
```

**Causa**: El endpoint de login no está configurado correctamente o el servidor no está procesando las credenciales adecuadamente.

### 3. Problemas de Conectividad
**Problema**: La aplicación no puede conectarse al servidor Laravel.

**Causas posibles**:
- URL del servidor incorrecta
- Servidor Laravel no está ejecutándose
- Problemas de red/firewall
- Configuración de CORS incorrecta

---

## ✅ Soluciones Implementadas

### 1. Simplificación de Endpoints

**Antes**:
```dart
static const String loginEndpoint = '/Client_usuarios/auth/login';
static const String serviciosEndpoint = '/Catalog_servicios/servicios';
static const String productosEndpoint = '/Catalog_productos/productos';
```

**Después**:
```dart
static const String loginEndpoint = '/auth/login';
static const String serviciosEndpoint = '/services';
static const String productosEndpoint = '/products';
```

### 2. Configuración de URLs Mejorada

**Cambios en `ApiConfig`**:
- URL por defecto cambiada a `http://10.0.2.2:8000/api` (emulador Android)
- Agregadas URLs alternativas para diferentes entornos
- Mejor manejo de timeouts

### 3. Endpoints Simplificados

**Autenticación**:
- `/auth/login` - Login JWT
- `/auth/register` - Registro de usuarios
- `/auth/logout` - Cerrar sesión
- `/user/profile` - Perfil de usuario

**Catálogo**:
- `/services` - Lista de servicios
- `/products` - Lista de productos
- `/categories` - Categorías
- `/services/featured` - Servicios destacados
- `/products/featured` - Productos destacados

**Agendamiento**:
- `/appointments` - Citas
- `/schedules` - Horarios
- `/availability` - Disponibilidad
- `/staff-available` - Personal disponible

**Órdenes**:
- `/orders` - Órdenes
- `/cart` - Carrito
- `/order-details` - Detalles de orden

---

## 🔧 Configuración del Backend Laravel

### Endpoints Requeridos en Laravel

#### 1. Autenticación JWT
```php
// routes/api.php
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/logout', [AuthController::class, 'logout'])->middleware('auth:api');
Route::get('/user/profile', [UserController::class, 'profile'])->middleware('auth:api');
```

#### 2. Catálogo
```php
Route::get('/services', [ServiceController::class, 'index']);
Route::get('/products', [ProductController::class, 'index']);
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/services/featured', [ServiceController::class, 'featured']);
Route::get('/products/featured', [ProductController::class, 'featured']);
```

#### 3. Agendamiento
```php
Route::get('/appointments', [AppointmentController::class, 'index'])->middleware('auth:api');
Route::post('/appointments', [AppointmentController::class, 'store'])->middleware('auth:api');
Route::get('/schedules', [ScheduleController::class, 'index']);
Route::get('/availability', [AvailabilityController::class, 'index']);
```

#### 4. Órdenes
```php
Route::get('/orders', [OrderController::class, 'index'])->middleware('auth:api');
Route::post('/orders', [OrderController::class, 'store'])->middleware('auth:api');
Route::get('/cart', [CartController::class, 'index'])->middleware('auth:api');
```

---

## 🚀 Pasos para Resolver los Errores

### 1. Verificar Servidor Laravel
```bash
# En el directorio del proyecto Laravel
php artisan serve --host=0.0.0.0 --port=8000
```

### 2. Configurar CORS
```php
// config/cors.php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 3. Verificar Rutas API
```bash
php artisan route:list --path=api
```

### 4. Probar Endpoints
```bash
# Test de conectividad
curl http://localhost:8000/api/health

# Test de login
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

---

## 📱 Configuración en Flutter

### 1. URLs de Desarrollo
```dart
// lib/core/config/api_config.dart
static String get baseUrl {
  if (isDevelopment) {
    return 'http://10.0.2.2:8000/api'; // Emulador Android
  }
  return 'https://api.barbermusicaspa.com/api';
}
```

### 2. Manejo de Errores Mejorado
```dart
// lib/core/services/auth_api_service.dart
try {
  final response = await _dio.post(
    ApiConfig.loginEndpoint,
    data: {
      'email': email,
      'password': password,
    },
  );
  
  if (response.statusCode == 200) {
    // Procesar respuesta exitosa
  }
} on DioException catch (e) {
  // Manejar errores específicos
  if (e.response?.statusCode == 404) {
    return {'success': false, 'error': 'Endpoint no encontrado'};
  }
}
```

---

## 🧪 Testing

### 1. Test de Conectividad
```dart
Future<bool> testConnectivity() async {
  try {
    final response = await _dio.get('/health');
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
```

### 2. Test de Login
```dart
Future<bool> testLogin() async {
  try {
    final response = await _dio.post('/auth/login', data: {
      'email': 'test@example.com',
      'password': 'password',
    });
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
```

---

## 📋 Checklist de Verificación

### Backend Laravel
- [ ] Servidor ejecutándose en puerto 8000
- [ ] CORS configurado correctamente
- [ ] Rutas API definidas
- [ ] Middleware de autenticación configurado
- [ ] Base de datos conectada
- [ ] Migraciones ejecutadas

### Frontend Flutter
- [ ] URLs configuradas correctamente
- [ ] Manejo de errores implementado
- [ ] Timeouts configurados
- [ ] Headers de autenticación
- [ ] Testing de conectividad

### Red/Conectividad
- [ ] Emulador conectado a la red
- [ ] Firewall no bloqueando conexiones
- [ ] IP del servidor accesible
- [ ] Puerto 8000 abierto

---

## 🎯 Próximos Pasos

1. **Verificar servidor Laravel**: Asegurar que esté ejecutándose
2. **Configurar endpoints**: Implementar los endpoints simplificados
3. **Testing**: Probar conectividad y autenticación
4. **Debugging**: Revisar logs del servidor para errores específicos
5. **Optimización**: Mejorar manejo de errores y UX

---

## 📞 Soporte

Si los errores persisten después de implementar estas soluciones:

1. Revisar logs del servidor Laravel
2. Verificar configuración de red
3. Probar endpoints con Postman/curl
4. Revisar configuración de CORS
5. Verificar base de datos y migraciones 