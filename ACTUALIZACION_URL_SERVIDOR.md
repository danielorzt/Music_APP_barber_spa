# 🔄 ACTUALIZACIÓN DE URL DEL SERVIDOR

## 📍 **CAMBIO REALIZADO**

**URL Anterior:** `http://172.30.7.51:8000/api`
**URL Nueva:** `http://192.168.254.47:8000/api`

## 📁 **ARCHIVOS MODIFICADOS**

### 1. **`lib/core/config/api_config.dart`** ✅
```dart
// ANTES
static const String baseUrlDevelopment = 'http://172.30.7.51:8000/api';
static const String baseUrlNetwork = 'http://192.168.1.100:8000/api';

// DESPUÉS
static const String baseUrlDevelopment = 'http://192.168.254.47:8000/api';
static const String baseUrlNetwork = 'http://192.168.254.47:8000/api';
```

### 2. **`lib/core/config/dev_config.dart`** ✅
```dart
// ANTES
static const String serverUrl = 'http://172.30.7.51:8000';

// DESPUÉS
static const String serverUrl = 'http://192.168.254.47:8000';
```

### 3. **`test_jwt_login.dart`** ✅
```dart
// ANTES
static const String baseUrl = 'http://172.30.7.51:8000/api';

// DESPUÉS
static const String baseUrl = 'http://192.168.254.47:8000/api';
```

## 🧪 **PRUEBAS RECOMENDADAS**

### 1. **Verificar Conectividad**
```bash
# Ejecutar pruebas de conectividad
dart test_jwt_login.dart
```

### 2. **Compilar la Aplicación**
```bash
# Verificar que no hay errores de compilación
flutter analyze

# Compilar para verificar
flutter build apk --debug
```

### 3. **Probar desde la Aplicación**
- Ir a la pantalla de configuración API
- Verificar que el servidor se conecta correctamente
- Probar login y registro

## 📊 **URLS ACTUALIZADAS**

### **URLs Principales:**
- **Desarrollo:** `http://192.168.254.47:8000/api`
- **Red Local:** `http://192.168.254.47:8000/api`
- **Localhost:** `http://localhost:8000/api` (sin cambios)
- **Emulador:** `http://10.0.2.2:8000/api` (sin cambios)
- **Producción:** `https://api.barbermusicaspa.com/api` (sin cambios)

### **Endpoints de Prueba:**
- **Health Check:** `http://192.168.254.47:8000/api/health`
- **Login:** `http://192.168.254.47:8000/api/Client_usuarios/auth/login`
- **Registro:** `http://192.168.254.47:8000/api/Client_usuarios/auth/register`

## ✅ **VERIFICACIÓN**

Para verificar que todo funciona correctamente:

1. **Asegúrate de que tu servidor Laravel esté corriendo en:**
   ```bash
   php artisan serve --host=192.168.254.47 --port=8000
   ```

2. **Verifica la conectividad desde tu dispositivo:**
   ```bash
   # Desde tu dispositivo
   curl http://192.168.254.47:8000/api/health
   ```

3. **Ejecuta las pruebas de conectividad:**
   ```bash
   dart test_jwt_login.dart
   ```

## 🚨 **POSIBLES PROBLEMAS**

### **Si no se conecta:**

1. **Verificar que el servidor esté corriendo:**
   ```bash
   # En el servidor Laravel
   php artisan serve --host=0.0.0.0 --port=8000
   ```

2. **Verificar firewall:**
   - Asegúrate de que el puerto 8000 esté abierto
   - Verifica que no haya restricciones de red

3. **Verificar conectividad de red:**
   ```bash
   # Desde tu dispositivo
   ping 192.168.254.47
   ```

## 📞 **SOPORTE**

Si tienes problemas de conectividad:

1. **Verifica que el servidor esté corriendo**
2. **Verifica la IP del servidor**
3. **Verifica que estés en la misma red**
4. **Ejecuta las pruebas de conectividad**

**¡Los cambios están listos! Tu aplicación ahora apunta a tu nuevo servidor local.** 