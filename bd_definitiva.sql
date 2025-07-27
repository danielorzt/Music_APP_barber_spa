-- ===================================================================
-- SCRIPT FINAL Y COMPLETO v2
-- INCLUYE TODAS LAS TABLAS DEL DUMP ORIGINAL Y SUS INSERCIONES
-- ===================================================================

-- PASO 1: REINICIO TOTAL DE LA BASE DE DATOS
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS
    `direcciones`, `especialidades`, `horarios_sucursal`, `reseñas`, `especialidad_personal`,
    `sessions`, `personal`, `servicio_sucursal`, `agendamientos`, `detalle_ordenes`,
    `transacciones_pago`, `sucursales`, `musica_preferencias_navegacion`, `ordenes`,
    `excepciones_horario_sucursal`, `servicio_personal`, `producto_promocion`,
    `categorias`, `usuarios`, `recordatorios`, `servicios`, `promocion_servicio`, `promociones`, `productos`;
SET FOREIGN_KEY_CHECKS = 1;


-- PASO 2: CREACIÓN DE LA ESTRUCTURA COMPLETA DE TABLAS

-- Tabla: musica_preferencias_navegacion
CREATE TABLE `musica_preferencias_navegacion` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_opcion` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `stream_url_ejemplo` varchar(512) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `musica_preferencias_navegacion_nombre_opcion_unique` (`nombre_opcion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: categorias
CREATE TABLE `categorias` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_categoria` varchar(50) NOT NULL,
  `icono_clave` varchar(50) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorias_nombre_unique` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: especialidades
CREATE TABLE `especialidades` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono_clave` varchar(50) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `especialidades_nombre_unique` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: sucursales
CREATE TABLE `sucursales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `imagen_path` varchar(255) DEFAULT NULL,
  `telefono_contacto` varchar(25) DEFAULT NULL,
  `email_contacto` varchar(255) DEFAULT NULL,
  `link_maps` varchar(512) DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sucursales_email_contacto_unique` (`email_contacto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: usuarios
CREATE TABLE `usuarios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `imagen_path` varchar(255) DEFAULT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  `rol` varchar(50) NOT NULL DEFAULT 'CLIENTE',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `musica_preferencia_navegacion_id` bigint(20) unsigned DEFAULT NULL,
  `sucursal_preferida_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuarios_email_unique` (`email`),
  KEY `usuarios_musica_preferencia_navegacion_id_foreign` (`musica_preferencia_navegacion_id`),
  KEY `usuarios_sucursal_preferida_id_foreign` (`sucursal_preferida_id`),
  CONSTRAINT `usuarios_musica_preferencia_navegacion_id_foreign` FOREIGN KEY (`musica_preferencia_navegacion_id`) REFERENCES `musica_preferencias_navegacion` (`id`) ON DELETE SET NULL,
  CONSTRAINT `usuarios_sucursal_preferida_id_foreign` FOREIGN KEY (`sucursal_preferida_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: personal
CREATE TABLE `personal` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint(20) unsigned NOT NULL,
  `sucursal_asignada_id` bigint(20) unsigned DEFAULT NULL,
  `tipo_personal` varchar(50) NOT NULL,
  `numero_empleado` varchar(50) DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `activo_en_empresa` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_usuario_id_unique` (`usuario_id`),
  UNIQUE KEY `personal_numero_empleado_unique` (`numero_empleado`),
  KEY `personal_sucursal_asignada_id_foreign` (`sucursal_asignada_id`),
  CONSTRAINT `personal_sucursal_asignada_id_foreign` FOREIGN KEY (`sucursal_asignada_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL,
  CONSTRAINT `personal_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: servicios
CREATE TABLE `servicios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_path` varchar(255) DEFAULT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `duracion_minutos` int(10) unsigned NOT NULL,
  `categoria_id` bigint(20) unsigned DEFAULT NULL,
  `especialidad_requerida_id` bigint(20) unsigned DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `servicios_categoria_id_foreign` (`categoria_id`),
  KEY `servicios_especialidad_requerida_id_foreign` (`especialidad_requerida_id`),
  CONSTRAINT `servicios_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  CONSTRAINT `servicios_especialidad_requerida_id_foreign` FOREIGN KEY (`especialidad_requerida_id`) REFERENCES `especialidades` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: productos
CREATE TABLE `productos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_path` varchar(255) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(10) unsigned NOT NULL DEFAULT 0,
  `sku` varchar(100) DEFAULT NULL,
  `categoria_id` bigint(20) unsigned DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `productos_sku_unique` (`sku`),
  KEY `productos_categoria_id_foreign` (`categoria_id`),
  CONSTRAINT `productos_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: promociones
CREATE TABLE `promociones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `tipo_descuento` varchar(50) NOT NULL,
  `valor_descuento` decimal(10,2) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `usos_maximos_total` int(10) unsigned DEFAULT NULL,
  `usos_maximos_por_cliente` int(10) unsigned DEFAULT 1,
  `usos_actuales` int(10) unsigned NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `aplica_a_todos_productos` tinyint(1) NOT NULL DEFAULT 0,
  `aplica_a_todos_servicios` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `promociones_codigo_unique` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: agendamientos
CREATE TABLE `agendamientos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_usuario_id` bigint(20) unsigned NOT NULL,
  `personal_id` bigint(20) unsigned DEFAULT NULL,
  `servicio_id` bigint(20) unsigned NOT NULL,
  `sucursal_id` bigint(20) unsigned NOT NULL,
  `fecha_hora_inicio` datetime NOT NULL,
  `fecha_hora_fin` datetime NOT NULL,
  `precio_final` decimal(10,2) NOT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'PROGRAMADA',
  `notas_cliente` text DEFAULT NULL,
  `notas_internas` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `agendamientos_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `agendamientos_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE SET NULL,
  CONSTRAINT `agendamientos_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`),
  CONSTRAINT `agendamientos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: ordenes
CREATE TABLE `ordenes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_usuario_id` bigint(20) unsigned NOT NULL,
  `numero_orden` varchar(50) NOT NULL,
  `fecha_orden` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_recibida` datetime DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `impuestos_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_orden` decimal(10,2) NOT NULL,
  `estado_orden` varchar(50) NOT NULL DEFAULT 'PENDIENTE_PAGO',
  `notas_orden` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ordenes_numero_orden_unique` (`numero_orden`),
  CONSTRAINT `ordenes_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: transacciones_pago
CREATE TABLE `transacciones_pago` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `orden_id` bigint(20) unsigned DEFAULT NULL,
  `agendamiento_id` bigint(20) unsigned DEFAULT NULL,
  `cliente_usuario_id` bigint(20) unsigned NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `moneda` varchar(10) NOT NULL DEFAULT 'MXN',
  `metodo_pago` varchar(100) NOT NULL,
  `id_transaccion_pasarela` varchar(255) DEFAULT NULL,
  `estado_pago` varchar(50) NOT NULL,
  `fecha_transaccion` datetime NOT NULL DEFAULT current_timestamp(),
  `datos_pasarela_request` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_pasarela_request`)),
  `datos_pasarela_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_pasarela_response`)),
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transacciones_pago_id_transaccion_pasarela_unique` (`id_transaccion_pasarela`),
  CONSTRAINT `transacciones_pago_agendamiento_id_foreign` FOREIGN KEY (`agendamiento_id`) REFERENCES `agendamientos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `transacciones_pago_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `transacciones_pago_orden_id_foreign` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: recordatorios
CREATE TABLE `recordatorios` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint(20) unsigned NOT NULL,
  `agendamiento_id` bigint(20) unsigned DEFAULT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_hora_recordatorio` datetime NOT NULL,
  `canal_notificacion` varchar(50) NOT NULL DEFAULT 'EMAIL',
  `enviado` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_envio` datetime DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fijado` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `recordatorios_agendamiento_id_foreign` FOREIGN KEY (`agendamiento_id`) REFERENCES `agendamientos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `recordatorios_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: direcciones (Polimórfica)
CREATE TABLE `direcciones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `direccionable_id` bigint(20) unsigned NOT NULL,
  `direccionable_type` varchar(255) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `colonia` varchar(100) NOT NULL,
  `codigo_postal` varchar(10) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `estado` varchar(100) NOT NULL,
  `referencias` text DEFAULT NULL,
  `es_predeterminada` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `direcciones_direccionable_id_direccionable_type_index` (`direccionable_id`,`direccionable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: reseñas (Polimórfica)
CREATE TABLE `reseñas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cliente_usuario_id` bigint(20) unsigned NOT NULL,
  `calificacion` tinyint(3) unsigned NOT NULL,
  `comentario` text DEFAULT NULL,
  `reseñable_id` bigint(20) unsigned NOT NULL,
  `reseñable_type` varchar(255) NOT NULL,
  `aprobada` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_reseña` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `reseñas_reseñable_id_reseñable_type_index` (`reseñable_id`,`reseñable_type`),
  CONSTRAINT `reseñas_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: horarios_sucursal
CREATE TABLE `horarios_sucursal` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sucursal_id` bigint(20) unsigned NOT NULL,
  `dia_semana` tinyint(3) unsigned NOT NULL,
  `hora_apertura` time DEFAULT NULL,
  `hora_cierre` time DEFAULT NULL,
  `esta_cerrado_regularmente` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `horarios_sucursal_sucursal_id_dia_semana_unique` (`sucursal_id`,`dia_semana`),
  CONSTRAINT `horarios_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: excepciones_horario_sucursal
CREATE TABLE `excepciones_horario_sucursal` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sucursal_id` bigint(20) unsigned NOT NULL,
  `fecha` date NOT NULL,
  `esta_cerrado` tinyint(1) NOT NULL DEFAULT 1,
  `hora_apertura` time DEFAULT NULL,
  `hora_cierre` time DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `excepciones_horario_sucursal_sucursal_id_fecha_index` (`sucursal_id`,`fecha`),
  CONSTRAINT `excepciones_horario_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: detalle_ordenes
CREATE TABLE `detalle_ordenes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `orden_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `nombre_producto_historico` varchar(255) NOT NULL,
  `cantidad` int(10) unsigned NOT NULL,
  `precio_unitario_historico` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `detalle_ordenes_orden_id_foreign` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `detalle_ordenes_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tablas PIVOT (Many-to-Many)
CREATE TABLE `especialidad_personal` (
  `especialidad_id` bigint(20) unsigned NOT NULL,
  `personal_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`especialidad_id`,`personal_id`),
  CONSTRAINT `especialidad_personal_especialidad_id_foreign` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`) ON DELETE CASCADE,
  CONSTRAINT `especialidad_personal_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `servicio_personal` (
  `servicio_id` bigint(20) unsigned NOT NULL,
  `personal_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`servicio_id`,`personal_id`),
  CONSTRAINT `servicio_personal_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE CASCADE,
  CONSTRAINT `servicio_personal_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `servicio_sucursal` (
  `servicio_id` bigint(20) unsigned NOT NULL,
  `sucursal_id` bigint(20) unsigned NOT NULL,
  `precio_en_sucursal` decimal(10,2) DEFAULT NULL,
  `esta_disponible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`servicio_id`,`sucursal_id`),
  CONSTRAINT `servicio_sucursal_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `servicio_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `producto_promocion` (
  `promocion_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`promocion_id`,`producto_id`),
  CONSTRAINT `producto_promocion_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `producto_promocion_promocion_id_foreign` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `promocion_servicio` (
  `promocion_id` bigint(20) unsigned NOT NULL,
  `servicio_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`promocion_id`,`servicio_id`),
  CONSTRAINT `promocion_servicio_promocion_id_foreign` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `promocion_servicio_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla `sessions` (Típica de Laravel, opcional para Spring Boot pero incluida por completitud)
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- PASO 3: INSERCIÓN DE DATOS DE EJEMPLO
INSERT INTO `musica_preferencias_navegacion` (id, nombre_opcion, descripcion, stream_url_ejemplo, activo) VALUES
(1, 'Jazz Relajante', 'Música jazz suave para ambiente de relajación', 'https://stream.jazz-relax.com', 1),
(2, 'Música Clásica', 'Composiciones clásicas para spa', 'https://stream.classical-spa.com', 1),
(3, 'Música Ambient', 'Sonidos ambientales y electrónicos suaves', 'https://stream.ambient-chill.com', 1),
(4, 'Reggaeton Suave', 'Reggaeton moderno con volumen bajo', 'https://stream.reggaeton-soft.com', 1),
(5, 'Sin Música', 'Ambiente natural sin música de fondo', NULL, 1);

INSERT INTO `categorias` (id, nombre, descripcion, tipo_categoria, icono_clave, activo) VALUES
(1, 'Tratamientos Faciales', 'Servicios especializados para el cuidado facial', 'SERVICIO', 'FACIAL_CARE', 1),
(2, 'Tratamientos Corporales', 'Servicios para el cuidado y relajación corporal', 'SERVICIO', 'BODY_CARE', 1),
(3, 'Tratamientos Estéticos', 'Procedimientos estéticos avanzados', 'SERVICIO', 'AESTHETIC_CARE', 1),
(4, 'Masajes', 'Diferentes tipos de masajes terapéuticos', 'SERVICIO', 'MASSAGE', 1),
(5, 'Productos Faciales', 'Cremas, serums y productos para el rostro', 'PRODUCTO', 'FACIAL_PRODUCTS', 1),
(6, 'Productos Corporales', 'Lociones, aceites y productos corporales', 'PRODUCTO', 'BODY_PRODUCTS', 1),
(7, 'Equipos de Belleza', 'Dispositivos y herramientas de belleza', 'PRODUCTO', 'BEAUTY_TOOLS', 1);

INSERT INTO `especialidades` (id, nombre, descripcion, icono_clave, activo) VALUES
(1, 'Tratamientos Láser', 'Especialista en procedimientos con láser médico', 'LASER_SPECIALIST', 1),
(2, 'Masajes Terapéuticos', 'Especialista en masajes de relajación y terapéuticos', 'MASSAGE_THERAPIST', 1),
(3, 'Estética Facial', 'Especialista en cuidados y tratamientos faciales', 'FACIAL_SPECIALIST', 1),
(4, 'Tratamientos Corporales', 'Especialista en procedimientos corporales no invasivos', 'BODY_SPECIALIST', 1),
(5, 'Cosmetología', 'Especialista en cosmetología integral', 'COSMETOLOGY', 1),
(6, 'Depilación', 'Especialista en técnicas de depilación avanzada', 'HAIR_REMOVAL', 1);

INSERT INTO `sucursales` (id, nombre, imagen_path, telefono_contacto, email_contacto, link_maps, latitud, longitud, activo) VALUES
(1, 'Villahermosa - Plaza Strada', '/assets/img/sucursal1.jpg', '+52 938 160 4378', 'strada@barbermusicaspa.com', 'https://maps.google.com/?q=Villahermosa+Plaza+Strada', 17.9889000, -92.9303000, 1),
(2, 'San Luis Potosí - Plaza San Luis', '/assets/img/sucursal2.jpg', '+52 444 334 0295', 'slp@barbermusicaspa.com', 'https://maps.google.com/?q=San+Luis+Potosi+Plaza+San+Luis', 22.1565000, -100.9855000, 1),
(3, 'Villahermosa - Plaza Altabrisa', '/assets/img/sucursal3.jpg', '+52 938 106 1531', 'altabrisa@barbermusicaspa.com', 'https://maps.google.com/?q=Villahermosa+Plaza+Altabrisa', 17.9970000, -92.9180000, 1),
(4, 'Coatzacoalcos - Plaza Forum', '/assets/img/sucursal4.jpg', '+52 921 145 8851', 'coatza@barbermusicaspa.com', 'https://maps.google.com/?q=Coatzacoalcos+Plaza+Forum', 18.1340000, -94.4583000, 1),
(5, 'Ciudad del Carmen - Plaza Zentralia', '/assets/img/sucursal5.jpg', '+52 938 106 1531', 'carmen@barbermusicaspa.com', 'https://maps.google.com/?q=Ciudad+Carmen+Plaza+Zentralia', 18.6500000, -91.8333000, 1),
(6, 'Mérida - Plaza Altabrisa', '/assets/img/sucursal6.jpg', '+52 999 503 8545', 'merida@barbermusicaspa.com', 'https://maps.google.com/?q=Merida+Plaza+Altabrisa', 20.9674000, -89.5926000, 1),
(7, 'Villahermosa - Plaza Las Américas', '/assets/img/sucursal7.jpg', '+52 921 145 8851', 'americas@barbermusicaspa.com', 'https://maps.google.com/?q=Villahermosa+Plaza+Americas', 17.9950000, -92.9400000, 1);

INSERT INTO `usuarios` (id, nombre, email, email_verified_at, password, imagen_path, telefono, rol, activo, musica_preferencia_navegacion_id, sucursal_preferida_id) VALUES
(1, 'Carlos Rodríguez', 'admin@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/admin.jpg', '+52 555 000 0001', 'ADMIN_GENERAL', 1, 1, 1),
(2, 'María González', 'admin.strada@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/admin2.jpg', '+52 938 160 4379', 'EMPLEADO', 1, 2, 1),
(3, 'José Martínez', 'admin.slp@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/admin3.jpg', '+52 444 334 0296', 'EMPLEADO', 1, 3, 2),
(4, 'Ana López', 'admin.altabrisa@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/admin4.jpg', '+52 938 106 1532', 'EMPLEADO', 1, 1, 3),
(5, 'Dr. Laura Fernández', 'laura.fernandez@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/empleado1.jpg', '+52 938 160 4380', 'EMPLEADO', 1, 1, 1),
(6, 'Lic. Patricia Morales', 'patricia.morales@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/empleado2.jpg', '+52 444 334 0297', 'EMPLEADO', 1, 2, 2),
(7, 'Sofia Castillo', 'sofia.castillo@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/empleado3.jpg', '+52 938 106 1533', 'EMPLEADO', 1, 3, 3),
(8, 'Miguel Herrera', 'miguel.herrera@barbermusicaspa.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/empleado4.jpg', '+52 921 145 8852', 'EMPLEADO', 1, 4, 4),
(9, 'Alejandra Vázquez', 'alejandra.vazquez@gmail.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/cliente1.jpg', '+52 938 200 0001', 'CLIENTE', 1, 1, 1),
(10, 'Roberto Silva', 'roberto.silva@gmail.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/cliente2.jpg', '+52 444 500 0002', 'CLIENTE', 1, 2, 2),
(11, 'Carmen Jiménez', 'carmen.jimenez@hotmail.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/cliente3.jpg', '+52 999 600 0003', 'CLIENTE', 1, 3, 6),
(12, 'Fernando Torres', 'fernando.torres@yahoo.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '/assets/img/cliente4.jpg', '+52 921 700 0004', 'CLIENTE', 1, 4, 4);

INSERT INTO `personal` (id, usuario_id, sucursal_asignada_id, tipo_personal, numero_empleado, fecha_contratacion, activo_en_empresa) VALUES
(1, 2, 1, 'ADMIN_SUCURSAL', 'EMP001', '2023-01-15', 1),
(2, 3, 2, 'ADMIN_SUCURSAL', 'EMP002', '2023-02-01', 1),
(3, 4, 3, 'ADMIN_SUCURSAL', 'EMP003', '2023-02-15', 1),
(4, 5, 1, 'ESTILISTA', 'EMP004', '2023-03-01', 1),
(5, 6, 2, 'MASAJISTA', 'EMP005', '2023-03-15', 1),
(6, 7, 3, 'ESTILISTA', 'EMP006', '2023-04-01', 1),
(7, 8, 4, 'MASAJISTA', 'EMP007', '2023-04-15', 1);

INSERT INTO `servicios` (id, nombre, descripcion, imagen_path, precio_base, duracion_minutos, categoria_id, especialidad_requerida_id, activo) VALUES
(1, 'Tratamiento Sculpsure', 'Reducción de grasa corporal con tecnología láser no invasiva', '/assets/img/sculpsure.jpg', 2500.00, 45, 3, 1, 1),
(2, 'Tratamiento Hifu', 'Lifting facial con ultrasonido focalizado de alta intensidad', '/assets/img/hifu.jpg', 3500.00, 60, 1, 3, 1),
(3, 'Radiofrecuencia Facial', 'Rejuvenecimiento facial con radiofrecuencia', '/assets/img/radiofrecuencia.jpg', 1800.00, 45, 1, 3, 1),
(4, 'Hidradermoabrasión', 'Exfoliación profunda e hidratación facial', '/assets/img/hidradermoabrasion.jpg', 1200.00, 60, 1, 3, 1),
(5, 'Microdermoabrasión', 'Renovación celular y mejora de textura de la piel', '/assets/img/microdermoabrasion.jpg', 900.00, 45, 1, 5, 1),
(6, 'Hollywood Peel', 'Tratamiento facial con láser de carbón activado', '/assets/img/hollywood-peel.jpg', 2200.00, 50, 1, 1, 1),
(7, 'Eliminación de Tatuajes', 'Remoción de tatuajes con láser Q-Switch', '/assets/img/laser-tattoo.jpg', 1500.00, 30, 3, 1, 1),
(8, 'Despigmentación', 'Tratamiento para manchas y despigmentación', '/assets/img/despigmentacion.jpg', 1800.00, 45, 1, 3, 1),
(9, 'Levantamiento de Glúteos', 'Tonificación y levantamiento de glúteos no invasivo', '/assets/img/gluteos.jpg', 2800.00, 60, 2, 4, 1),
(10, 'Maderoterapia', 'Masaje con elementos de madera para modelar el cuerpo', '/assets/img/maderoterapia.jpg', 800.00, 60, 4, 2, 1),
(11, 'Lipo Sin Cirugía', 'Reducción de medidas sin procedimientos invasivos', '/assets/img/lipo-sin-cirugia.jpg', 2200.00, 90, 2, 4, 1),
(12, 'Criolipólisis', 'Eliminación de grasa localizada con frío controlado', '/assets/img/criolipolisis.jpg', 3000.00, 60, 2, 4, 1),
(13, 'Limpieza Facial', 'Limpieza profunda y extracción de impurezas', '/assets/img/limpieza-facial.jpg', 650.00, 75, 1, 5, 1),
(14, 'Eliminación de Celulitis', 'Tratamiento integral para reducir la celulitis', '/assets/img/celulitis.jpg', 1500.00, 60, 2, 4, 1),
(15, 'Masaje Relajante', 'Masaje terapéutico para relajación y bienestar', '/assets/img/masaje-relajante.jpg', 950.00, 60, 4, 2, 1),
(16, 'Depilación Definitiva - LASER SHR', 'Depilación permanente con tecnología SHR', '/assets/img/depilacion-laser.jpg', 800.00, 30, 3, 6, 1);

INSERT INTO `productos` (id, nombre, descripcion, imagen_path, precio, stock, sku, categoria_id, activo) VALUES
(1, 'Sérum Vitamina C Premium', 'Sérum antioxidante con vitamina C pura al 20%', '/assets/img/serum-vitc.jpg', 450.00, 50, 'SER-VITC-001', 5, 1),
(2, 'Crema Hidratante Facial SPF30', 'Hidratante con protección solar para uso diario', '/assets/img/crema-spf30.jpg', 380.00, 75, 'CRE-SPF30-002', 5, 1),
(3, 'Aceite Corporal Relajante', 'Aceite natural con aromaterapia para masajes', '/assets/img/aceite-relax.jpg', 280.00, 60, 'ACE-REL-003', 6, 1),
(4, 'Exfoliante Corporal Marino', 'Exfoliante con sales minerales del mar', '/assets/img/exfoliante-marino.jpg', 320.00, 40, 'EXF-MAR-004', 6, 1),
(5, 'Mascarilla Purificante', 'Mascarilla de arcilla para pieles grasas', '/assets/img/mascarilla-pure.jpg', 180.00, 85, 'MAS-PUR-005', 5, 1),
(6, 'Loción Reafirmante', 'Loción corporal con efecto tensor y reafirmante', '/assets/img/locion-reaf.jpg', 520.00, 30, 'LOC-REA-006', 6, 1),
(7, 'Kit Cuidado Facial Completo', 'Set completo para rutina facial diaria', '/assets/img/kit-facial.jpg', 1200.00, 25, 'KIT-FAC-007', 5, 1),
(8, 'Rodillo Facial Jade', 'Herramienta de jade para masaje facial', '/assets/img/rodillo-jade.jpg', 220.00, 45, 'ROD-JAD-008', 7, 1);

INSERT INTO `promociones` (id, codigo, nombre, descripcion, tipo_descuento, valor_descuento, fecha_inicio, fecha_fin, usos_maximos_total, usos_maximos_por_cliente, usos_actuales, activo, aplica_a_todos_productos, aplica_a_todos_servicios) VALUES
(1, 'BIENVENIDA20', 'Descuento de Bienvenida', '20% de descuento en tu primera visita', 'PORCENTAJE', 20.00, '2024-01-01 00:00:00', '2024-12-31 23:59:59', 1000, 1, 0, 1, 0, 1),
(2, 'FACIAL50', 'Promoción Tratamientos Faciales', '$50 pesos de descuento en tratamientos faciales', 'MONTO_FIJO', 50.00, '2024-07-01 00:00:00', '2024-08-31 23:59:59', 500, 2, 0, 1, 0, 0),
(3, 'PRODUCTOS15', 'Descuento en Productos', '15% de descuento en todos los productos', 'PORCENTAJE', 15.00, '2024-06-01 00:00:00', '2024-09-30 23:59:59', 300, 3, 0, 1, 1, 0);

INSERT INTO `agendamientos` (id, cliente_usuario_id, personal_id, servicio_id, sucursal_id, fecha_hora_inicio, fecha_hora_fin, precio_final, estado, notas_cliente, notas_internas) VALUES
(1, 9, 4, 2, 1, '2025-07-25 10:00:00', '2025-07-25 11:00:00', 3500.00, 'CONFIRMADA', 'Primera vez con tratamiento Hifu', 'Cliente muy puntual'),
(2, 10, 5, 15, 2, '2025-07-26 14:00:00', '2025-07-26 15:00:00', 950.00, 'PROGRAMADA', 'Masaje para estrés laboral', NULL),
(3, 11, 6, 13, 3, '2025-07-27 11:30:00', '2025-07-27 12:45:00', 650.00, 'PROGRAMADA', 'Limpieza facial mensual', 'Cliente frecuente'),
(4, 12, 7, 10, 4, '2025-07-28 16:00:00', '2025-07-28 17:00:00', 800.00, 'PROGRAMADA', 'Primera sesión de maderoterapia', NULL);

INSERT INTO `ordenes` (id, cliente_usuario_id, numero_orden, fecha_orden, subtotal, descuento_total, impuestos_total, total_orden, estado_orden, notas_orden) VALUES
(1, 9, 'ORD-2024-001', '2024-07-20 15:30:00', 450.00, 0.00, 72.00, 522.00, 'ENTREGADA', 'Entrega rápida solicitada'),
(2, 10, 'ORD-2024-002', '2024-07-21 11:15:00', 600.00, 90.00, 81.60, 591.60, 'EN_PROCESO', 'Aplicado descuento PRODUCTOS15'),
(3, 11, 'ORD-2024-003', '2024-07-22 09:45:00', 1200.00, 0.00, 192.00, 1392.00, 'PAGADA', 'Kit completo de cuidado facial');

INSERT INTO `detalle_ordenes` (orden_id, producto_id, nombre_producto_historico, cantidad, precio_unitario_historico, subtotal_linea) VALUES
(1, 1, 'Sérum Vitamina C Premium', 1, 450.00, 450.00),
(2, 2, 'Crema Hidratante Facial SPF30', 1, 380.00, 380.00),
(2, 8, 'Rodillo Facial Jade', 1, 220.00, 220.00),
(3, 7, 'Kit Cuidado Facial Completo', 1, 1200.00, 1200.00);

INSERT INTO `transacciones_pago` (orden_id, agendamiento_id, cliente_usuario_id, monto, moneda, metodo_pago, id_transaccion_pasarela, estado_pago, fecha_transaccion, datos_pasarela_request, datos_pasarela_response) VALUES
(1, NULL, 9, 522.00, 'MXN', 'VISA', 'TXN_001_20240720', 'COMPLETADO', '2024-07-20 15:35:00', '{}', '{}'),
(2, NULL, 10, 591.60, 'MXN', 'MASTERCARD', 'TXN_002_20240721', 'COMPLETADO', '2024-07-21 11:20:00', '{}', '{}'),
(NULL, 1, 9, 3500.00, 'MXN', 'TRANSFERENCIA', 'TXN_003_20240723', 'COMPLETADO', '2024-07-23 09:15:00', '{}', '{}');

INSERT INTO `recordatorios` (usuario_id, agendamiento_id, titulo, descripcion, fecha_hora_recordatorio, canal_notificacion, enviado, activo, fijado) VALUES
(9, 1, 'Cita: Tratamiento Hifu', 'Recordatorio de cita mañana a las 10:00 AM en Plaza Strada', '2024-07-24 18:00:00', 'EMAIL', 0, 1, 1),
(10, 2, 'Cita: Masaje Relajante', 'Tu cita de masaje relajante es mañana a las 2:00 PM', '2025-07-25 18:00:00', 'EMAIL', 0, 1, 0),
(11, 3, 'Cita: Limpieza Facial', 'Limpieza facial programada para mañana 11:30 AM', '2025-07-26 18:00:00', 'EMAIL', 0, 1, 0);

INSERT INTO `reseñas` (cliente_usuario_id, calificacion, comentario, reseñable_id, reseñable_type, aprobada, fecha_reseña) VALUES
(9, 5, 'Excelente tratamiento Hifu, los resultados son visibles inmediatamente. La Dra. Laura es muy profesional.', 2, 'Servicio', 1, '2024-07-20 18:00:00'),
(10, 4, 'Muy buen producto, la crema hidratante es perfecta para mi tipo de piel.', 2, 'Producto', 1, '2024-07-21 19:30:00'),
(11, 5, 'El ambiente del spa es muy relajante y el personal súper atento. Recomendado al 100%.', 1, 'Sucursal', 1, '2024-07-22 16:45:00');

INSERT INTO `direcciones` (direccionable_id, direccionable_type, direccion, colonia, codigo_postal, ciudad, estado, referencias, es_predeterminada) VALUES
(1, 'Sucursal', 'Plaza Strada Local 15-A', 'Tabasco 2000', '86035', 'Villahermosa', 'Tabasco', 'Frente a Liverpool', 1),
(2, 'Sucursal', 'Plaza San Luis Local 22-B', 'Lomas del Tecnológico', '78250', 'San Luis Potosí', 'San Luis Potosí', 'Segundo piso, ala norte', 1),
(3, 'Sucursal', 'Plaza Altabrisa Local 8-C', 'Reforma', '86080', 'Villahermosa', 'Tabasco', 'Cerca de la entrada principal', 1),
(9, 'Usuario', 'Calle Benito Juárez 123', 'Centro', '86000', 'Villahermosa', 'Tabasco', 'Casa azul con portón blanco', 1),
(10, 'Usuario', 'Av. Constitución 456', 'Tequisquiapan', '78250', 'San Luis Potosí', 'San Luis Potosí', 'Departamento 3B', 1);

INSERT INTO `horarios_sucursal` (sucursal_id, dia_semana, hora_apertura, hora_cierre, esta_cerrado_regularmente) VALUES
(1, 1, '09:00:00', '20:00:00', 0), (1, 2, '09:00:00', '20:00:00', 0), (1, 3, '09:00:00', '20:00:00', 0),
(1, 4, '09:00:00', '20:00:00', 0), (1, 5, '09:00:00', '21:00:00', 0), (1, 6, '09:00:00', '21:00:00', 0),
(1, 0, NULL, NULL, 1),
(2, 1, '10:00:00', '19:00:00', 0), (2, 2, '10:00:00', '19:00:00', 0), (2, 3, '10:00:00', '19:00:00', 0),
(2, 4, '10:00:00', '19:00:00', 0), (2, 5, '10:00:00', '20:00:00', 0), (2, 6, '10:00:00', '20:00:00', 0),
(2, 0, '11:00:00', '17:00:00', 0),
(3, 1, '09:00:00', '20:00:00', 0), (3, 2, '09:00:00', '20:00:00', 0), (3, 3, '09:00:00', '20:00:00', 0),
(3, 4, '09:00:00', '20:00:00', 0), (3, 5, '09:00:00', '21:00:00', 0), (3, 6, '09:00:00', '21:00:00', 0),
(3, 0, NULL, NULL, 1);

INSERT INTO `especialidad_personal` (especialidad_id, personal_id) VALUES
(1, 4), (3, 4), (2, 5), (5, 6), (3, 6), (2, 7), (4, 7);

INSERT INTO `servicio_personal` (servicio_id, personal_id) VALUES
(1, 4), (2, 4), (6, 4), (7, 4),
(10, 5), (15, 5),
(3, 6), (4, 6), (5, 6), (13, 6),
(9, 7), (10, 7), (11, 7), (14, 7), (15, 7);

INSERT INTO `servicio_sucursal` (servicio_id, sucursal_id, precio_en_sucursal, esta_disponible) VALUES
(1, 1, NULL, 1), (2, 1, NULL, 1), (3, 1, NULL, 1), (4, 1, NULL, 1), (5, 1, NULL, 1),
(6, 1, NULL, 1), (7, 1, NULL, 1), (8, 1, NULL, 1), (9, 1, NULL, 1), (10, 1, NULL, 1),
(11, 1, NULL, 1), (12, 1, NULL, 1), (13, 1, NULL, 1), (14, 1, NULL, 1), (15, 1, NULL, 1), (16, 1, NULL, 1),
(10, 2, 750.00, 1), (13, 2, NULL, 1), (15, 2, NULL, 1), (16, 2, NULL, 1),
(3, 3, NULL, 1), (4, 3, NULL, 1), (5, 3, NULL, 1), (13, 3, NULL, 1);

INSERT INTO `promocion_servicio` (promocion_id, servicio_id) VALUES
(2, 2), (2, 3), (2, 4), (2, 5), (2, 8), (2, 13);

INSERT INTO `producto_promocion` (promocion_id, producto_id) VALUES
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8);


-- PASO 4: MENSAJE DE ÉXITO
SELECT '¡Script completo de creación y población ejecutado exitosamente!' as 'Estado';

-- Crear tabla favoritos para el sistema BarberMusic&Spa
-- Permite a los clientes marcar productos y servicios como favoritos
-- según el Manual de Roles BarberMusic&Spa

CREATE TABLE IF NOT EXISTS `favoritos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint(20) unsigned NOT NULL,
  `producto_id` bigint(20) unsigned NULL DEFAULT NULL,
  `servicio_id` bigint(20) unsigned NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `favoritos_usuario_id_foreign` (`usuario_id`),
  KEY `favoritos_producto_id_foreign` (`producto_id`),
  KEY `favoritos_servicio_id_foreign` (`servicio_id`),
  UNIQUE KEY `favoritos_usuario_producto_unique` (`usuario_id`, `producto_id`),
  UNIQUE KEY `favoritos_usuario_servicio_unique` (`usuario_id`, `servicio_id`),
  CONSTRAINT `favoritos_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoritos_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoritos_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE,
  -- Restricción para asegurar que cada favorito tenga exactamente un producto O un servicio
  CONSTRAINT `favoritos_check_tipo` CHECK (
    (`producto_id` IS NOT NULL AND `servicio_id` IS NULL) OR 
    (`producto_id` IS NULL AND `servicio_id` IS NOT NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices adicionales para mejorar el rendimiento
CREATE INDEX `idx_favoritos_created_at` ON `favoritos` (`created_at`);
CREATE INDEX `idx_favoritos_usuario_created` ON `favoritos` (`usuario_id`, `created_at`);

-- Comentarios para documentación
ALTER TABLE `favoritos` COMMENT = 'Tabla para gestionar favoritos de usuarios - productos y servicios';
ALTER TABLE `favoritos` MODIFY COLUMN `usuario_id` bigint(20) unsigned NOT NULL COMMENT 'ID del usuario que marca como favorito';
ALTER TABLE `favoritos` MODIFY COLUMN `producto_id` bigint(20) unsigned NULL COMMENT 'ID del producto favorito (NULL si es servicio)';
ALTER TABLE `favoritos` MODIFY COLUMN `servicio_id` bigint(20) unsigned NULL COMMENT 'ID del servicio favorito (NULL si es producto)';
ALTER TABLE `favoritos` MODIFY COLUMN `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de creación del favorito';
ALTER TABLE `favoritos` MODIFY COLUMN `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha de última actualización';

-- Insertar algunos datos de prueba (opcional - solo para testing)
-- INSERT INTO favoritos (usuario_id, producto_id) VALUES (1, 1);
-- INSERT INTO favoritos (usuario_id, servicio_id) VALUES (1, 1);
-- INSERT INTO favoritos (usuario_id, producto_id) VALUES (2, 2);

SELECT 'Tabla favoritos creada exitosamente' AS mensaje;

-- ===================================================================
-- SCRIPT PARA ACTUALIZAR RUTAS DE IMÁGENES ORGANIZADAS
-- BarberMusic&Spa - Organización de Assets por Categorías
-- ===================================================================

-- IMPORTANTE: Ejecutar este script DESPUÉS de reorganizar físicamente las imágenes
-- Este script actualiza las rutas en la base de datos para reflejar la nueva organización

-- ===================================================================
-- 1. ACTUALIZAR RUTAS DE IMÁGENES DE SERVICIOS
-- ===================================================================

-- Servicios con rutas específicas organizadas
UPDATE servicios SET imagen_path = '/assets/img/servicios/sculpsure.jpg' WHERE nombre = 'Tratamiento Sculpsure';
UPDATE servicios SET imagen_path = '/assets/img/servicios/hifu.webp' WHERE nombre = 'Tratamiento Hifu';
UPDATE servicios SET imagen_path = '/assets/img/servicios/radiofrecuencia-facial.jfif' WHERE nombre = 'Radiofrecuencia Facial';
UPDATE servicios SET imagen_path = '/assets/img/servicios/hidradermoabrasion.jfif' WHERE nombre = 'Hidradermoabrasión';
UPDATE servicios SET imagen_path = '/assets/img/servicios/microdermoabrasion.jpg' WHERE nombre = 'Microdermoabrasión';
UPDATE servicios SET imagen_path = '/assets/img/servicios/hollywood-peel.jpg' WHERE nombre = 'Hollywood Peel';
UPDATE servicios SET imagen_path = '/assets/img/servicios/eliminacion-tatuajes.jpg' WHERE nombre = 'Eliminación de Tatuajes';
UPDATE servicios SET imagen_path = '/assets/img/servicios/despigmentacion.jpg' WHERE nombre = 'Despigmentación';
UPDATE servicios SET imagen_path = '/assets/img/servicios/levantamiento-gluteos.webp' WHERE nombre = 'Levantamiento de Glúteos';
UPDATE servicios SET imagen_path = '/assets/img/servicios/maderoterapia.jfif' WHERE nombre = 'Maderoterapia';
UPDATE servicios SET imagen_path = '/assets/img/servicios/lipo-sin-cirugia.jpeg' WHERE nombre = 'Lipo Sin Cirugía';
UPDATE servicios SET imagen_path = '/assets/img/servicios/criolipolisis.jpg' WHERE nombre = 'Criolipólisis';
UPDATE servicios SET imagen_path = '/assets/img/servicios/limpieza-facial.jpg' WHERE nombre = 'Limpieza Facial';
UPDATE servicios SET imagen_path = '/assets/img/servicios/eliminacion-celulitis.webp' WHERE nombre = 'Eliminación de Celulitis';
UPDATE servicios SET imagen_path = '/assets/img/servicios/masaje-relajante.jpg' WHERE nombre = 'Masaje Relajante';
UPDATE servicios SET imagen_path = '/assets/img/servicios/depilacion-laser.webp' WHERE nombre = 'Depilación Definitiva - LASER SHR';

-- ===================================================================
-- 2. ACTUALIZAR RUTAS DE IMÁGENES DE PRODUCTOS
-- ===================================================================

-- Productos con rutas específicas organizadas
UPDATE productos SET imagen_path = '/assets/img/productos/serum-vitc.jpg' WHERE nombre = 'Sérum Vitamina C Premium';
UPDATE productos SET imagen_path = '/assets/img/productos/crema-spf30.jpg' WHERE nombre = 'Crema Hidratante Facial SPF30';
UPDATE productos SET imagen_path = '/assets/img/productos/aceite-relax.jpg' WHERE nombre = 'Aceite Corporal Relajante';
UPDATE productos SET imagen_path = '/assets/img/productos/exfoliante-marino.jpg' WHERE nombre = 'Exfoliante Corporal Marino';
UPDATE productos SET imagen_path = '/assets/img/productos/mascarilla-pure.jpg' WHERE nombre = 'Mascarilla Purificante';
UPDATE productos SET imagen_path = '/assets/img/productos/locion-reaf.jpg' WHERE nombre = 'Loción Reafirmante';
UPDATE productos SET imagen_path = '/assets/img/productos/kit-facial.jpg' WHERE nombre = 'Kit Cuidado Facial Completo';
UPDATE productos SET imagen_path = '/assets/img/productos/rodillo-jade.jpg' WHERE nombre = 'Rodillo Facial Jade';

-- Actualizar productos existentes en BD con imágenes reales movidas
UPDATE productos SET imagen_path = '/assets/img/productos/gel-clasico-fortificante.jpg' WHERE imagen_path LIKE '%Gel Clásico Fortificante%';
UPDATE productos SET imagen_path = '/assets/img/productos/pomada-original.webp' WHERE imagen_path LIKE '%Pomada Original%';
UPDATE productos SET imagen_path = '/assets/img/productos/shampoo-estimulante.jpg' WHERE imagen_path LIKE '%Shampoo Estimulante%';
UPDATE productos SET imagen_path = '/assets/img/productos/aceite-barba-black-jack.jpg' WHERE imagen_path LIKE '%Aceite para Barba Black Jack%';
UPDATE productos SET imagen_path = '/assets/img/productos/crema-afeitar.jpg' WHERE imagen_path LIKE '%Crema de Afeitar%';
UPDATE productos SET imagen_path = '/assets/img/productos/mascarilla-facial.jpg' WHERE imagen_path LIKE '%Mascarilla Facial Wake Up%';

-- ===================================================================
-- 3. ACTUALIZAR RUTAS DE IMÁGENES DE SUCURSALES
-- ===================================================================

-- Sucursales con rutas organizadas
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal1.jpg' WHERE nombre = 'Villahermosa - Plaza Strada';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal2.jpg' WHERE nombre = 'San Luis Potosí - Plaza San Luis';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal3.jpg' WHERE nombre = 'Villahermosa - Plaza Altabrisa';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal4.jpg' WHERE nombre = 'Coatzacoalcos - Plaza Forum';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal5.jpg' WHERE nombre = 'Ciudad del Carmen - Plaza Zentralia';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal6.jpg' WHERE nombre = 'Mérida - Plaza Altabrisa';
UPDATE sucursales SET imagen_path = '/assets/img/sucursales/sucursal7.jpg' WHERE nombre = 'Villahermosa - Plaza Las Américas';

-- ===================================================================
-- 4. ACTUALIZAR RUTAS DE IMÁGENES DE USUARIOS (Si es necesario)
-- ===================================================================

-- Actualizar solo si existen usuarios con rutas de imagen incorrectas
UPDATE usuarios SET imagen_path = '/assets/img/usuarios/default_admin.png' WHERE imagen_path LIKE '%admin%' AND imagen_path NOT LIKE '/assets/img/usuarios/%';

-- ===================================================================
-- 5. VERIFICACIÓN DE RESULTADOS
-- ===================================================================

-- Verificar servicios actualizados
SELECT id, nombre, imagen_path FROM servicios WHERE imagen_path IS NOT NULL ORDER BY id;

-- Verificar productos actualizados  
SELECT id, nombre, imagen_path FROM productos WHERE imagen_path IS NOT NULL ORDER BY id;

-- Verificar sucursales actualizadas
SELECT id, nombre, imagen_path FROM sucursales WHERE imagen_path IS NOT NULL ORDER BY id;

-- ===================================================================
-- 6. LIMPIAR RUTAS HUÉRFANAS O INCORRECTAS
-- ===================================================================

-- Establecer imagen por defecto para servicios sin imagen válida
UPDATE servicios SET imagen_path = '/assets/img/default-service.jpg' 
WHERE imagen_path IS NULL OR imagen_path = '' OR imagen_path NOT LIKE '/assets/img/%';

-- Establecer imagen por defecto para productos sin imagen válida
UPDATE productos SET imagen_path = '/assets/img/productos/default-product.jpg' 
WHERE imagen_path IS NULL OR imagen_path = '' OR imagen_path NOT LIKE '/assets/img/%';

-- ===================================================================
-- MENSAJE DE ÉXITO
-- ===================================================================

SELECT 'Rutas de imágenes actualizadas exitosamente en la base de datos' as 'Estado',
       'Servicios, Productos y Sucursales reorganizados correctamente' as 'Detalle';

-- ===================================================================
-- NOTAS IMPORTANTES:
-- ===================================================================
/*
1. Este script debe ejecutarse DESPUÉS de mover físicamente los archivos de imagen
2. Las rutas están organizadas de la siguiente manera:
   - Servicios: /assets/img/servicios/
   - Productos: /assets/img/productos/ 
   - Sucursales: /assets/img/sucursales/
   - Imágenes por defecto: /assets/img/default-*.jpg

3. Si tienes imágenes adicionales, agrégalas manualmente siguiendo el patrón:
   UPDATE tabla SET imagen_path = '/assets/img/categoria/nombre-archivo.extension' WHERE condicion;

4. Las templates ya están actualizadas para usar las nuevas rutas organizadas

5. Spring Security ya tiene permisos para /assets/** por lo que no requiere configuración adicional
*/