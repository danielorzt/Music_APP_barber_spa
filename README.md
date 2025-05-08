# 📱 BarberMusic&Spa - Aplicación Móvil

<div align="center">
  <img src="https://i.imgur.com/your-app-logo-here.png" alt="Logo de BarberMusic&Spa Mobile" width="200"/>
  
  <p><strong>Una experiencia de lujo en la palma de tu mano</strong></p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev/)
  [![Provider](https://img.shields.io/badge/Provider-6.0.5-purple.svg)](https://pub.dev/packages/provider)
  [![Firebase](https://img.shields.io/badge/Firebase-Core-orange.svg)](https://firebase.google.com/)
  [![Dio](https://img.shields.io/badge/Dio-5.4.0-red.svg)](https://pub.dev/packages/dio)
</div>

## 🎵 Experiencia Premium en Spa y Barbería 💈

BarberMusic&Spa es una aplicación móvil de última generación para el sistema de reservas, compras de productos y gestión de citas para la cadena premium de spas y barberías con múltiples sucursales en México.

## 🌟 Características Principales

### 🧔 Experiencia del Cliente
- **Reserva de Citas Intuitiva**: Programa servicios de spa y barbería con solo unos toques
- **Catálogo de Productos**: Explora y compra productos premium para cuidado personal
- **Mapa de Sucursales**: Encuentra la ubicación más cercana con información detallada
- **Perfil Personalizado**: Gestiona tu historial de citas, compras y preferencias
- **Múltiples Métodos de Pago**: Integración con PayPal y MercadoPago

### ✨ Diseño y Experiencia
- **Tema Claro/Oscuro**: Personaliza la apariencia de la aplicación a tu gusto
- **Interfaz Material 3**: Diseño moderno y fluido siguiendo los últimos estándares
- **Animaciones Suaves**: Transiciones elegantes para una experiencia premium
- **Notificaciones**: Recordatorios de citas y ofertas especiales

## 📱 Capturas de Pantalla

<div align="center">
  <img src="https://i.imgur.com/app-screenshot-1.png" alt="Pantalla de Inicio" width="200"/>
  <img src="https://i.imgur.com/app-screenshot-2.png" alt="Reserva de Citas" width="200"/>
  <img src="https://i.imgur.com/app-screenshot-3.png" alt="Tienda" width="200"/>
  <img src="https://i.imgur.com/app-screenshot-4.png" alt="Perfil" width="200"/>
</div>

## 🛠️ Tecnologías Utilizadas

La aplicación está construida con un stack tecnológico moderno:

- **Framework**: Flutter para desarrollo cross-platform
- **Gestión de Estado**: Provider para una arquitectura limpia y mantenible
- **Peticiones HTTP**: Dio para comunicación con la API del backend
- **Persistencia Local**: Shared Preferences para almacenamiento liviano
- **Notificaciones**: Firebase Messaging para notificaciones push
- **Autenticación**: Firebase Auth para manejo seguro de usuarios
- **Localización**: Intl para internacionalización

## 🏗️ Arquitectura

La aplicación sigue una arquitectura limpia y modular:

- **Feature-First**: Organización por características para facilitar el mantenimiento
- **Repository Pattern**: Separación clara entre la fuente de datos y la lógica de negocio
- **Provider**: Gestión de estado reactiva y eficiente
- **Dependency Injection**: Acoplamiento débil entre componentes

```
lib/
├── core/                # Componentes centrales y utilidades
│   ├── services/        # Servicios compartidos
│   └── theme/           # Configuración de temas
└── features/            # Módulos de la aplicación
    ├── auth/            # Autenticación
    ├── appointments/    # Gestión de citas
    ├── products/        # Catálogo de productos
    ├── services/        # Servicios disponibles
    ├── cart/            # Carrito de compras
    └── profile/         # Perfil de usuario
```

## 🚀 Instalación

### Requisitos
- Flutter 3.x o superior
- Dart 3.x o superior
- Android Studio / VS Code
- Emulador o dispositivo físico

### Pasos
1. Clona el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/barbermusic-app.git
   cd barbermusic-app
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Configura Firebase (opcional):
   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## 🔌 Conexión con Backend

La aplicación se conecta con el backend de BarberMusic&Spa a través de una API RESTful:

- Base URL: `http://192.168.1.X:63106/api/v1`
- Endpoints principales:
  - `/auth`: Registro e inicio de sesión
  - `/servicios`: Catálogo de servicios
  - `/productos`: Productos disponibles
  - `/agendamientos`: Gestión de citas
  - `/sucursales`: Ubicaciones disponibles

## 🧪 Características en Desarrollo

- **Pagos In-App**: Procesamiento directo desde la aplicación
- **Escaneo de QR**: Para check-in rápido en la sucursal
- **Chat con Soporte**: Comunicación directa con el personal
- **Realidad Aumentada**: Prueba virtual de estilos de barba y cabello
- **Música Personalizada**: Selección de ambiente durante tu visita

## 👨‍💻 Equipo de Desarrollo

- [Daniel Ortiz](https://github.com/danielorzt) - Desarrollador Principal
- [Carlos Rodriguez](https://github.com/carlos-rodriguez) - Diseño UI/UX
- [Rody Avila](https://github.com/rodyavila) - Gestor de Proyecto

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 📞 Contacto y Soporte

Para consultas o soporte, contáctanos en:
- Email: [support@barbermusicapp.com](mailto:support@barbermusicapp.com)
- Twitter: [@BarberMusicApp](https://twitter.com/BarberMusicApp)

---

<div align="center">
  <p>© 2025 BarberMusic&Spa - Tu estilo, tu música, tu momento</p>
  <p>🎵 Donde la elegancia se encuentra con la relajación 💆‍♂️</p>
</div>
