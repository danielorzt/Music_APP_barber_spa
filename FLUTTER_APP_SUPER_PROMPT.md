# 🚀 SÚPER PROMPT PARA IA DE FLUTTER - BarberMusic&Spa (BMSPA)

## 📋 CONTEXTO GENERAL DEL PROYECTO

**Nombre del Proyecto:** BarberMusic&Spa (BMSPA)  
**Tipo de Aplicación:** App móvil para clientes (Flutter)  
**Backend:** API Laravel con arquitectura DDD/Hexagonal  
**Objetivo:** Aplicación para que los clientes puedan agendar citas, comprar productos, ver promociones y gestionar su perfil.

---

## 🎯 FUNCIONALIDADES PRINCIPALES A IMPLEMENTAR

### 1. **LISTAR PROMOCIONES** ✅

### 2. **AGREGAR/COMPRAR PRODUCTOS** ✅

### 3. **AGENDAR CITAS** ✅

### 4. **LISTAR CITAS** ✅

---

## 🔐 AUTENTICACIÓN Y SEGURIDAD

### Base URL de la API

```
https://tu-dominio.com/api
```

### Headers requeridos para todas las peticiones autenticadas

```dart
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $token'
}
```

### Flujo de Autenticación

1. **Registro:** `POST /api/Client_usuarios/auth/register`
2. **Login:** `POST /api/Client_usuarios/auth/login`
3. **Logout:** `POST /api/Client_usuarios/auth/logout` (requiere token)

---

## 📱 ENDPOINTS Y ESTRUCTURA DE DATOS

### 🔐 AUTENTICACIÓN

#### 1. REGISTRO DE USUARIO

```http
POST /api/Client_usuarios/auth/register
```

**Body:**

```json
{
  "nombre": "Juan Pérez",
  "email": "juan.perez@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "telefono": "3101234567"
}
```

**Respuesta Exitosa (201):**

```json
{
  "message": "Usuario registrado exitosamente",
  "data": {
    "id": 1,
    "nombre": "Juan Pérez",
    "email": "juan.perez@example.com",
    "rol": "CLIENTE",
    "activo": true
  }
}
```

#### 2. LOGIN DE USUARIO

```http
POST /api/Client_usuarios/auth/login
```

**Body:**

```json
{
  "email": "juan.perez@example.com",
  "password": "password123"
}
```

**Respuesta Exitosa (200):**

```json
{
  "message": "Login exitoso",
  "data": {
    "user": {
      "id": 1,
      "nombre": "Juan Pérez",
      "email": "juan.perez@example.com",
      "rol": "CLIENTE"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### 3. LOGOUT

```http
POST /api/Client_usuarios/auth/logout
```

**Headers:** Requiere token Bearer

---

### 🎉 PROMOCIONES

#### LISTAR TODAS LAS PROMOCIONES

```http
GET /api/Admin_promociones/promociones
```

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "codigo": "VERANO25",
    "nombre": "Descuento de Verano",
    "descripcion": "25% de descuento en todos los servicios",
    "tipo_descuento": "PORCENTAJE",
    "valor_descuento": 25.0,
    "fecha_inicio": "2025-06-01T00:00:00.000000Z",
    "fecha_fin": "2025-08-31T23:59:59.000000Z",
    "usos_maximos_total": 1000,
    "usos_maximos_por_cliente": 1,
    "usos_actuales": 150,
    "activo": true,
    "aplica_a_todos_productos": false,
    "aplica_a_todos_servicios": true
  }
]
```

---

### 🛍️ PRODUCTOS

#### LISTAR TODOS LOS PRODUCTOS

```http
GET /api/Catalog_productos/productos
```

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "nombre": "Cera para Cabello",
    "descripcion": "Cera de fijación fuerte",
    "imagen_path": "productos/cera.jpg",
    "precio": 150.5,
    "stock": 100,
    "sku": "CERA-003",
    "categoria_id": 1,
    "activo": true
  }
]
```

#### CREAR ORDEN DE PRODUCTOS

```http
POST /api/Client_ordenes/ordenes
```

**Headers:** Requiere token Bearer

**Body:**

```json
{
  "notas_orden": "Por favor, envolver para regalo.",
  "detalles": [
    {
      "producto_id": 1,
      "cantidad": 2
    },
    {
      "producto_id": 3,
      "cantidad": 1
    }
  ]
}
```

**Respuesta Exitosa (201):**

```json
{
  "message": "Orden creada exitosamente.",
  "orden_id": 123,
  "data": {
    "id": 123,
    "cliente_usuario_id": 1,
    "subtotal": 450.0,
    "impuestos": 45.0,
    "total": 495.0,
    "estado": "PENDIENTE_PAGO",
    "notas_orden": "Por favor, envolver para regalo.",
    "detalles": [
      {
        "id": 1,
        "producto_id": 1,
        "cantidad": 2,
        "precio_unitario": 150.5,
        "subtotal_linea": 301.0
      }
    ]
  }
}
```

#### LISTAR ÓRDENES DEL CLIENTE

```http
GET /api/Client_ordenes/ordenes
```

**Headers:** Requiere token Bearer

**Respuesta (200):**

```json
[
  {
    "id": 123,
    "cliente_usuario_id": 1,
    "subtotal": 450.00,
    "impuestos": 45.00,
    "total": 495.00,
    "estado": "PAGADA",
    "fecha_creacion": "2025-01-15T10:30:00.000000Z",
    "detalles": [...]
  }
]
```

---

### 📅 AGENDAMIENTOS (CITAS)

#### LISTAR CITAS DEL CLIENTE

```http
GET /api/Scheduling_agendamientos/agendamientos
```

**Headers:** Requiere token Bearer

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "cliente_usuario_id": 1,
    "personal_id": 2,
    "servicio_id": 1,
    "sucursal_id": 1,
    "fecha_hora_inicio": "2025-01-20T10:00:00.000000Z",
    "fecha_hora_fin": "2025-01-20T10:30:00.000000Z",
    "precio_final": 250.0,
    "estado": "PROGRAMADA",
    "notas_cliente": "Por favor, ser puntual.",
    "notas_internas": null,
    "servicio": {
      "id": 1,
      "nombre": "Corte de Cabello",
      "descripcion": "Corte profesional",
      "duracion_minutos": 30,
      "precio": 250.0
    },
    "sucursal": {
      "id": 1,
      "nombre": "Sucursal Centro",
      "direccion": "Calle Principal 123"
    },
    "personal": {
      "id": 2,
      "nombre": "Carlos López",
      "especialidad": "Barbero"
    }
  }
]
```

#### CREAR NUEVA CITA

```http
POST /api/Scheduling_agendamientos/agendamientos
```

**Headers:** Requiere token Bearer

**Body:**

```json
{
  "cliente_usuario_id": 1,
  "personal_id": 2,
  "servicio_id": 1,
  "sucursal_id": 1,
  "fecha_hora_inicio": "2025-01-25T10:00:00.000000Z",
  "fecha_hora_fin": "2025-01-25T10:30:00.000000Z",
  "precio_final": 250.0,
  "estado": "PROGRAMADA",
  "notas_cliente": "Por favor, ser puntual."
}
```

**Respuesta Exitosa (201):**

```json
{
  "message": "Agendamiento creado exitosamente"
}
```

**Respuesta de Error - Conflicto de Horario (409):**

```json
{
  "message": "El horario seleccionado ya no está disponible.",
  "error": "CONFLICTO_HORARIO"
}
```

---

### 🏢 SUCURSALES

#### LISTAR SUCURSALES

```http
GET /api/Admin_sucursales/sucursales
```

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "nombre": "Sucursal Centro",
    "direccion": "Calle Principal 123",
    "telefono": "3101234567",
    "email": "centro@barberspa.com",
    "activo": true,
    "horarios": [
      {
        "id": 1,
        "dia_semana": "LUNES",
        "hora_apertura": "09:00:00",
        "hora_cierre": "18:00:00"
      }
    ]
  }
]
```

---

### 🎯 SERVICIOS

#### LISTAR SERVICIOS

```http
GET /api/Catalog_servicios/servicios
```

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "nombre": "Corte de Cabello",
    "descripcion": "Corte profesional con lavado incluido",
    "duracion_minutos": 30,
    "precio": 250.0,
    "categoria_id": 1,
    "activo": true,
    "categoria": {
      "id": 1,
      "nombre": "Cortes"
    }
  }
]
```

---

### 📝 RESEÑAS

#### LISTAR RESEÑAS PÚBLICAS

```http
GET /api/Client_reseñas/reviews/public
```

**Respuesta (200):**

```json
[
  {
    "id": 1,
    "cliente_usuario_id": 1,
    "servicio_id": 1,
    "sucursal_id": 1,
    "calificacion": 5,
    "comentario": "Excelente servicio, muy profesional",
    "aprobada": true,
    "fecha_creacion": "2025-01-10T15:30:00.000000Z",
    "cliente": {
      "nombre": "Juan Pérez"
    }
  }
]
```

#### CREAR RESEÑA

```http
POST /api/Client_reseñas/reviews
```

**Headers:** Requiere token Bearer

**Body:**

```json
{
  "servicio_id": 1,
  "sucursal_id": 1,
  "calificacion": 5,
  "comentario": "Excelente servicio, muy profesional"
}
```

#### ACTUALIZAR RESEÑA

```http
PUT /api/Client_reseñas/reviews/{id}
```

**Headers:** Requiere token Bearer

**Body:**

```json
{
  "calificacion": 4,
  "comentario": "Muy buen servicio, pero algo lento"
}
```

#### ELIMINAR RESEÑA

```http
DELETE /api/Client_reseñas/reviews/{id}
```

**Headers:** Requiere token Bearer

---

### 🏠 DIRECCIONES

#### LISTAR DIRECCIONES DEL CLIENTE

```http
GET /api/Client_direcciones/direcciones
```

**Headers:** Requiere token Bearer

#### CREAR DIRECCIÓN

```http
POST /api/Client_direcciones/direcciones
```

**Headers:** Requiere token Bearer

**Body:**

```json
{
  "calle": "Calle 123",
  "numero": "45",
  "colonia": "Centro",
  "ciudad": "Ciudad de México",
  "estado": "CDMX",
  "codigo_postal": "06000",
  "es_predeterminada": true
}
```

---

## 🧪 COMANDOS PARA PROBAR LAS APIs

### Usando cURL:

#### 1. REGISTRO

```bash
curl -X POST "https://tu-dominio.com/api/Client_usuarios/auth/register" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "nombre": "Juan Pérez",
    "email": "juan.perez@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "telefono": "3101234567"
  }'
```

#### 2. LOGIN

```bash
curl -X POST "https://tu-dominio.com/api/Client_usuarios/auth/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "juan.perez@example.com",
    "password": "password123"
  }'
```

#### 3. LISTAR PROMOCIONES

```bash
curl -X GET "https://tu-dominio.com/api/Admin_promociones/promociones" \
  -H "Accept: application/json"
```

#### 4. LISTAR PRODUCTOS

```bash
curl -X GET "https://tu-dominio.com/api/Catalog_productos/productos" \
  -H "Accept: application/json"
```

#### 5. LISTAR SERVICIOS

```bash
curl -X GET "https://tu-dominio.com/api/Catalog_servicios/servicios" \
  -H "Accept: application/json"
```

#### 6. LISTAR SUCURSALES

```bash
curl -X GET "https://tu-dominio.com/api/Admin_sucursales/sucursales" \
  -H "Accept: application/json"
```

#### 7. CREAR CITA (con token)

```bash
curl -X POST "https://tu-dominio.com/api/Scheduling_agendamientos/agendamientos" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "cliente_usuario_id": 1,
    "personal_id": 2,
    "servicio_id": 1,
    "sucursal_id": 1,
    "fecha_hora_inicio": "2025-01-25T10:00:00.000000Z",
    "fecha_hora_fin": "2025-01-25T10:30:00.000000Z",
    "precio_final": 250.00,
    "estado": "PROGRAMADA",
    "notas_cliente": "Por favor, ser puntual."
  }'
```

#### 8. LISTAR CITAS DEL CLIENTE

```bash
curl -X GET "https://tu-dominio.com/api/Scheduling_agendamientos/agendamientos" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

#### 9. CREAR ORDEN DE PRODUCTOS

```bash
curl -X POST "https://tu-dominio.com/api/Client_ordenes/ordenes" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "notas_orden": "Por favor, envolver para regalo.",
    "detalles": [
      {
        "producto_id": 1,
        "cantidad": 2
      },
      {
        "producto_id": 3,
        "cantidad": 1
      }
    ]
  }'
```

#### 10. LISTAR ÓRDENES DEL CLIENTE

```bash
curl -X GET "https://tu-dominio.com/api/Client_ordenes/ordenes" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

---

## 📱 ESTRUCTURA SUGERIDA PARA FLUTTER

### Modelos de Datos (Dart)

```dart
// Usuario
class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String rol;
  final bool activo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.activo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
      activo: json['activo'],
    );
  }
}

// Promoción
class Promocion {
  final int id;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final String tipoDescuento;
  final double valorDescuento;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;

  Promocion({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.tipoDescuento,
    required this.valorDescuento,
    required this.fechaInicio,
    this.fechaFin,
    required this.activo,
  });

  factory Promocion.fromJson(Map<String, dynamic> json) {
    return Promocion(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipoDescuento: json['tipo_descuento'],
      valorDescuento: json['valor_descuento'].toDouble(),
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
      activo: json['activo'],
    );
  }
}

// Producto
class Producto {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagenPath;
  final double precio;
  final int stock;
  final String? sku;
  final int? categoriaId;
  final bool activo;

  Producto({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenPath,
    required this.precio,
    required this.stock,
    this.sku,
    this.categoriaId,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenPath: json['imagen_path'],
      precio: json['precio'].toDouble(),
      stock: json['stock'],
      sku: json['sku'],
      categoriaId: json['categoria_id'],
      activo: json['activo'],
    );
  }
}

// Agendamiento (Cita)
class Agendamiento {
  final int id;
  final int clienteUsuarioId;
  final int? personalId;
  final int servicioId;
  final int sucursalId;
  final DateTime fechaHoraInicio;
  final DateTime fechaHoraFin;
  final double precioFinal;
  final String estado;
  final String? notasCliente;
  final Servicio? servicio;
  final Sucursal? sucursal;
  final Personal? personal;

  Agendamiento({
    required this.id,
    required this.clienteUsuarioId,
    this.personalId,
    required this.servicioId,
    required this.sucursalId,
    required this.fechaHoraInicio,
    required this.fechaHoraFin,
    required this.precioFinal,
    required this.estado,
    this.notasCliente,
    this.servicio,
    this.sucursal,
    this.personal,
  });

  factory Agendamiento.fromJson(Map<String, dynamic> json) {
    return Agendamiento(
      id: json['id'],
      clienteUsuarioId: json['cliente_usuario_id'],
      personalId: json['personal_id'],
      servicioId: json['servicio_id'],
      sucursalId: json['sucursal_id'],
      fechaHoraInicio: DateTime.parse(json['fecha_hora_inicio']),
      fechaHoraFin: DateTime.parse(json['fecha_hora_fin']),
      precioFinal: json['precio_final'].toDouble(),
      estado: json['estado'],
      notasCliente: json['notas_cliente'],
      servicio: json['servicio'] != null ? Servicio.fromJson(json['servicio']) : null,
      sucursal: json['sucursal'] != null ? Sucursal.fromJson(json['sucursal']) : null,
      personal: json['personal'] != null ? Personal.fromJson(json['personal']) : null,
    );
  }
}
```

### Servicios API (Dart)

```dart
class ApiService {
  static const String baseUrl = 'https://tu-dominio.com/api';
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Autenticación
  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Client_usuarios/auth/register'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Client_usuarios/auth/login'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // Promociones
  static Future<List<Promocion>> getPromociones() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Admin_promociones/promociones'),
      headers: _headers,
    );

    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Promocion.fromJson(json)).toList();
  }

  // Productos
  static Future<List<Producto>> getProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Catalog_productos/productos'),
      headers: _headers,
    );

    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Producto.fromJson(json)).toList();
  }

  // Agendamientos
  static Future<List<Agendamiento>> getAgendamientos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Scheduling_agendamientos/agendamientos'),
      headers: _headers,
    );

    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Agendamiento.fromJson(json)).toList();
  }

  static Future<Map<String, dynamic>> crearAgendamiento(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Scheduling_agendamientos/agendamientos'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // Órdenes
  static Future<Map<String, dynamic>> crearOrden(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Client_ordenes/ordenes'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
}
```

---

## 🎨 UI/UX SUGERENCIAS

### Pantallas Principales:

1. **Splash Screen** → Login/Registro
2. **Home** → Dashboard con promociones y acceso rápido
3. **Agendar** → Flujo de 5 pasos para crear cita
4. **Tienda** → Catálogo de productos con carrito
5. **Mis Citas** → Lista de citas pasadas y futuras
6. **Perfil** → Información del usuario y configuración

### Estados de Carga:

- Mostrar `CircularProgressIndicator` durante las peticiones
- Manejar errores con `SnackBar` o `AlertDialog`
- Implementar pull-to-refresh en listas

### Gestión de Estado:

- Usar `Provider`, `BLoC/Cubit` o `Riverpod`
- Mantener token en `flutter_secure_storage`
- Cachear datos localmente con `shared_preferences` o `hive`

---

## ⚠️ CONSIDERACIONES IMPORTANTES

### Seguridad:

- **NUNCA** almacenar el token en texto plano
- Usar `flutter_secure_storage` para tokens
- Validar todas las respuestas de la API
- Manejar errores de red graciosamente

### Rendimiento:

- Implementar cache local para datos estáticos
- Usar `ListView.builder` para listas largas
- Optimizar imágenes con `cached_network_image`
- Implementar paginación si es necesario

### UX:

- Mostrar estados de carga apropiados
- Validar formularios en tiempo real
- Proporcionar feedback visual inmediato
- Implementar navegación intuitiva

---

## 🚀 COMANDOS PARA INICIAR EL PROYECTO FLUTTER

```bash
# Crear nuevo proyecto
flutter create bmspa_client_app

# Navegar al proyecto
cd bmspa_client_app

# Agregar dependencias necesarias
flutter pub add http
flutter pub add provider
flutter pub add shared_preferences
flutter pub add flutter_secure_storage
flutter pub add cached_network_image
flutter pub add intl
flutter pub add image_picker

# Ejecutar la aplicación
flutter run
```

---

## 📞 SOPORTE Y CONTACTO

Si necesitas ayuda adicional con la implementación:

- Revisa la documentación de Flutter
- Consulta los logs de la API para debugging
- Verifica que todos los endpoints estén funcionando
- Prueba primero con Postman o cURL antes de implementar en Flutter

¡Buena suerte con tu aplicación de BarberMusic&Spa! 🎉
