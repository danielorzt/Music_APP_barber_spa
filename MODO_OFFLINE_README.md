# 🚀 BarberMusic&Spa - Modo Offline

## 📱 Estado Actual: Funcionando Sin API

La aplicación ha sido configurada para funcionar completamente sin conexión a la API del backend. Todos los datos se muestran usando información simulada (mock data) para que puedas ver y probar todas las funcionalidades del frontend.

## 🔑 Credenciales de Prueba

Para iniciar sesión en la aplicación, usa estas credenciales:

- **Email**: `test@test.com`
- **Contraseña**: `123456`

## 📋 Funcionalidades Disponibles

### ✅ Autenticación
- Login con credenciales simuladas
- Registro de usuarios (simulado)
- Gestión de sesión
- Logout

### ✅ Catálogo de Productos
- Lista de productos con imágenes
- Detalles de productos
- Información de precios y stock
- Categorías de productos

### ✅ Servicios
- Lista de servicios disponibles
- Detalles de servicios
- Precios y duración
- Categorías de servicios

### ✅ Citas/Agendamientos
- Ver citas existentes
- Crear nuevas citas
- Estados de citas (pendiente, confirmado, completado)
- Historial de citas

### ✅ Carrito de Compras
- Agregar productos al carrito
- Gestionar cantidades
- Ver total de compra
- Proceso de checkout (simulado)

### ✅ Perfil de Usuario
- Información del usuario
- Edición de perfil
- Historial de compras y citas

## 🛠️ Archivos Modificados

Los siguientes archivos han sido comentados o modificados para funcionar sin API:

### Repositorios con Datos Mock:
- `lib/core/repositories/auth_repository.dart`
- `lib/core/repositories/product_repository.dart`
- `lib/features/products/repositories/products_repository.dart`
- `lib/features/services/repositories/services_repository.dart`
- `lib/features/appointments/repositories/appointments_repository.dart`

### Servicios de API Comentados:
- `lib/core/api/api_client.dart`
- `lib/core/api/api_interceptors.dart`
- `lib/core/services/api_service.dart`

## 🎯 Datos Simulados Incluidos

### Productos:
1. **Aceite para Barba Premium** - $25,000
2. **Navaja de Afeitar Profesional** - $45,000
3. **Crema de Afeitar Suave** - $18,000
4. **Cepillo para Barba** - $22,000
5. **Aceite Esencial de Lavanda** - $35,000

### Servicios:
1. **Corte Clásico** - $25,000 (30 min)
2. **Afeitado Tradicional** - $18,000 (20 min)
3. **Masaje Relajante** - $45,000 (60 min)
4. **Tratamiento de Barba** - $22,000 (25 min)
5. **Corte + Afeitado** - $35,000 (45 min)
6. **Masaje Descontracturante** - $55,000 (90 min)

### Citas de Ejemplo:
- Cita confirmada para Corte Clásico (próximos 2 días)
- Cita pendiente para Masaje Relajante (próximos 5 días)
- Cita completada para Afeitado Tradicional (hace 3 días)

## 🚀 Cómo Ejecutar

1. **Asegúrate de tener Flutter instalado**
2. **Ejecuta las dependencias**:
   ```bash
   flutter pub get
   ```
3. **Ejecuta la aplicación**:
   ```bash
   flutter run
   ```

## 🔄 Para Volver a Conectar con la API

Cuando quieras conectar la aplicación con el backend real:

1. **Descomenta los archivos de API**:
   - `lib/core/api/api_client.dart`
   - `lib/core/api/api_interceptors.dart`
   - `lib/core/services/api_service.dart`

2. **Descomenta las llamadas a API en los repositorios**:
   - Busca las secciones marcadas como "CÓDIGO ORIGINAL COMENTADO"
   - Descomenta esas secciones
   - Comenta las secciones de datos mock

3. **Actualiza la URL base** en `lib/core/constants/api_endpoints.dart`:
   ```dart
   static const String baseUrl = 'http://tu-ip:puerto/api';
   ```

4. **Ejecuta**:
   ```bash
   flutter pub get
   flutter run
   ```

## 📝 Notas Importantes

- **Todas las operaciones son simuladas**: Los datos no se guardan permanentemente
- **Delays simulados**: Se incluyen delays de 500-1000ms para simular latencia de red
- **Imágenes**: Se usan URLs de Unsplash para las imágenes de productos y servicios
- **Persistencia**: Solo se guarda el token de autenticación en el almacenamiento seguro

## 🎨 Características del Frontend

- **Diseño moderno y responsive**
- **Navegación fluida entre pantallas**
- **Animaciones y transiciones suaves**
- **Temas personalizables**
- **Interfaz intuitiva para usuarios**

## 📞 Soporte

Si encuentras algún problema o necesitas ayuda para reconectar con la API, revisa los archivos comentados y sigue las instrucciones de la sección "Para Volver a Conectar con la API".

---

**¡Disfruta explorando la aplicación BarberMusic&Spa en modo offline! 🎵💈✨** 