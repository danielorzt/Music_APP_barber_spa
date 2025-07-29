-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-07-2025 a las 04:27:45
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.12

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `barbermusicspa`
--
CREATE DATABASE IF NOT EXISTS `barbermusicspa` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `barbermusicspa`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agendamientos`
--

DROP TABLE IF EXISTS `agendamientos`;
CREATE TABLE `agendamientos` (
  `id` bigint UNSIGNED NOT NULL,
  `cliente_usuario_id` bigint UNSIGNED NOT NULL,
  `personal_id` bigint UNSIGNED DEFAULT NULL,
  `servicio_id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `fecha_hora_inicio` datetime NOT NULL,
  `fecha_hora_fin` datetime NOT NULL,
  `precio_final` decimal(10,2) NOT NULL,
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PROGRAMADA' COMMENT 'Ej: PROGRAMADA, CONFIRMADA, CANCELADA_CLIENTE, CANCELADA_PERSONAL, COMPLETADA, NO_ASISTIO',
  `notas_cliente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `notas_internas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `agendamientos`
--

INSERT INTO `agendamientos` VALUES
(1, 1, 1, 17, 15, '2025-07-28 10:00:00', '2025-07-28 10:45:00', 25.00, 'Confirmado', 'Primera vez, emocionado.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(2, 2, 2, 8, 15, '2025-07-28 11:00:00', '2025-07-28 12:00:00', 70.00, 'Confirmado', NULL, 'Cliente habitual de radiofrecuencia.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(3, 3, 3, 19, 15, '2025-07-28 13:00:00', '2025-07-28 13:30:00', 35.00, 'Confirmado', 'Diseño de cejas según la foto enviada.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(4, 4, 4, 20, 16, '2025-07-29 09:30:00', '2025-07-29 10:30:00', 45.00, 'Pendiente', 'Confirmar color antes de la cita.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(5, 5, 5, 21, 16, '2025-07-29 11:30:00', '2025-07-29 12:00:00', 40.00, 'Confirmado', NULL, 'Zona bikini y axilas.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(6, 6, 6, 16, 16, '2025-07-29 14:00:00', '2025-07-29 14:30:00', 20.00, 'Confirmado', 'Solo arreglo de contorno.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(7, 7, 7, 1, 17, '2025-07-30 10:00:00', '2025-07-30 10:45:00', 150.00, 'Confirmado', 'Primera sesión de SculpSure.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(8, 8, 8, 14, 17, '2025-07-30 12:00:00', '2025-07-30 13:00:00', 60.00, 'Confirmado', NULL, 'Cliente con agenda flexible.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(9, 9, 9, 7, 17, '2025-07-30 14:00:00', '2025-07-30 15:30:00', 200.00, 'Confirmado', 'Reafirmación facial.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(10, 10, 10, 22, 18, '2025-07-31 09:00:00', '2025-07-31 09:45:00', 30.00, 'Confirmado', 'Corte de puntas y capas.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(11, 11, 11, 2, 18, '2025-07-31 10:00:00', '2025-07-31 11:00:00', 120.00, 'Confirmado', 'Sesión de Lipo sin cirugía.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(12, 12, 12, 15, 18, '2025-07-31 11:30:00', '2025-07-31 12:30:00', 50.00, 'Confirmado', NULL, 'Foco en espalda y cuello.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(13, 13, 13, 3, 19, '2025-08-01 10:30:00', '2025-08-01 11:30:00', 180.00, 'Confirmado', 'Primera sesión de Criolipolisis.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(14, 14, 14, 10, 19, '2025-08-01 12:00:00', '2025-08-01 12:45:00', 50.00, 'Pendiente', 'Verificar estado de la piel antes.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(15, 15, 15, 11, 19, '2025-08-01 14:00:00', '2025-08-01 14:45:00', 80.00, 'Confirmado', NULL, 'Preparar mascarilla de carbón.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(16, 16, 16, 4, 20, '2025-08-02 09:00:00', '2025-08-02 10:15:00', 100.00, 'Confirmado', 'Paquete de 3 sesiones, esta es la primera.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(17, 17, 17, 12, 20, '2025-08-02 11:00:00', '2025-08-02 12:00:00', 40.00, 'Confirmado', 'Limpieza profunda.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(18, 18, 18, 5, 20, '2025-08-02 13:00:00', '2025-08-02 14:00:00', 90.00, 'Pendiente', NULL, 'Confirmar si cliente desea electroestimulación.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(19, 19, 19, 6, 21, '2025-08-03 10:00:00', '2025-08-03 11:00:00', 80.00, 'Confirmado', 'Primera sesión anti-celulitis.', NULL, '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL),
(20, 20, 20, 13, 21, '2025-08-03 11:30:00', '2025-08-03 12:30:00', 75.00, 'Confirmado', NULL, 'Necesita seguimiento de manchas.', '2025-07-25 21:12:31', '2025-07-25 21:12:31', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE `categorias` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_categoria` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: PRODUCTO, SERVICIO',
  `icono_clave` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clave para mapear a un icono en el frontend',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` VALUES
(1, 'Estética Corporal Avanzada', 'Remodelación y reafirmación corporal no invasiva.', 'Servicio', 'icono_estetica_corporal', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(2, 'Tratamientos Faciales Avanzados', 'Limpieza profunda, rejuvenecimiento y corrección facial.', 'Servicio', 'icono_facial_avanzado', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(3, 'Terapias Manuales y Masajes', 'Masajes de relajación y terapias corporales manuales.', 'Servicio', 'icono_masajes', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(4, 'Servicios de Barbería', 'Cortes y arreglo de barba/bigote para caballeros.', 'Servicio', 'icono_barberia', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(5, 'Cuidado y Estilismo Capilar', 'Coloración, cortes y tratamientos para el cabello.', 'Servicio', 'icono_estilismo_capilar', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(6, 'Depilación Láser', 'Eliminación permanente del vello con láser SHR.', 'Servicio', 'icono_depilacion_laser', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(7, 'Servicios de Cejas y Mirada', 'Diseño y perfilado de cejas, embellecimiento de la mirada.', 'Servicio', 'icono_cejas_mirada', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(8, 'Eliminación de Tatuajes', 'Procedimientos para remover tatuajes.', 'Servicio', 'icono_eliminacion_tatuajes', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(9, 'Productos Crecimiento Capilar', 'Productos para estimular el crecimiento del cabello.', 'Producto', 'icono_prod_crecimiento', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(10, 'Productos para el Cabello', 'Champús, acondicionadores y tratamientos generales para el cabello.', 'Producto', 'icono_prod_cabello', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(11, 'Productos para la Barba', 'Aceites, bálsamos y ceras para el cuidado de la barba.', 'Producto', 'icono_prod_barba', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(12, 'Productos de Afeitado', 'Cremas, geles y accesorios para un afeitado perfecto.', 'Producto', 'icono_prod_afeitado', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(13, 'Productos para la Piel', 'Limpiadores, hidratantes y tratamientos para la piel.', 'Producto', 'icono_prod_piel', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(14, 'Kits de Productos', 'Paquetes combinados de productos para diferentes necesidades.', 'Producto', 'icono_prod_kits', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18'),
(15, 'Productos Rebalance', 'Línea de productos para reequilibrar o restaurar.', 'Producto', 'icono_prod_rebalance', 1, '2025-07-25 19:21:18', '2025-07-25 19:21:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ordenes`
--

DROP TABLE IF EXISTS `detalle_ordenes`;
CREATE TABLE `detalle_ordenes` (
  `id` bigint UNSIGNED NOT NULL,
  `orden_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `nombre_producto_historico` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cantidad` int UNSIGNED NOT NULL,
  `precio_unitario_historico` decimal(10,2) NOT NULL,
  `subtotal_linea` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `detalle_ordenes`
--

INSERT INTO `detalle_ordenes` VALUES
(1, 1, 1, 'Bálsamo Clásico de Crecimiento de Barba y Bigote 5% Minoxidil - 2oz|60ml Biotina + Queratina & Vitaminas', 1, 29.35, 29.35, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(2, 1, 13, 'Ace Pomade Supreme Grip 4oz | Biotina + Queratina + Cafeína', 1, 22.65, 22.65, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(3, 1, 30, 'Soothing After Shave 6oz | Crema Reparadora & Antiinflamatoria', 1, 20.59, 20.59, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(4, 2, 41, 'Tratamiento Anti Edad 2oz | Ácido Hialurónico y Extracto Pepino', 1, 35.29, 35.29, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(5, 2, 2, 'Gel Bálsamo de Crecimiento 2oz|60ml Minoxidil 5% + Biotina + Queratina + Vitaminas', 1, 29.35, 29.35, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(6, 3, 3, 'Shampoo Estimulante 8oz/230ml | Anti Caída + Algas Marinas', 1, 32.35, 32.35, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(7, 3, 8, 'Pomada Clasica 4oz | Base Agua + Media fijación', 1, 18.53, 18.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(8, 4, 4, 'Green Balm Crecimiento de Barba y Bigote 2oz|60ml Alga Marinas + Biotina + Regaliz + Queratina', 2, 27.65, 55.30, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(9, 4, 32, 'Aceite Pre Afeitado Royal Barber 60ml | Cítricos + Elimina Irritación del Afeitado', 1, 31.47, 31.47, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(10, 4, 18, 'Pomada Base Aceite Royal Barber 4oz | No grasoso y fácil lavado | Sin Caja', 1, 23.47, 23.47, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(11, 5, 5, '2 Meses Bálsamo Clásico 2oz | Minoxidil + Biotina & Queratina', 1, 52.88, 52.88, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(12, 5, 43, 'Mascarilla Facial Wake Up Revitalizante 2.7oz', 1, 18.24, 18.24, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(13, 6, 6, 'Pomada Base Agua Royal Barber 4oz | Aceite de Cedro + Formula Alemana + Activos y Ceras Naturales', 1, 26.41, 26.41, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(14, 6, 26, 'Bálsamo Negro para Barba 2.7oz | Cubre canas + Pigmento Mineral 100% Natural + Estiliza & Moldea', 1, 20.88, 20.88, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(15, 7, 7, 'Pomada Mate 4oz | Acabado Satinado + Extra Fijación', 1, 18.53, 18.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(16, 7, 39, 'Jabón de Carbón Activado 170gr | Detox y Limpieza', 1, 19.41, 19.41, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(17, 8, 8, 'Pomada Clasica 4oz | Base Agua + Media fijación', 2, 18.53, 37.06, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(18, 8, 27, 'Cera Híbrida para Cabello y Barba 4oz | Acabado Natural + Fijación Media', 1, 18.53, 18.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(19, 8, 45, '2 Meses Gel Bálsamo de Crecimiento 2oz | Minoxidil 5% + Biotina & Queratina (Kit)', 1, 52.88, 52.88, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(20, 9, 9, 'Pomada Original 32oz | Base Agua + Extra Fijación', 1, 123.53, 123.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(21, 9, 46, '2 Meses Bálsamo Clásico 2oz + Jabón Carbón Activado 100gr (Kit)', 1, 67.59, 67.59, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(22, 10, 10, 'Gel Pomada 4oz | Ceras de Pomada en Consistencia Gel + Brillo Sutil + Fijacion Natural', 1, 21.18, 21.18, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(23, 10, 31, 'Gel Deslizante para Afeitar 6oz | Reduce Irritación + Visibilidad Total', 1, 20.59, 20.59, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(24, 11, 11, 'Cera Híbrida para Cabello y Barba 32oz | Acabado Natural + Fijación Media', 1, 123.53, 123.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(25, 12, 12, 'Gel Clásico Fortificante 6oz | Previene Caída de Cabello', 2, 12.35, 24.70, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(26, 12, 33, 'Crema de Afeitar 8oz | Protege la piel de la irritación y escozor', 1, 34.41, 34.41, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(27, 13, 14, 'Pomada Base Aceite 4oz | Formula No Grasosa + Controla Frizz', 1, 18.53, 18.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(28, 13, 28, 'Aceite para Barba Royal Barber 60ml | Hidratación + Acondiciona', 1, 31.47, 31.47, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(29, 13, 48, 'Kit Cuidado de Barba', 1, 75.29, 75.29, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(30, 14, 15, 'Pomada Clásica 32oz | Base Agua + Media Fijación', 1, 123.53, 123.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(31, 15, 16, 'Hair Wash Shampoo de Limpieza Profunda 4oz | Elimina Toxinas', 1, 5.88, 5.88, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(32, 15, 49, 'Reelance Crecimiento Pestañas 6ml', 1, 23.53, 23.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(33, 15, 34, 'Ron de Bahía Royal Barber 100 ml | Cierra Poros + Tonifica Piel', 1, 31.47, 31.47, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(34, 16, 17, 'Pomada Mate 32oz | Acabado Satinado + Extra Fijación', 1, 123.53, 123.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(35, 16, 50, 'Reelance Loción Hombre 60 ml', 1, 23.53, 23.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(36, 17, 18, 'Pomada Base Aceite Royal Barber 4oz | No grasoso y fácil lavado | Sin Caja', 1, 23.47, 23.47, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(37, 17, 42, 'Exfoliador Facial de Cascara de Nuez 4oz | Limpieza Natural', 1, 19.41, 19.41, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(38, 18, 19, 'OCEAN SALT SHAMPOO 8OZ', 1, 9.71, 9.71, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(39, 18, 52, 'Reelance Cera Híbrida 120ml', 1, 23.53, 23.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(40, 18, 35, 'Jabón para Afeitar con Aroma 3.53oz | Hidratante + Afeitado Suave', 1, 15.00, 15.00, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(41, 19, 20, 'Pomada Base Aceite 32oz | Formula No Grasosa + Controla Frizz', 1, 123.53, 123.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(42, 19, 53, 'Reelance Tratamiento Restaurador 120ml', 1, 23.53, 23.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(43, 20, 25, 'Shampoo de Barba 8oz | Aceites Esenciales + Reduce picazón y resequedad', 1, 21.76, 21.76, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(44, 20, 54, 'Reelance Shampoo Mujer 120ml', 1, 23.53, 23.53, '2025-07-25 21:45:56', '2025-07-25 21:45:56'),
(45, 20, 37, 'Desinfectante y Limpiador de Brochas 125ml | Desinfecta y Cuida Brochas, Cepillos & Peines', 1, 15.29, 15.29, '2025-07-25 21:45:56', '2025-07-25 21:45:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones`
--

DROP TABLE IF EXISTS `direcciones`;
CREATE TABLE `direcciones` (
  `id` bigint UNSIGNED NOT NULL,
  `direccionable_id` bigint UNSIGNED NOT NULL,
  `direccionable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `colonia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_postal` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ciudad` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Referencias adicionales para la ubicación',
  `es_predeterminada` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `direcciones`
--

INSERT INTO `direcciones` VALUES
(1, 15, 'Sucursal', 'Plaza San Luis Local 44B', 'Lomas del Tecnológico', '78216', 'San Luis Potosí', 'San Luis Potosí', 'Dentro de Plaza San Luis', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(2, 16, 'Sucursal', 'Plaza Forum – Planta Baja 53', 'Paraíso', '96536', 'Coatzacoalcos', 'Veracruz', 'Dentro de Plaza Forum', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(3, 17, 'Sucursal', 'Plaza Altabrisa – Tabasco Planta Alta, Local 131', 'José Pagés Llergo', '86035', 'Villahermosa', 'Tabasco', 'Dentro de Plaza Altabrisa', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(4, 18, 'Sucursal', 'Plaza Altabrisa – Local #83 Planta Alta', 'Altabrisa', '97130', 'Mérida', 'Yucatán', 'Dentro de Plaza Altabrisa', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(5, 19, 'Sucursal', 'Plaza Zentralia – Local #91', 'San Miguel', '24157', 'Ciudad del Carmen', 'Campeche', 'Dentro de Plaza Zentralia', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(6, 20, 'Sucursal', 'Plaza Las Americas Villahermosa – Local 7ª Av. Prof- Ramón Mendoza Herrera 102', 'El recreo', '86100', 'Villahermosa', 'Tabasco', 'Dentro de Plaza Las Americas Villahermosa', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL),
(7, 21, 'Sucursal', 'Plaza Altabrisa Villahermosa – Local 93 Planta Alta.', 'José Pagés Llergo', '86190', 'Villahermosa', 'Tabasco', 'Dentro de Plaza Altabrisa Villahermosa', 1, '2025-07-26 00:10:16', '2025-07-26 00:10:16', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidades`
--

DROP TABLE IF EXISTS `especialidades`;
CREATE TABLE `especialidades` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icono_clave` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clave para mapear a un icono en el frontend, ej: CORTE_HOMBRE, UNIAS_GEL',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `especialidades`
--

INSERT INTO `especialidades` VALUES
(1, 'Cosmiatra / Terapeuta en Estética Avanzada', 'Profesional especializado en tratamientos faciales de alta tecnología, corporales avanzados, despigmentación y eliminación de tatuajes.', 'icono_estetica_avanzada', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(2, 'Masajista / Terapeuta Corporal', 'Profesional encargado de maderoterapia y masajes relajantes.', 'icono_masajista', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(3, 'Barbero / Estilista Masculino', 'Especialista en arreglo y diseño de barba, cortes de cabello masculinos y perfilado de cejas para hombres.', 'icono_barbero', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(4, 'Estilista / Colorista', 'Profesional de cabello que realiza coloraciones, cortes generales (masculinos y femeninos), y tratamientos capilares.', 'icono_estilista', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(5, 'Técnico en Depilación Láser', 'Profesional certificado para la operación de equipos de depilación láser SHR.', 'icono_depilacion_laser', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(6, 'Diseñador de Cejas / Micropigmentador', 'Especialista en diseño y delineado de cejas y posiblemente otras técnicas de micropigmentación.', 'icono_cejas_micropigmentacion', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidad_personal`
--

DROP TABLE IF EXISTS `especialidad_personal`;
CREATE TABLE `especialidad_personal` (
  `especialidad_id` bigint UNSIGNED NOT NULL,
  `personal_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `especialidad_personal`
--

INSERT INTO `especialidad_personal` VALUES
(1, 1, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 2, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 5, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 8, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 9, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 13, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 15, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 17, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 21, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 22, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 25, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 28, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(1, 29, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(2, 1, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(2, 9, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(2, 15, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(2, 21, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(2, 29, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(3, 2, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(3, 5, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(3, 13, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(3, 22, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(3, 25, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 3, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 7, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 11, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 16, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 19, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 23, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(4, 27, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(5, 4, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(5, 12, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(5, 20, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(5, 24, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(6, 2, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(6, 8, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(6, 17, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(6, 28, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 1, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 5, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 9, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 15, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 17, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 21, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 25, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(7, 29, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(8, 4, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(8, 6, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(8, 12, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(8, 14, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(8, 20, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(9, 3, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(9, 11, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(9, 16, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(9, 23, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 4, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 10, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 14, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 18, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 24, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(10, 30, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(11, 4, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(11, 14, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(11, 24, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(12, 6, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(12, 18, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(12, 26, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(13, 6, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(13, 26, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(14, 7, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(14, 19, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(14, 27, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(15, 11, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(16, 3, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(17, 2, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(17, 8, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(17, 13, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(17, 22, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(17, 28, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(18, 4, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(18, 10, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(18, 18, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(18, 30, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(19, 7, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(19, 10, '2025-07-25 22:05:02', '2025-07-25 22:05:02'),
(19, 30, '2025-07-25 22:05:02', '2025-07-25 22:05:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `excepciones_horario_sucursal`
--

DROP TABLE IF EXISTS `excepciones_horario_sucursal`;
CREATE TABLE `excepciones_horario_sucursal` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `fecha` date NOT NULL COMMENT 'Fecha específica de la excepción',
  `esta_cerrado` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Indica si la sucursal está cerrada en esta fecha específica',
  `hora_apertura` time DEFAULT NULL COMMENT 'Hora de apertura especial para esta fecha, si aplica y no está cerrada',
  `hora_cierre` time DEFAULT NULL COMMENT 'Hora de cierre especial para esta fecha, si aplica y no está cerrada',
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Motivo de la excepción, ej: Festivo Nacional, Mantenimiento',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `excepciones_horario_sucursal`
--

INSERT INTO `excepciones_horario_sucursal` VALUES
(1, 1, '2025-11-15', 1, '09:00:00', '22:00:00', 'Horario extendido por El Buen Fin', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(2, 2, '2025-11-15', 1, '09:00:00', '22:00:00', 'Horario extendido por El Buen Fin', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(3, 3, '2025-11-15', 1, '09:00:00', '22:00:00', 'Horario extendido por El Buen Fin', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(4, 4, '2025-11-15', 1, '09:00:00', '22:00:00', 'Horario extendido por El Buen Fin', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(5, 5, '2025-11-15', 1, '09:00:00', '22:00:00', 'Horario extendido por El Buen Fin', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(6, 1, '2025-12-24', 1, '09:00:00', '18:00:00', 'Horario especial por Nochebuena', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(7, 2, '2025-12-24', 1, '09:00:00', '18:00:00', 'Horario especial por Nochebuena', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(8, 3, '2025-12-24', 1, '09:00:00', '18:00:00', 'Horario especial por Nochebuena', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(9, 4, '2025-12-24', 1, '09:00:00', '18:00:00', 'Horario especial por Nochebuena', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(10, 5, '2025-12-24', 1, '09:00:00', '18:00:00', 'Horario especial por Nochebuena', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(11, 1, '2025-12-31', 1, '09:00:00', '18:00:00', 'Horario especial por Nochevieja', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(12, 2, '2025-12-31', 1, '09:00:00', '18:00:00', 'Horario especial por Nochevieja', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(13, 3, '2025-12-31', 1, '09:00:00', '18:00:00', 'Horario especial por Nochevieja', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(14, 4, '2025-12-31', 1, '09:00:00', '18:00:00', 'Horario especial por Nochevieja', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(15, 5, '2025-12-31', 1, '09:00:00', '18:00:00', 'Horario especial por Nochevieja', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(16, 1, '2025-02-14', 1, '09:00:00', '21:00:00', 'Horario extendido por San Valentín', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(17, 2, '2025-02-14', 1, '09:00:00', '21:00:00', 'Horario extendido por San Valentín', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(18, 3, '2025-02-14', 1, '09:00:00', '21:00:00', 'Horario extendido por San Valentín', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(19, 4, '2025-02-14', 1, '09:00:00', '21:00:00', 'Horario extendido por San Valentín', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(20, 5, '2025-02-14', 1, '09:00:00', '21:00:00', 'Horario extendido por San Valentín', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(21, 1, '2025-05-10', 1, '08:00:00', '21:00:00', 'Horario especial por el Día de las Madres', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(22, 2, '2025-05-10', 1, '08:00:00', '21:00:00', 'Horario especial por el Día de las Madres', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(23, 3, '2025-05-10', 1, '08:00:00', '21:00:00', 'Horario especial por el Día de las Madres', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(24, 4, '2025-05-10', 1, '08:00:00', '21:00:00', 'Horario especial por el Día de las Madres', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(25, 5, '2025-05-10', 1, '08:00:00', '21:00:00', 'Horario especial por el Día de las Madres', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(26, 1, '2025-06-15', 1, '10:00:00', '18:00:00', 'Horario especial por el Día del Padre', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(27, 2, '2025-06-15', 1, '10:00:00', '18:00:00', 'Horario especial por el Día del Padre', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(28, 3, '2025-06-15', 1, '10:00:00', '18:00:00', 'Horario especial por el Día del Padre', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(29, 4, '2025-06-15', 1, '10:00:00', '18:00:00', 'Horario especial por el Día del Padre', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(30, 5, '2025-06-15', 1, '10:00:00', '18:00:00', 'Horario especial por el Día del Padre', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(31, 1, '2025-09-15', 1, '09:00:00', '17:00:00', 'Horario especial por Víspera de Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(32, 2, '2025-09-15', 1, '09:00:00', '17:00:00', 'Horario especial por Víspera de Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(33, 3, '2025-09-15', 1, '09:00:00', '17:00:00', 'Horario especial por Víspera de Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(34, 4, '2025-09-15', 1, '09:00:00', '17:00:00', 'Horario especial por Víspera de Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(35, 5, '2025-09-15', 1, '09:00:00', '17:00:00', 'Horario especial por Víspera de Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(36, 1, '2025-09-16', 1, '10:00:00', '18:00:00', 'Horario especial por Día de la Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(37, 2, '2025-09-16', 1, '10:00:00', '18:00:00', 'Horario especial por Día de la Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(38, 3, '2025-09-16', 1, '10:00:00', '18:00:00', 'Horario especial por Día de la Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(39, 4, '2025-09-16', 1, '10:00:00', '18:00:00', 'Horario especial por Día de la Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(40, 5, '2025-09-16', 1, '10:00:00', '18:00:00', 'Horario especial por Día de la Independencia', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(41, 1, '2025-10-31', 1, '09:00:00', '19:00:00', 'Horario especial por Halloween', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(42, 2, '2025-10-31', 1, '09:00:00', '19:00:00', 'Horario especial por Halloween', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(43, 3, '2025-10-31', 1, '09:00:00', '19:00:00', 'Horario especial por Halloween', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(44, 4, '2025-10-31', 1, '09:00:00', '19:00:00', 'Horario especial por Halloween', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(45, 5, '2025-10-31', 1, '09:00:00', '19:00:00', 'Horario especial por Halloween', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(46, 1, '2025-11-02', 1, '10:00:00', '17:00:00', 'Horario especial por Día de Muertos', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(47, 2, '2025-11-02', 1, '10:00:00', '17:00:00', 'Horario especial por Día de Muertos', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(48, 3, '2025-11-02', 1, '10:00:00', '17:00:00', 'Horario especial por Día de Muertos', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(49, 4, '2025-11-02', 1, '10:00:00', '17:00:00', 'Horario especial por Día de Muertos', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(50, 5, '2025-11-02', 1, '10:00:00', '17:00:00', 'Horario especial por Día de Muertos', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(51, 1, '2025-08-15', 1, '08:00:00', '20:00:00', 'Horario especial por Regreso a Clases', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(52, 2, '2025-08-15', 1, '08:00:00', '20:00:00', 'Horario especial por Regreso a Clases', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(53, 3, '2025-08-15', 1, '08:00:00', '20:00:00', 'Horario especial por Regreso a Clases', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(54, 4, '2025-08-15', 1, '08:00:00', '20:00:00', 'Horario especial por Regreso a Clases', '2025-07-25 22:28:56', '2025-07-25 22:28:56'),
(55, 5, '2025-08-15', 1, '08:00:00', '20:00:00', 'Horario especial por Regreso a Clases', '2025-07-25 22:28:56', '2025-07-25 22:28:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios_sucursal`
--

DROP TABLE IF EXISTS `horarios_sucursal`;
CREATE TABLE `horarios_sucursal` (
  `id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `dia_semana` tinyint UNSIGNED NOT NULL COMMENT '0=Domingo, 1=Lunes,..., 6=Sábado',
  `hora_apertura` time DEFAULT NULL,
  `hora_cierre` time DEFAULT NULL,
  `esta_cerrado_regularmente` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Si este día de la semana la sucursal está normalmente cerrada, ej: Domingos',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `horarios_sucursal`
--

INSERT INTO `horarios_sucursal` VALUES
(1, 1, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(2, 1, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(3, 1, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(4, 1, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(5, 1, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(6, 1, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(7, 1, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(8, 2, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(9, 2, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(10, 2, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(11, 2, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(12, 2, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(13, 2, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(14, 2, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(15, 3, 1, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(16, 3, 2, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(17, 3, 3, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(18, 3, 4, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(19, 3, 5, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(20, 3, 6, '08:00:00', '19:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(21, 3, 7, '10:00:00', '17:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(22, 4, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(23, 4, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(24, 4, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(25, 4, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(26, 4, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(27, 4, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(28, 4, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(29, 5, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(30, 5, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(31, 5, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(32, 5, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(33, 5, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(34, 5, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(35, 5, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(36, 6, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(37, 6, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(38, 6, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(39, 6, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(40, 6, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(41, 6, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(42, 6, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(43, 7, 1, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(44, 7, 2, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(45, 7, 3, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(46, 7, 4, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(47, 7, 5, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(48, 7, 6, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13'),
(49, 7, 7, '11:00:00', '21:00:00', 0, '2025-07-25 22:38:13', '2025-07-25 22:38:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `musica_preferencias_navegacion`
--

DROP TABLE IF EXISTS `musica_preferencias_navegacion`;
CREATE TABLE `musica_preferencias_navegacion` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre_opcion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `stream_url_ejemplo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `musica_preferencias_navegacion`
--

INSERT INTO `musica_preferencias_navegacion` VALUES
(1, 'Música Electrónica', 'Género musical que utiliza instrumentos electrónicos y tecnología musical para producir sonidos, ideal para un ambiente moderno y energizante.', 'https://open.spotify.com/playlist/37i9dQZF1DX0FkEbt6HOwE', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(2, 'Música Pop', 'Género musical popular con melodías pegadizas y estructuras sencillas, ideal para un ambiente animado y familiar.', 'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(3, 'Rock Clásico', 'Género que abarca una amplia gama de estilos musicales evolucionados del rock and roll de los años 60-80, perfecto para un ambiente con carácter y nostalgia.', 'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(4, 'Indie Pop / Rock', 'Música alternativa con influencias de rock y pop, a menudo asociada con sellos discográficos independientes, para un ambiente fresco y relajado.', 'https://open.spotify.com/playlist/37i9dQZF1DX2L0iB2NEaK2', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(5, 'Jazz Suave', 'Un estilo de jazz relajante y melódico, ideal para ambientes tranquilos, sofisticados y que invitan a la calma.', 'https://open.spotify.com/playlist/37i9dQZF1DXbKgb5liG50K', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(6, 'Música Latina Pop', 'Géneros populares de habla hispana como reggaetón, pop latino y baladas, para un ambiente alegre y con ritmo.', 'https://open.spotify.com/playlist/37i9dQZF1DX2Nc3B7A90rp', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(7, 'R&B Suave', 'Ritmo y blues contemporáneo con melodías melancólicas y beats relajantes, perfecto para un ambiente íntimo y con estilo.', 'https://open.spotify.com/playlist/37i9dQZF1DXd2tK8sE7wwS', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(8, 'Lo-fi Beats', 'Un género de música electrónica con elementos de jazz, hip-hop y funk, caracterizado por su sonido relajado y atmosférico, ideal para concentración o relajación.', 'https://open.spotify.com/playlist/37i9dQZF1DXc8kgYqQLMfN', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(9, 'Clásica Relajante', 'Obras de música clásica seleccionadas por su efecto calmante y sereno, para un ambiente de máxima tranquilidad y elegancia.', 'https://open.spotify.com/playlist/37i9dQZF1DXdK7fA3p7y5W', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes`
--

DROP TABLE IF EXISTS `ordenes`;
CREATE TABLE `ordenes` (
  `id` bigint UNSIGNED NOT NULL,
  `cliente_usuario_id` bigint UNSIGNED NOT NULL,
  `numero_orden` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_orden` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_recibida` datetime DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `descuento_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `impuestos_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_orden` decimal(10,2) NOT NULL,
  `estado_orden` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDIENTE_PAGO' COMMENT 'Ej: PENDIENTE_PAGO, PAGADA, EN_PROCESO, ENVIADA, ENTREGADA, CANCELADA',
  `notas_orden` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ordenes`
--

INSERT INTO `ordenes` VALUES
(1, 1, 'ORD0001', '2025-07-20 10:00:00', '2025-07-20 10:15:00', 150.00, 0.00, 24.00, 174.00, 'Completado', 'Compra de productos para cabello.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(2, 2, 'ORD0002', '2025-07-21 11:30:00', '2025-07-21 11:45:00', 200.00, 10.00, 32.00, 222.00, 'Completado', 'Crema facial y serum.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(3, 3, 'ORD0003', '2025-07-22 09:00:00', '2025-07-22 09:10:00', 75.00, 0.00, 12.00, 87.00, 'Completado', 'Champú y acondicionador.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(4, 4, 'ORD0004', '2025-07-22 14:00:00', '2025-07-22 14:20:00', 300.00, 20.00, 48.00, 328.00, 'Completado', 'Kit de afeitado premium.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(5, 5, 'ORD0005', '2025-07-23 10:30:00', '2025-07-23 10:45:00', 120.00, 0.00, 19.20, 139.20, 'Pendiente', 'Entrega a domicilio.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(6, 6, 'ORD0006', '2025-07-23 16:00:00', '2025-07-23 16:15:00', 90.00, 5.00, 14.40, 99.40, 'Completado', NULL, '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(7, 7, 'ORD0007', '2025-07-24 09:30:00', '2025-07-24 09:40:00', 50.00, 0.00, 8.00, 58.00, 'Completado', 'Sólo un producto.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(8, 8, 'ORD0008', '2025-07-24 13:00:00', '2025-07-24 13:15:00', 180.00, 15.00, 28.80, 193.80, 'Completado', 'Productos de cuidado de la piel.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(9, 9, 'ORD0009', '2025-07-25 10:00:00', '2025-07-25 10:10:00', 250.00, 0.00, 40.00, 290.00, 'Completado', 'Pedido grande de varios artículos.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(10, 10, 'ORD0010', '2025-07-25 15:00:00', '2025-07-25 15:20:00', 110.00, 0.00, 17.60, 127.60, 'Pendiente', 'Recoger en sucursal mañana.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(11, 11, 'ORD0011', '2025-07-25 17:00:00', '2025-07-25 17:05:00', 65.00, 0.00, 10.40, 75.40, 'Completado', NULL, '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(12, 12, 'ORD0012', '2025-07-26 09:15:00', '2025-07-26 09:30:00', 140.00, 7.00, 22.40, 155.40, 'Completado', 'Pedido enviado por mensajería.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(13, 13, 'ORD0013', '2025-07-26 11:00:00', '2025-07-26 11:20:00', 210.00, 0.00, 33.60, 243.60, 'Completado', 'Regalo para esposa.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(14, 14, 'ORD0014', '2025-07-27 10:00:00', '2025-07-27 10:10:00', 85.00, 0.00, 13.60, 98.60, 'Completado', NULL, '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(15, 15, 'ORD0015', '2025-07-27 14:30:00', '2025-07-27 14:50:00', 195.00, 10.00, 31.20, 216.20, 'Pendiente', 'Cliente llamó para cambiar dirección.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(16, 16, 'ORD0016', '2025-07-28 09:00:00', '2025-07-28 09:15:00', 160.00, 0.00, 25.60, 185.60, 'Completado', 'Confirmado entrega en 2 días.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(17, 17, 'ORD0017', '2025-07-28 12:00:00', '2025-07-28 12:05:00', 70.00, 0.00, 11.20, 81.20, 'Completado', 'Retiro en sucursal hoy mismo.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(18, 18, 'ORD0018', '2025-07-29 10:45:00', '2025-07-29 11:00:00', 220.00, 12.00, 35.20, 243.20, 'Completado', 'Incluye tarjeta de regalo.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(19, 19, 'ORD0019', '2025-07-29 15:30:00', '2025-07-29 15:45:00', 130.00, 0.00, 20.80, 150.80, 'Completado', NULL, '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL),
(20, 20, 'ORD0020', '2025-07-30 09:00:00', '2025-07-30 09:20:00', 280.00, 25.00, 44.80, 299.80, 'Pendiente', 'Revisar stock antes de enviar.', '2025-07-25 21:19:50', '2025-07-25 21:19:50', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal`
--

DROP TABLE IF EXISTS `personal`;
CREATE TABLE `personal` (
  `id` bigint UNSIGNED NOT NULL,
  `usuario_id` bigint UNSIGNED NOT NULL,
  `sucursal_asignada_id` bigint UNSIGNED DEFAULT NULL,
  `tipo_personal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: ADMIN_GENERAL, ADMIN_SUCURSAL, BARBERO, ESTILISTA, MASAJISTA, RECEPCIONISTA',
  `numero_empleado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `activo_en_empresa` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Si el empleado está actualmente activo en la empresa',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal`
--

INSERT INTO `personal` VALUES
(1, 1, 15, 'Barbero / Estilista Masculino', 'EMP001SLP', '2023-01-15', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(2, 2, 15, 'Cosmiatra / Terapeuta en Estética Avanzada', 'EMP002SLP', '2024-03-20', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(3, 3, 15, 'Masajista / Terapeuta Corporal', 'EMP003SLP', '2022-06-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(4, 4, 16, 'Estilista / Colorista', 'EMP001COA', '2025-02-10', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(5, 5, 16, 'Diseñador de Cejas / Micropigmentador', 'EMP002COA', '2024-11-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(6, 6, 16, 'Barbero / Estilista Masculino', 'EMP003COA', '2023-02-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(7, 7, 17, 'Técnico en Depilación Láser', 'EMP001VHA', '2024-05-10', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(8, 8, 17, 'Cosmiatra / Terapeuta en Estética Avanzada', 'EMP002VHA', '2022-08-15', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(9, 9, 17, 'Masajista / Terapeuta Corporal', 'EMP003VHA', '2025-01-20', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(10, 10, 18, 'Estilista / Colorista', 'EMP001MER', '2023-10-25', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(11, 11, 18, 'Barbero / Estilista Masculino', 'EMP002MER', '2023-03-10', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(12, 12, 18, 'Cosmiatra / Terapeuta en Estética Avanzada', 'EMP003MER', '2024-07-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(13, 13, 19, 'Masajista / Terapeuta Corporal', 'EMP001CAR', '2022-09-05', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(14, 14, 19, 'Diseñador de Cejas / Micropigmentador', 'EMP002CAR', '2025-03-15', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(15, 15, 19, 'Técnico en Depilación Láser', 'EMP003CAR', '2024-01-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(16, 16, 20, 'Barbero / Estilista Masculino', 'EMP001VHB', '2023-04-05', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(17, 17, 20, 'Cosmiatra / Terapeuta en Estética Avanzada', 'EMP002VHB', '2024-09-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(18, 18, 20, 'Masajista / Terapeuta Corporal', 'EMP003VHB', '2022-11-20', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(19, 19, 21, 'Estilista / Colorista', 'EMP001VHC', '2025-04-01', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL),
(20, 20, 21, 'Técnico en Depilación Láser', 'EMP002VHC', '2023-07-10', 1, '2025-07-25 21:07:20', '2025-07-25 21:07:20', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

DROP TABLE IF EXISTS `productos`;
CREATE TABLE `productos` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imagen_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int UNSIGNED NOT NULL DEFAULT '0',
  `sku` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria_id` bigint UNSIGNED DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` VALUES
(1, 'Bálsamo Clásico de Crecimiento de Barba y Bigote 5% Minoxidil - 2oz|60ml Biotina + Queratina & Vitaminas', '5% Minoxidil: Estimula el crecimiento, fortalece el vello y mejora la densidad.  Biotina, Queratina y Vitaminas: Para mayor efectividad en cada aplicación. [cite: 202] Crema Ligera y de Rápida Absorción : Para piel Mixta o Sensible. [cite: 203] Aplicación Fácil : Aplicar como una crema facial. Recomendación de Uso : Se sugiere aplicar dos veces al día durante 90 días para obtener los mejores resultados en el crecimiento y densidad de la barba. [cite: 204]', NULL, 29.35, 200, 'PROD001C', 9, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(2, 'Gel Bálsamo de Crecimiento 2oz|60ml Minoxidil 5% + Biotina + Queratina + Vitaminas', 'El Gel Bálsamo de Crecimiento de Barba y Bigote con 5% Minoxidil de Mel Bros Co es una fórmula avanzada enriquecida con biotina, queratina y vitaminas para estimular el crecimiento facial. [cite: 205] Contiene un 5% de minoxidil, un ingrediente probado para fomentar el desarrollo del vello facial. [cite: 206] Un bálsamo en gel que combina eficacia y cuidado para lograr una barba más completa y densa. ', NULL, 29.35, 200, 'PROD002C', 9, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(3, 'Shampoo Estimulante 8oz/230ml | Anti Caída + Algas Marinas', 'El Shampoo Estimulante de Mel Bros Co, epitome de la elegancia y sofisticación, se erige como un deleite diario para el cuidado capilar. [cite: 208] Con la fusión de activos naturales como las algas marinas, vitaminas y extractos cuidadosamente seleccionados, este shampoo ofrece una experiencia refinada y estimulante. [cite: 209] Concebido para el uso diario, revitaliza el cabello con una delicadeza sublime, dotándolo de una salud y brillo incomparables. [cite: 210] Un gesto de lujo cotidiano para aquellos que buscan el equilibrio perfecto entre el cuidado y el estilo. [cite: 211]', NULL, 32.35, 200, 'PROD003C', 9, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(4, 'Green Balm Crecimiento de Barba y Bigote 2oz|60ml Alga Marinas + Biotina + Regaliz + Queratina', 'Green Balm de Mel Bros Co es un bálsamo de crecimiento para barba y bigote con ingredientes naturales. [cite: 212] Formulado con extractos de microalgas, extracto de palmira palmata, queratina, biotina, extracto de regaliz y varios extractos herbales, estimula el crecimiento de la barba. [cite: 213] Una alternativa al minoxidil, este bálsamo ofrece una solución natural para aquellos que buscan fomentar el desarrollo de su vello facial de manera efectiva. [cite: 214]', NULL, 27.65, 200, 'PROD004C', 9, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(5, '2 Meses Bálsamo Clásico 2oz | Minoxidil + Biotina & Queratina', 'Tratamiento de Crecimiento de Barba y Bigote para 2 meses para el crecimiento de barba y bigote. [cite: 215] Fórmula potente para estimular el crecimiento, fortalecer y suavizar la barba y el bigote. [cite: 216] Transforma tu vello facial con resultados visibles y duraderos. [cite: 217]', NULL, 52.88, 200, 'PROD005C', 9, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(6, 'Pomada Base Agua Royal Barber 4oz | Aceite de Cedro + Formula Alemana + Activos y Ceras Naturales', 'Base agua, su fórmula alemana incorpora cuidadosamente aceite esencial de cedro, ceras de calidad y activos exclusivos de Alemania. [cite: 220] Presentada en un envase de vidrio exclusivo, esta pomada no solo ofrece una fijación excepcional, sino que también brinda un cuidado capilar preventivo contra la caída. [cite: 221] Una experiencia única que fusiona la tradición alemana con la innovación, elevando el arte del peinado a nuevas alturas de lujo y distinción. [cite: 222]', NULL, 26.41, 200, 'PROD001CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(7, 'Pomada Mate 4oz | Acabado Satinado + Extra Fijación', 'Descubre la distinción en cada aplicación con la Pomada Mate 4oz de Mel Bros Co. Fusionando elegancia y naturaleza, esta fórmula excepcional, enriquecida con un cautivador aroma herbal, ofrece un acabado mate impecable. [cite: 223] Disfruta de una fijación firme, textura ligera y un control sublime, definiendo tu estilo con un toque sofisticado. [cite: 224] La esencia de la frescura herbal se entrelaza con la fuerza de una pomada excepcional. [cite: 225] Eleva tu presencia, define tu estilo con Mel Bros Co. [cite: 225]', NULL, 18.53, 200, 'PROD002CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(8, 'Pomada Original 4oz | Base Agua + Extra Fijación', 'La pomada Original Mel Bros Co Extra Fijación, con base de agua y enriquecida con el distintivo aceite esencial de cedro, ofrece un toque de elegancia y sofisticación a tu estilo. [cite: 226] Su fórmula avanzada proporciona una fijación excepcional sin dejar residuos, mientras que el aroma sutil del cedro cautiva tus sentidos. [cite: 227] Domina tu look con esta pomada única, fusionando la tradición con la modernidad. [cite: 228]', NULL, 18.53, 200, 'PROD003CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(9, 'Shampoo Estimulante 8oz/230ml | Anti Caída + Algas Marinas', 'El Shampoo Estimulante de Mel Bros Co, epitome de la elegancia y sofisticación, se erige como un deleite diario para el cuidado capilar. [cite: 229] Con la fusión de activos naturales como las algas marinas, vitaminas y extractos cuidadosamente seleccionados, este shampoo ofrece una experiencia refinada y estimulante. [cite: 230] Concebido para el uso diario, revitaliza el cabello con una delicadeza sublime, dotándolo de una salud y brillo incomparables. [cite: 231] Un gesto de lujo cotidiano para aquellos que buscan el equilibrio perfecto entre el cuidado y el estilo. [cite: 232]', NULL, 32.35, 200, 'PROD004CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(10, 'Cera Híbrida para Cabello y Barba 4oz | Acabado Natural + Fijación Media', 'La Cera Híbrida para Cabello y Barba de Mel Bros Co , impregnada con un exquisito aroma cítrico, personifica la sofisticación y la sobriedad. [cite: 233] Esta fórmula de media fijación, cuidadosamente elaborada, logra un equilibrio perfecto entre estilo y naturalidad, brindando una apariencia impecable con un toque distintivo. [cite: 234] Con un acabado que deja el cabello con un aspecto natural y una fijación media, este producto es un símbolo de elegancia atemporal y refinamiento inigualable. [cite: 235]', NULL, 18.53, 200, 'PROD005CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(11, 'Pomada Negra 4oz|118ml Oscurece Canas', 'La Pomada Negra de Mel Bros Co, ayuda a oscurecer y estilizar mientras la aplicas sobre el cabello. [cite: 236] Esta pomada, de base agua y fijación extra, incorpora el activo mineral natural del óxido negro de hierro. [cite: 237] Este ingrediente singular no solo proporciona una fijación excepcional, sino que también pigmenta de manera temporal las canas del cabello, ofreciendo un oscurecimiento elegante y estilizado. [cite: 238] Una fusión perfecta entre innovación y tradición, esta pomada redefine el concepto de estilo con distinción y clase. [cite: 239]', NULL, 25.59, 200, 'PROD006CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(12, 'Pomada Mate Royal Barber 4oz | Efecto Mate', 'La Pomada Royal Barber Mate de Mel Bros Co, obra maestra del estilismo capilar, fusiona con maestría una sinergia de aceites esenciales para un aroma cautivador, ceras y activos provenientes de Alemania en una fórmula alemana de calidad. [cite: 240] Presentada en un envase de vidrio exclusivo, esta pomada ofrece una alta fijación sin sacrificar la naturalidad del cabello, dejándolo sin brillo o satinado. [cite: 241] Un toque de distinción que redefine el concepto de estilo con elegancia y sobriedad. [cite: 242]', NULL, 26.41, 200, 'PROD007CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(13, 'Pomada Clasica 4oz | Base Agua + Media fijación', 'La pomada Clásica Mel Bros Co Media Fijación , con base de agua y enriquecida con el distintivo aceite esencial de cedro, ofrece un toque de elegancia y sofisticación a tu estilo. [cite: 243] Su fórmula avanzada proporciona una fijación excepcional sin dejar residuos, mientras que el aroma sutil del cedro cautiva tus sentidos. [cite: 244] Domina tu look con esta pomada única, fusionando la tradición con la modernidad. [cite: 245]', NULL, 18.53, 200, 'PROD008CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(14, 'Pomada Original 32oz | Base Agua + Extra Fijación', 'La pomada Original Mel Bros Co Extra Fijación, con base de agua y enriquecida con el distintivo aceite esencial de cedro, ofrece un toque de elegancia y sofisticación a tu estilo. [cite: 246] Su fórmula avanzada proporciona una fijación excepcional sin dejar residuos, mientras que el aroma sutil del cedro cautiva tus sentidos. [cite: 247] Domina tu look con esta pomada única, fusionando la tradición con la modernidad. [cite: 248]', NULL, 123.53, 200, 'PROD009CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(15, 'Gel Pomada 4oz | Ceras de Pomada en Consistencia Gel + Brillo Sutil + Fijacion Natural', 'El Gel Pomada de Mel Bros Co personifica la esencia de la sofisticación y la elegancia clásica. [cite: 249] Esta refinada fusión de propiedades de pomada y la consistencia premium de un gel ofrece una experiencia de estilismo única y con clase. [cite: 250] Diseñado para aquellos que aprecian la distinción en cada detalle, este producto de Mel Bros Co encarna la tradición con un toque moderno, elevando el arte del peinado a nuevas alturas de estilo y refinamiento. [cite: 251]', NULL, 21.18, 200, 'PROD010CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(16, 'Cera Híbrida para Cabello y Barba 32oz | Acabado Natural + Fijación Media', 'La Cera Híbrida para Cabello y Barba de Mel Bros Co , impregnada con un exquisito aroma cítrico, personifica la sofisticación y la sobriedad. [cite: 252] Esta fórmula de media fijación, cuidadosamente elaborada, logra un equilibrio perfecto entre estilo y naturalidad, brindando una apariencia impecable con un toque distintivo. [cite: 253] Con un acabado que deja el cabello con un aspecto natural y una fijación media, este producto es un símbolo de elegancia atemporal y refinamiento inigualable. [cite: 254]', NULL, 123.53, 200, 'PROD011CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(17, 'Gel Clásico Fortificante 6oz | Previene Caída de Cabello', 'El Gel Clásico Fortificante de Mel Bros Co, un elixir de refinamiento y elegancia, fusiona la funcionalidad de estimular el crecimiento capilar con la capacidad de esculpir con estilo. [cite: 255] Su fórmula excepcional, diseñada para una fijación alta, ofrece una experiencia de estilismo impecable y fortalecedora. [cite: 256] Este producto, con su esencia de sofisticación, encarna la fusión perfecta entre cuidado y estilo, elevando la rutina diaria a un nivel de distinción sin igual. [cite: 257]', NULL, 12.35, 200, 'PROD012CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(18, 'Ace Pomade Supreme Grip 4oz | Biotina + Queratina + Cafeína', 'Ace Pomade Supreme Grip 4oz es un producto para el cabello que ofrece una fuerte fijación. [cite: 258] Enriquecido con biotina, pantenol, queratina, concentrado de cafeína, extracto de regaliz, vitaminas y ceras naturales. [cite: 259] Proporciona un agarre superior y beneficios para el cabello, promoviendo una apariencia saludable y manejable. [cite: 260]', NULL, 22.65, 200, 'PROD013CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(19, 'Pomada Base Aceite 4oz | Formula No Grasosa + Controla Frizz', 'Esta fórmula exclusiva, de textura ligera, ofrece una fijación potente sin la pesadez del exceso de grasa, asegurando un estilo impecable. [cite: 261] Su aroma cautivador de aceites esenciales florales eleva la experiencia, mientras su fácil lavado garantiza una transición sin complicaciones. [cite: 262]', NULL, 18.53, 200, 'PROD014CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(20, 'Pomada Clásica 32oz | Base Agua + Media Fijación', 'La pomada Clásica Mel Bros Co Media Fijación, con base de agua y enriquecida con el distintivo aceite esencial de cedro, ofrece un toque de elegancia y sofisticación a tu estilo. [cite: 263] Su fórmula avanzada proporciona una fijación excepcional sin dejar residuos, mientras que el aroma sutil del cedro cautiva tus sentidos. [cite: 264] Domina tu look con esta pomada única, fusionando la tradición con la modernidad. [cite: 265]', NULL, 123.53, 200, 'PROD015CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(21, 'Hair Wash Shampoo de Limpieza Profunda 4oz | Elimina Toxinas', 'El Shampoo de Limpieza Profunda de Mel Bros Co es la elección definitiva para aquellos que buscan una experiencia de lavado revitalizante y purificante. [cite: 266] Diseñado para limpiar desde la raíz, este shampoo va más allá de la superficie, eliminando eficazmente toxinas y suciedad acumuladas a lo largo del día. [cite: 267] Su fórmula especial garantiza una limpieza profunda, proporcionando un cuero cabelludo revitalizado y libre de impurezas. [cite: 268] Además, deja el cabello suave y manejable, resaltando su textura natural. [cite: 269]', NULL, 5.88, 200, 'PROD016CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(22, 'Pomada Mate 32oz | Acabado Satinado + Extra Fijación', 'Fusionando elegancia y naturaleza, esta fórmula excepcional, enriquecida con un cautivador aroma herbal, ofrece un acabado mate impecable. [cite: 270] Disfruta de una fijación firme, textura ligera y un control sublime, definiendo tu estilo con un toque sofisticado. [cite: 271] La esencia de la frescura herbal se entrelaza con la fuerza de una pomada excepcional. [cite: 272] Eleva tu presencia, define tu estilo con Mel Bros Co. [cite: 273]', NULL, 123.53, 200, 'PROD017CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(23, 'Pomada Base Aceite Royal Barber 4oz | No grasoso y fácil lavado | Sin Caja', 'La Pomada Royal Barber Base Aceite de Mel Bros Co es una joya del estilismo capilar que destaca por su refinamiento y eficacia. [cite: 274] La sinergia de aceites esenciales crea un aroma cautivador, mientras que las ceras y activos de Alemania, en una fórmula alemana de calidad, aseguran una aplicación suave y precisa. [cite: 275] Presentada en un envase de vidrio único, esta pomada ofrece alta fijación y deja el cabello elegantemente brilloso. [cite: 276] Es la elección perfecta para climas húmedos, eliminando el frizz sin dejar residuos grasosos y siendo fácil de lavar. [cite: 277]', NULL, 23.47, 200, 'PROD018CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(24, 'OCEAN SALT SHAMPOO 8OZ', 'Ocean Salt Shampoo de Mel Bros Co. limpia a profundidad con sal marina fina y una mezcla revitalizante de aceites cítricos (mandarina, pomelo, naranja y bergamota). [cite: 283] Su fórmula con aceite de coco y vainilla hidrata y suaviza, dejando tu cabello fresco, limpio y con un aroma natural y energizante. [cite: 284]', NULL, 9.71, 200, 'PROD019CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(25, 'Pomada Base Aceite 32oz | Formula No Grasosa + Controla Frizz', 'Esta fórmula exclusiva, de textura ligera, ofrece una fijación potente sin la pesadez del exceso de grasa, asegurando un estilo impecable. [cite: 285] Su aroma cautivador de aceites esenciales florales eleva la experiencia, mientras su fácil lavado garantiza una transición sin complicaciones. [cite: 286]', NULL, 123.53, 200, 'PROD020CA', 10, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(26, 'Shampoo de Barba 8oz | Aceites Esenciales + Reduce picazón y resequedad', 'El Shampoo para Barba de Mel Bros Co es un tributo al cuidado facial refinado, una fórmula maestra diseñada para elevar el ritual diario de cuidado personal. [cite: 287] Enriquecido con aceites esenciales y activos hidratantes, este shampoo no solo limpia la barba, sino que también la deja suave, manejable y completamente libre de resequedad. [cite: 288] Ideal para el uso diario en el ritual de cuidado personal, sino que también se destaca como un tratamiento efectivo para la eliminación de la caspa del vello facial. [cite: 289] La fórmula equilibrada y nutritiva del shampoo asegura que cada aplicación sea una experiencia sensorial agradable, contribuyendo a una barba saludable, suave y con un aspecto impecable. [cite: 290]', NULL, 21.76, 200, 'PROD001B', 11, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(27, 'Bálsamo Negro para Barba 2.7oz | Cubre canas + Pigmento Mineral 100% Natural + Estiliza & Moldea', 'El Bálsamo Negro para Barba de Mel Bros Co es la solución perfecta para el cuidado masculino sin aroma abrumador. [cite: 291] Con una fórmula de base agua, controla el vello rebelde y presenta el activo mineral óxido negro de hierro para pigmentar temporalmente las canas de la barba. [cite: 292] Fácil de lavar, ofrece un look natural y sin esfuerzo, sin dejar residuos. [cite: 293] La elección ideal para un cuidado de la barba sutil y efectivo. [cite: 293]', NULL, 20.88, 200, 'PROD002B', 11, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(28, 'Cera Híbrida para Cabello y Barba 4oz | Acabado Natural + Fijación Media', 'La Cera Híbrida para Cabello y Barba de Mel Bros Co , impregnada con un exquisito aroma cítrico, personifica la sofisticación y la sobriedad. [cite: 294] Esta fórmula de media fijación, cuidadosamente elaborada, logra un equilibrio perfecto entre estilo y naturalidad, brindando una apariencia impecable con un toque distintivo. [cite: 295] Con un acabado que deja el cabello con un aspecto natural y una fijación media, este producto es un símbolo de elegancia atemporal y refinamiento inigualable. [cite: 296]', NULL, 18.53, 200, 'PROD003B', 11, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(29, 'Cera de Abeja Royal Barber 2oz | Ingredientes 100% Naturales', 'Ingredientes 100% Naturales : Formulada con ingredientes totalmente naturales, la cera asegura un cuidado suave y respetuoso para la barba y piel. [cite: 297] Ritual de Cuidado Diario : Diseñada para ser parte integral del ritual diario de cuidado de la barba, proporcionando beneficios continuos de estilización y nutrición. [cite: 298] Aceites Esenciales, Vitaminas y Extractos : Enriquecida con aceites esenciales, vitaminas y extractos naturales, la cera aporta nutrientes clave para mantener una barba saludable y bien cuidada. [cite: 299]', NULL, 22.35, 200, 'PROD004B', 11, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(30, 'Aceite para Barba Royal Barber 60ml | Hidratación + Acondiciona', 'El Aceite para Barba Royal Barber de Mel Bros Co es la esencia del cuidado masculino. [cite: 300] Con una base de aceite de jojoba, argán y macadamia, y una sinergia de aceites esenciales que le brindan un aroma exclusivo, este aceite hidrata, lubrica y suaviza tanto la piel como la barba. [cite: 301] Presentado en un envase exclusivo de vidrio de la línea Royal Barber, está elaborado con activos 100% naturales de alta calidad. [cite: 302] La elección perfecta para una barba bien cuidada y una experiencia de lujo. [cite: 303]', NULL, 31.47, 200, 'PROD005B', 11, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(31, 'Aceite para Barba Black Jack 50ml | Bergamota + Jojoba + Suaviza', 'El Aceite para Barba Black Jack de Mel Bros Co es la esencia del cuidado masculino. [cite: 304] Con una base de aceite de jojoba, argán y bergamota, esta poderosa mezcla de aceites esenciales cuida tu barba, hidrata la piel debajo del vello y previene la irritación del afeitado. [cite: 305] Suaviza, hidrata y deja tu barba manejable, brindando una experiencia de cuidado completa con elegancia y simplicidad. [cite: 306] La elección perfecta para una barba impecable y una piel saludable. [cite: 307]', NULL, 18.53, 200, 'PROD001AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(32, 'Soothing After Shave 6oz | Crema Reparadora & Antiinflamatoria', 'El Soothing After Shave de Mel Bros Co es una crema reparadora que calma y restaura la piel post afeitada. [cite: 308] Con bisabolol, refresca y cierra los poros, proporcionando hidratación y protección esenciales para una piel revitalizada después del afeitado. [cite: 309] Una solución directa para una piel suave y reconfortada tras el afeitado. [cite: 310]', NULL, 20.59, 200, 'PROD002AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(33, 'Gel Deslizante para Afeitar 6oz | Reduce Irritación + Visibilidad Total', 'El Gel Deslizante para Afeitar de Mel Bros Co es la solución rápida para un afeitado eficiente. [cite: 311] Transparente para visualizar los vellos y permitir detalles precisos, este gel facilita el deslizamiento de la navaja. [cite: 312] Enriquecido con extractos protectores para la piel, es ideal para quienes buscan un afeitado rápido sin comprometer la calidad. [cite: 313] Perfecto para aquellos con poco tiempo, ofrece un ritual de afeitado sin complicaciones, pero efectivo. [cite: 314]', NULL, 20.59, 200, 'PROD003AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(34, 'Aceite Pre Afeitado Royal Barber 60ml | Cítricos + Elimina Irritación del Afeitado', 'El Aceite Pre Afeitado Royal Barber de Mel Bros Co es la preparación esencial para un afeitado sin irritación. [cite: 315] Con una base de aceite de jojoba, argán y macadamia, y una sinergia de aceites esenciales cítricos para un aroma distintivo, este aceite ayuda a abrir los poros, facilitando un afeitado suave y sin molestias. [cite: 316] Presentado en un envase exclusivo de vidrio de la línea Royal Barber, está elaborado con activos 100% naturales de alta calidad. [cite: 317] La elección perfecta para un afeitado impecable y placentero. [cite: 318]', NULL, 31.47, 200, 'PROD004AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(35, 'Crema de Afeitar 8oz | Protege la piel de la irritación y escozor', 'La Crema de Afeitar de Mel Bros Co combina un aroma sofisticado con una fórmula excepcional. [cite: 319] Su espuma cremosa no solo envuelve la piel con elegancia, sino que también elimina la irritación y cortaduras causadas por la navaja. [cite: 320] Experimenta un afeitado suave y lujoso que deja la piel irresistiblemente suave e hidratada. [cite: 321] Un deleite para los sentidos, una indulgencia para la piel. [cite: 322]', NULL, 34.41, 200, 'PROD005AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(36, 'Ron de Bahía Royal Barber 100 ml | Cierra Poros + Tonifica Piel', 'El Ron de Bahía Royal Barber de Mel Bros Co es una joya caribeña para la piel masculina. [cite: 323] Con extractos de plantas y especias del Caribe que le otorgan su aroma distintivo y único, esta fórmula no solo cierra los poros después del afeitado, sino que tonifica la piel. [cite: 324] Su versatilidad se extiende a su uso como loción corporal. [cite: 325] Presentado en un envase exclusivo de vidrio de la línea Royal Barber, está elaborado con activos 100% naturales y de alta calidad. [cite: 326] Una experiencia lujosa para la piel después del afeitado. [cite: 327]', NULL, 31.47, 200, 'PROD006AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(37, 'Jabón para Afeitar con Aroma 3.53oz | Hidratante + Afeitado Suave', 'El Jabón para Afeitar con Aroma de Mel Bros Co ofrece una experiencia de afeitado pura y sin complicaciones. [cite: 328] Su fórmula refinada proporciona una espuma rica y suave, ideal para aquellos que prefieren un afeitado con fragancias única y distintiva. [cite: 329] Este jabón sin aroma garantiza un deslizamiento suave de la navaja, logrando un afeitado preciso y cómodo, sin distracciones olfativas. [cite: 330] Una elección elegante para quienes buscan simplicidad y eficacia en su rutina de afeitado. [cite: 331]', NULL, 15.00, 200, 'PROD007AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(38, 'Jabón para Afeitar sin Aroma 3.53oz | Hidratante + Afeitado Suave', 'El Jabón para Afeitar sin Aroma de Mel Bros Co ofrece una experiencia de afeitado pura y sin complicaciones. [cite: 332] Su fórmula refinada proporciona una espuma rica y suave, ideal para aquellos que prefieren un afeitado sin fragancias añadidas. [cite: 333] Este jabón sin aroma garantiza un deslizamiento suave de la navaja, logrando un afeitado preciso y cómodo, sin distracciones olfativas. [cite: 334] Una elección elegante para quienes buscan simplicidad y eficacia en su rutina de afeitado. [cite: 335]', NULL, 15.00, 200, 'PROD008AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(39, 'Desinfectante y Limpiador de Brochas 125ml | Desinfecta y Cuida Brochas, Cepillos & Peines', 'Desinfección avanzada: Elimina el 99.99% de bacterias, gérmenes y virus. [cite: 337] Ingrediente activo eficaz: Sales cuaternarias de amonio de 5ª generación. [cite: 337] Rendimiento prolongado: Hasta 125 servicios por botella. [cite: 338] Cuidado de las cerdas: Hidratación con aceite de semilla de pomelo. [cite: 339] Prevención completa: Evita el crecimiento de virus, bacterias y hongos. [cite: 339] Versátil: Ideal para diversos tipos de brochas sin dañarlas. [cite: 340]', NULL, 15.29, 200, 'PROD009AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(40, 'Gomero Navajero Mel Bros Co. | TPE Grado Farmaceutico', 'El Gomero Navajero de Mel Bros Co, hecho de TPE elastómero termoplástico, es un accesorio esencial para mantener la higiene y la limpieza durante el afeitado con navaja. [cite: 341] Su material TPE es completamente inerte, lo que garantiza que no afecte el filo de la cuchilla. [cite: 342] Además, es fácil de lavar, proporcionando una solución práctica y duradera para el cuidado de tu navaja y una experiencia de afeitado más higiénica. [cite: 343]', NULL, 25.29, 200, 'PROD010AF', 12, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(41, 'Jabón de Carbón Activado 170gr | Detox y Limpieza', 'El Jabón de Carbón Activado de Mel Bros Co. es una potente fórmula diseñada para detoxificar y limpiar la piel. [cite: 344] Con propiedades absorbentes del carbón activado, elimina impurezas y toxinas, dejando la piel fresca y revitalizada. [cite: 345] Ideal para una limpieza profunda, este jabón ofrece una experiencia refrescante y purificante en cada uso. [cite: 346]', NULL, 19.41, 200, 'PROD001PI', 13, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(42, 'Tratamiento Anti Edad 2oz | Ácido Hialurónico y Extracto Pepino', 'El Tratamiento Anti Edad con Ácido Hialurónico de Mel Bros Co es una crema ligera de rápida absorción que combate los signos del envejecimiento. [cite: 347] Enriquecido con extracto de pepino, árnica, pantenol, urea y vitaminas, este tratamiento rejuvenecedor nutre la piel, proporciona hidratación intensa y ayuda a reducir arrugas y líneas de expresión. [cite: 348] Su fórmula avanzada ofrece resultados efectivos, dejando la piel con un aspecto más firme, suave y revitalizado. [cite: 349]', NULL, 35.29, 200, 'PROD002PI', 13, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(43, 'Exfoliador Facial de Cascara de Nuez 4oz | Limpieza Natural', 'El Exfoliador Facial de Cáscara de Nuez de Mel Bros Co. es una fórmula con esencia de lavanda y activos naturales. [cite: 351] Elimina suavemente las impurezas, células muertas y revitaliza la piel, dejándola con un aspecto fresco y renovado. [cite: 352] La combinación de cáscara de nuez, esencia de lavanda y ingredientes naturales ofrece una exfoliación efectiva, dejando la piel suave y luminosa. [cite: 353] Ideal para una rutina de cuidado facial que busca limpieza profunda y revitalización. [cite: 354]', NULL, 19.41, 200, 'PROD003PI', 13, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(44, 'Mascarilla Facial Wake Up Revitalizante 2.7oz', 'La Mascarilla Facial Wake Revitalizante es un oasis de revitalización. [cite: 356] Elaborada con extractos de hamamelis y aloe vera, junto con una sinergia de aceites esenciales, esta mascarilla ofrece una experiencia relajante y revitalizante. [cite: 357] Su exquisito aroma está diseñado para calmar los sentidos y sumergir al usuario en un estado vitalizante. [cite: 358] Un toque elegante de bienestar que nutre la piel y renueva el espíritu, transformando el cuidado facial en un momento indulgente y revitalizante. [cite: 359]', NULL, 18.24, 200, 'PROD004PI', 13, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(45, '2 Meses Bálsamo Clásico 2oz | Minoxidil + Biotina & Queratina (Kit)', 'Tratamiento de Crecimiento de Barba y Bigote para 2 meses para el crecimiento de barba y bigote. [cite: 360] Fórmula potente para estimular el crecimiento, fortalecer y suavizar la barba y el bigote. [cite: 361] Transforma tu vello facial con resultados visibles y duraderos. [cite: 361]', NULL, 52.88, 200, 'PROD001K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(46, '2 Meses Gel Bálsamo de Crecimiento 2oz | Minoxidil 5% + Biotina & Queratina (Kit)', 'Tratamiento para 2 meses del Gel Bálsamo de Crecimiento de Barba y Bigote con Biotina, Queratina y Aceite de Bergamota. [cite: 362] El gel bálsamo está formulado para estimular el crecimiento del cabello, fortalecerlo y mejorar su apariencia general. [cite: 363]', NULL, 52.88, 200, 'PROD002K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(47, '2 Meses Bálsamo Clásico 2oz + Jabón Carbón Activado 100gr (Kit)', 'El tratamiento de 2 Bálsamos Clásicos con el Jabón de Carbón Activado ayuda a limpiar los poros y eliminar impurezas, mientras que los ingredientes naturales promueven el crecimiento saludable del vello. [cite: 365] Utilizado regularmente, este tratamiento ayuda a mejorar la densidad y el grosor de la barba y el bigote, proporcionando resultados visibles en poco tiempo. [cite: 366]', NULL, 67.59, 200, 'PROD003K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(48, 'Set Viajero de Pomadas de 2oz (5 Piezas)', 'Set de pomadas Mel Bros Co de 2 oz. [cite: 279] Las ceras y pomadas de 2oz|60ml son ideal para viajes y llevar en la maleta de mano. [cite: 280] Contiene una variedad de pomadas y ceras para probar cada una. [cite: 281] ¡Todo lo que necesitas para el cuidado de tu cabello en un práctico kit de viaje! [cite: 282] Incluye: 1 pieza Pomada Clásica 2oz, 1 pieza Pomada Original 2oz, 1 pieza Pomada Mate 2oz, 1 pieza Pomada Base Aceite 2oz, 1 pieza Cera Híbrida 2oz. [cite: 282]', NULL, 66.18, 200, 'PROD004K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(49, 'Kit de Afeitado', 'Una experiencia de afeitado premium. Diseñado para el hombre que valora el detalle, el Kit de Afeitado de Mel Bros Co. combina estilo, precisión y cuidado en cada paso. [cite: 371] Incluye los siguientes productos: Jabon para Afeitar con Aroma, Soothing After Shave (Crema), Gel Deslizante para Afeitado, Aceite Pre Afeitado Royal Barber, Ron de Bahia Royal Barber. [cite: 371]', NULL, 89.71, 200, 'PROD005K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(50, 'Kit Cuidado de Barba', 'Una experiencia de cuidado profundo. [cite: 372] Una experiencia premium de grooming que combina elegancia, eficacia y estilo. [cite: 373] Diseñado para nutrir, suavizar y mantener tu barba impecable, todos los días. [cite: 374]', NULL, 75.29, 200, 'PROD006K', 14, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(51, 'Reelance Crecimiento Pestañas 6ml', 'Serum para el crecimiento de pestañas es un tratamiento especial que brinda volumen, longitud y un alargamiento increíble a tus pestañas. [cite: 375] Su formulación única mejora la salud de tus pestañas, estimulando su crecimiento natural a niveles sorprendentes. [cite: 376] Respaldado por una exhaustiva investigación, este producto te permite lucir unas pestañas más largas y hermosas. [cite: 377]', NULL, 23.53, 200, 'PROD001R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(52, 'Reelance Loción Hombre 60 ml', 'Loción para hombres es el producto ideal para regenerar y estimular el crecimiento de cabello nuevo en áreas previamente afectadas. [cite: 378] Además, previene la pérdida del cabello y mejora la salud de los folículos del cuero cabelludo. [cite: 379] Con una fórmula científicamente innovadora, obtendrás los mejores resultados para recuperar tu cabello perdido. [cite: 380]', NULL, 23.53, 200, 'PROD002R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(53, 'Reelance Crecimiento de Cejas 60ml', 'Tratamiento para el crecimiento de cejas es un producto científicamente comprobado con activos que aumentarán el grosor de tus cejas, brindando una mirada más vigorosa y natural. [cite: 381] Su formulación inteligente promueve el crecimiento de las cejas de manera estéticamente ideal para cada usuario, al tiempo que cuida de tu piel. [cite: 382]', NULL, 23.53, 200, 'PROD003R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(54, 'Reelance Cera Híbrida 120ml', 'Innovador producto que ofrece un agarre duradero y aspecto natural. [cite: 383] Hecho con fijadores vegetales, no obstruye los folículos capilares, permitiendo la oxigenación del cuero cabelludo y estimulando el crecimiento de cabello nuevo. [cite: 384] Satisface la necesidad de estilizar sin comprometer la salud del folículo, fortalece y previene la pérdida capilar. [cite: 385] Complemento ideal para tu tratamiento anti-caída, aportando estilo y cuidado. [cite: 386]', NULL, 23.53, 200, 'PROD004R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(55, 'Reelance Tratamiento Restaurador 120ml', 'Tratamiento nutritivo restaurador ha sido diseñado especialmente para aquellos usuarios que sufren de cabello dañado debido a diversos factores, como tintes, tratamientos químicos, el uso de secadoras y otros motivos. [cite: 387] Este tratamiento no solo recupera la salud del cabello, sino que también lo mejora, brindándole vida, volumen y brillo. [cite: 388] Con su fórmula única, elimina imperfecciones y afecciones capilares, proporcionando hidratación, acondicionamiento y una apariencia natural y saludable para tu cabello. [cite: 389]', NULL, 23.53, 200, 'PROD005R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(56, 'Reelance Shampoo Mujer 120ml', 'Shampoo para mujeres ofrece una formulación natural que brinda múltiples beneficios al cuero cabelludo. [cite: 390] Además de neutralizar su pH, desintoxica los folículos capilares de los contaminantes diarios. [cite: 391] Contiene activos científicamente comprobados que frenan y estimulan el crecimiento de cabello nuevo en poco tiempo. [cite: 392] Nuestro shampoo es libre de sulfatos y parabenos, lo que contribuye al completo bienestar y salud de tu cabello. [cite: 393]', NULL, 23.53, 200, 'PROD006R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(57, 'Reelance Loción Mujer 60ml', 'Loción para mujer es una fórmula innovadora y científica, cuidadosamente desarrollada con ingredientes de calidad y tecnología avanzada. [cite: 394] Estimula el crecimiento de cabello nuevo y previene la pérdida de cabello. [cite: 395] Con nuestra formulación especial, experimentarás un crecimiento capilar un 25% a 45% más rápido de lo normal, logrando un incremento notable en la longitud del cabello en poco tiempo. [cite: 396] Además, nuestros ingredientes únicos nutren el cabello desde la raíz hasta las puntas, mejorando la salud general del cuero cabelludo. [cite: 397]', NULL, 23.53, 200, 'PROD007R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL),
(58, 'Reelance Shampoo Hombre 120ml', 'Shampoo para hombres cuenta con una formulación que ofrece múltiples beneficios al cuero cabelludo. [cite: 398] Además de neutralizar su pH, desintoxica los folículos del cabello de los contaminantes a los que están expuestos a diario. [cite: 399] Incorpora activos científicamente comprobados que frenan y estimulan el crecimiento de cabello nuevo en un corto período de tiempo. [cite: 400] Nuestro shampoo es libre de sulfatos y parabenos, lo que contribuye a la salud general de tu cabello. [cite: 400]', NULL, 23.53, 200, 'PROD008R', 15, 1, '2025-07-25 21:38:34', '2025-07-25 21:38:34', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_promocion`
--

DROP TABLE IF EXISTS `producto_promocion`;
CREATE TABLE `producto_promocion` (
  `promocion_id` bigint UNSIGNED NOT NULL,
  `producto_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `producto_promocion`
--

INSERT INTO `producto_promocion` VALUES
(1, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(2, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(3, 1, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(3, 2, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(4, 1, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(5, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(6, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(7, 1, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(7, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(7, 4, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(7, 6, '2025-07-25 22:23:20', '2025-07-25 22:23:20'),
(8, 3, '2025-07-25 22:23:20', '2025-07-25 22:23:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones`
--

DROP TABLE IF EXISTS `promociones`;
CREATE TABLE `promociones` (
  `id` bigint UNSIGNED NOT NULL,
  `codigo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_descuento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: PORCENTAJE, MONTO_FIJO',
  `valor_descuento` decimal(10,2) NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `usos_maximos_total` int UNSIGNED DEFAULT NULL,
  `usos_maximos_por_cliente` int UNSIGNED DEFAULT '1',
  `usos_actuales` int UNSIGNED NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `aplica_a_todos_productos` tinyint(1) NOT NULL DEFAULT '0',
  `aplica_a_todos_servicios` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `promociones`
--

INSERT INTO `promociones` VALUES
(1, 'BUENFINOFICIAL', 'El Buen Fin BarberMusicSpa', 'Aprovecha grandes descuentos en servicios y productos seleccionados durante El Buen Fin.', 'Porcentaje', 0.25, '2025-11-14 00:00:00', '2025-11-20 00:00:00', 1000, 1, 0, 1, 1, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(2, 'REGALANAVIDAD', 'Celebración Navideña BarberMusicSpa', 'Regala y regálate bienestar con nuestros paquetes especiales de Navidad y Año Nuevo.', 'Cantidad Fija', 10.00, '2025-12-01 00:00:00', '2025-12-31 00:00:00', 500, NULL, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(3, 'AMORYESTILO', 'Promoción Amor y Amistad', 'Sorprende a tu pareja con un paquete de spa para dos o un servicio exclusivo.', 'Porcentaje', 0.20, '2026-02-10 00:00:00', '2026-02-16 00:00:00', 200, 1, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(4, 'CONSENTIMAMA', 'Mamá Merece un Spa', 'Consiente a mamá con un masaje relajante o un facial especial en su día.', 'Porcentaje', 0.15, '2026-05-05 00:00:00', '2026-05-12 00:00:00', 300, 1, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(5, 'PAPAPREMIUM', 'El Barbero Consentidor', 'Regalos y experiencias exclusivas para papá en BarberMusicSpa.', 'Cantidad Fija', 5.00, '2026-06-13 00:00:00', '2026-06-19 00:00:00', 250, 1, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(6, 'VIVAMEXICO', 'Orgullo Mexicano en BarberMusicSpa', 'Celebra con un 10% de descuento en todos los servicios de barbería.', 'Porcentaje', 0.10, '2025-09-12 00:00:00', '2025-09-17 00:00:00', 400, NULL, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(7, 'ESTILOCATRINA', 'Noche de Catrinas y Estilo', 'Atrevidas promociones para lucir espectacular en Halloween y Día de Muertos.', 'Porcentaje', 0.15, '2025-10-28 00:00:00', '2025-11-03 00:00:00', 180, 1, 0, 1, 1, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL),
(8, 'NUEVOCICLO', 'Estilo para el Nuevo Ciclo', 'Descuentos especiales en cortes y tratamientos capilares para la vuelta a clases.', 'Porcentaje', 0.10, '2025-08-10 00:00:00', '2025-08-25 00:00:00', 350, NULL, 0, 1, 0, 1, '2025-07-25 20:28:47', '2025-07-25 20:28:47', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promocion_servicio`
--

DROP TABLE IF EXISTS `promocion_servicio`;
CREATE TABLE `promocion_servicio` (
  `promocion_id` bigint UNSIGNED NOT NULL,
  `servicio_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `promocion_servicio`
--

INSERT INTO `promocion_servicio` VALUES
(1, 1, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(1, 2, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(1, 6, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(1, 11, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(1, 20, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(2, 5, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(2, 12, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(2, 16, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(2, 17, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(2, 18, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(3, 8, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(3, 10, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(3, 13, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(3, 17, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(4, 7, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(4, 8, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(4, 9, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(4, 15, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(5, 1, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(5, 2, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(5, 3, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(6, 1, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(6, 7, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(6, 11, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(6, 21, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(7, 11, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(7, 14, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(7, 22, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(8, 1, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(8, 14, '2025-07-26 00:20:14', '2025-07-26 00:20:14'),
(8, 24, '2025-07-26 00:20:14', '2025-07-26 00:20:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recordatorios`
--

DROP TABLE IF EXISTS `recordatorios`;
CREATE TABLE `recordatorios` (
  `id` bigint UNSIGNED NOT NULL,
  `usuario_id` bigint UNSIGNED NOT NULL,
  `agendamiento_id` bigint UNSIGNED DEFAULT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_hora_recordatorio` datetime NOT NULL,
  `canal_notificacion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'EMAIL' COMMENT 'Ej: EMAIL, SMS, PUSH_NOTIFICATION',
  `enviado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_envio` datetime DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fijado` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `recordatorios`
--

INSERT INTO `recordatorios` VALUES
(1, 1, 1, 'Cita Mañana Barbería', 'Recordatorio de tu corte de cabello con Juan Pérez.', '2025-07-25 10:00:00', 'Email', 1, '2025-07-25 09:58:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(2, 1, 1, 'Recordatorio Final Cita', 'Tu cita de corte de cabello es en 1 hora.', '2025-07-26 09:00:00', 'SMS', 1, '2025-07-26 08:55:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(3, 2, 2, 'Cita Mañana Afeitado', 'Recordatorio de tu afeitado clásico con María López.', '2025-07-25 11:30:00', 'WhatsApp', 1, '2025-07-25 11:28:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(4, 3, 3, 'Confirmación Manicura', 'Tu cita de manicura con Carlos García ha sido confirmada.', '2025-07-26 09:00:00', 'Email', 1, '2025-07-26 08:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(5, 4, 4, 'Cita Pendiente Color', 'Recordatorio de tu consulta de colorimetría.', '2025-07-26 14:00:00', 'SMS', 1, '2025-07-26 13:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(6, 5, 5, 'Recordatorio Cita Próxima', 'No olvides tu corte de puntas con Luis Ramírez.', '2025-07-27 10:30:00', 'Email', 1, '2025-07-27 10:25:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(7, 6, 6, 'Cita Pedicura Confirmada', 'Tu cita de pedicura con Sofía Castro está confirmada.', '2025-07-27 12:00:00', 'WhatsApp', 1, '2025-07-27 11:58:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(8, 7, 7, 'Cancelación Masaje', 'Tu masaje capilar fue cancelado. Ponte en contacto.', '2025-07-28 09:30:00', 'SMS', 0, '2025-07-28 09:00:00', 0, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(9, 8, 8, 'Recordatorio Peinado', 'Tu cita de peinado con Laura Díaz es mañana.', '2025-07-28 15:00:00', 'Email', 1, '2025-07-28 14:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(10, 9, 9, 'Tratamiento Facial', 'Recordatorio de tu tratamiento facial con Ricardo Morales.', '2025-07-29 11:00:00', 'WhatsApp', 1, '2025-07-29 10:55:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(11, 10, 10, 'Alisado Permanente Recordatorio', 'Tu cita de alisado con Elena Ruiz es mañana.', '2025-07-29 16:00:00', 'Email', 1, '2025-07-29 15:50:00', 1, 1, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(12, 1, 11, 'Afeitado de Mantenimiento', 'Recordatorio de tu cita de afeitado.', '2025-07-30 09:00:00', 'SMS', 1, '2025-07-30 08:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(13, 11, 12, 'Arreglo de Barba', 'Tu cita de arreglo de barba con Gabriela Vargas es mañana.', '2025-07-30 14:00:00', 'Email', 1, '2025-07-30 13:55:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(14, 12, 13, 'Depilación Cera', 'Recordatorio de tu cita de depilación con Héctor Soto.', '2025-07-31 10:00:00', 'WhatsApp', 1, '2025-07-31 09:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(15, 21, 14, 'Corte Rápido', 'Tu corte de cabello rápido con Isabella Morales es mañana.', '2025-07-31 16:00:00', 'SMS', 0, NULL, 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(16, 14, 15, 'Manicura Express', 'Recordatorio de tu cita de manicura.', '2025-08-01 09:30:00', 'Email', 1, '2025-08-01 09:25:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(17, 15, 16, 'Tratamiento Queratina', 'Tu tratamiento de queratina con Camila Pérez es mañana.', '2025-08-01 14:00:00', 'WhatsApp', 1, '2025-08-01 13:50:00', 1, 1, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(18, 16, 17, 'Masaje Cancelado', 'Tu masaje capilar fue cancelado. Por favor, reagenda.', '2025-08-02 10:00:00', 'Email', 0, '2025-08-02 09:45:00', 0, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(19, 17, 18, 'Cita de Peinado', 'Tu cita de peinado con Diana Gómez es mañana.', '2025-08-02 16:00:00', 'SMS', 1, '2025-08-02 15:50:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(20, 18, 19, 'Limpieza Facial', 'Recordatorio de tu cita de limpieza facial con Esteban Díaz.', '2025-08-03 11:00:00', 'Email', 1, '2025-08-03 10:55:00', 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10'),
(21, 19, 20, 'Alisado Progresivo', 'Tu cita de alisado progresivo con Laura Rodríguez es mañana.', '2025-08-03 15:00:00', 'WhatsApp', 0, NULL, 1, 0, '2025-07-25 23:59:10', '2025-07-25 23:59:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reseñas`
--

DROP TABLE IF EXISTS `reseñas`;
CREATE TABLE `reseñas` (
  `id` bigint UNSIGNED NOT NULL,
  `cliente_usuario_id` bigint UNSIGNED NOT NULL,
  `calificacion` tinyint UNSIGNED NOT NULL COMMENT '1 a 5 estrellas',
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `reseñable_id` bigint UNSIGNED NOT NULL COMMENT 'ID del modelo reseñado',
  `reseñable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Namespace del modelo reseñado, ej: App\\Models\\Servicio, App\\Models\\Producto, App\\Models\\Personal',
  `aprobada` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_reseña` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `reseñas`
--

INSERT INTO `reseñas` VALUES
(1, 1, 5, 'Excelente corte de cabello, ¡Juan Pérez es un artista!', 1, 'service', 1, '2025-07-20 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(2, 2, 4, 'El afeitado clásico fue muy relajante, aunque un poco tardado.', 4, 'service', 1, '2025-07-18 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(3, 3, 5, 'Manicura impecable, Carlos García hizo un trabajo maravilloso.', 6, 'service', 1, '2025-07-22 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(4, 4, 3, 'La colorimetría no fue exactamente lo que esperaba, pero el trato fue bueno.', 8, 'service', 1, '2025-07-15 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(5, 5, 5, 'Siempre salgo satisfecho con el corte aquí. ¡Profesionales!', 1, 'service', 1, '2025-07-24 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(6, 6, 4, 'Pedicura muy completa, mis pies lo agradecen.', 7, 'service', 1, '2025-07-19 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(7, 7, 5, 'El masaje capilar fue increíble, me siento renovado.', 2, 'service', 1, '2025-07-21 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(8, 8, 4, 'Mi peinado para el evento quedó perfecto, muy buen trabajo.', 9, 'service', 1, '2025-07-16 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(9, 9, 2, 'El tratamiento facial no me convenció mucho, no vi grandes cambios.', 3, 'service', 1, '2025-07-17 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(10, 10, 5, 'Alisado permanente de alta calidad, dura muchísimo.', 11, 'service', 1, '2025-07-23 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(11, 1, 4, 'El servicio de Peinado fue rápido y profesional, muy contenta.', 9, 'service', 1, '2025-07-25 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(12, 2, 5, 'Tratamiento de Queratina excelente, mi cabello luce muy sano.', 10, 'service', 1, '2025-07-25 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(13, 1, 5, 'El Bálsamo Clásico de Crecimiento de Barba es excelente, ¡mi barba ha crecido mucho!', 1, 'product', 1, '2025-07-10 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(14, 2, 4, 'El Shampoo Estimulante deja el cabello muy limpio y fresco.', 3, 'product', 1, '2025-07-12 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(15, 3, 3, 'El Gel Bálsamo de Crecimiento no me dio los resultados esperados tan rápido.', 2, 'product', 1, '2025-07-14 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(16, 4, 5, 'La Loción Mujer Reelance es fantástica para la densidad de mi cabello.', 4, 'product', 1, '2025-07-11 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(17, 5, 4, 'El Shampoo Hombre Reelance es muy bueno, lo uso a diario.', 6, 'product', 1, '2025-07-13 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(18, 7, 4, 'Recomiendo este bálsamo, se siente bien en la piel y la barba.', 1, 'product', 1, '2025-07-20 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(19, 9, 5, 'Mi shampoo favorito, muy buen aroma y efecto.', 3, 'product', 1, '2025-07-18 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02'),
(20, 10, 5, 'La Loción Hombre Reelance me ha ayudado mucho con la caída del cabello.', 5, 'product', 1, '2025-07-25 00:00:00', '2025-07-25 23:46:02', '2025-07-25 23:46:02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

DROP TABLE IF EXISTS `servicios`;
CREATE TABLE `servicios` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imagen_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `precio_base` decimal(10,2) NOT NULL,
  `duracion_minutos` int UNSIGNED NOT NULL,
  `categoria_id` bigint UNSIGNED DEFAULT NULL,
  `especialidad_requerida_id` bigint UNSIGNED DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` VALUES
(1, 'SculpSure', 'Reducción de grasa localizada no invasiva mediante tecnología láser.', NULL, 150.00, 45, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(2, 'Lipo sin Cirugía', 'Tratamiento no invasivo para la eliminación de depósitos de grasa.', NULL, 120.00, 60, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(3, 'Criolipolisis', 'Congelación de células grasas para su eliminación natural del cuerpo.', NULL, 180.00, 60, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(4, 'Paquete Reafirmante', 'Conjunto de sesiones para mejorar la firmeza y elasticidad de la piel corporal.', NULL, 100.00, 75, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(5, 'Levantamiento de Glúteos', 'Tratamiento para mejorar la forma y firmeza de los glúteos.', NULL, 90.00, 60, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(6, 'Eliminación de Celulitis', 'Sesiones enfocadas en reducir la apariencia de la celulitis.', NULL, 80.00, 60, 2, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(7, 'HIFU Facial', 'Lifting facial no quirúrgico para tensar la piel y reducir arrugas.', NULL, 200.00, 90, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(8, 'Radiofrecuencia Facial', 'Rejuvenecimiento facial que mejora la producción de colágeno.', NULL, 70.00, 60, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(9, 'Hidradermoabrasión', 'Limpieza facial profunda y exfoliación con sueros hidratantes.', NULL, 60.00, 60, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(10, 'Microdermoabrasión', 'Exfoliación mecánica para renovar la piel del rostro y mejorar su textura.', NULL, 50.00, 45, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(11, 'Hollywood Peel', 'Tratamiento facial con láser para mejorar el tono y la textura de la piel.', NULL, 80.00, 45, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(12, 'Limpieza Facial', 'Limpieza básica y profunda para eliminar impurezas y revitalizar la piel.', NULL, 40.00, 60, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(13, 'Despigmentación Facial', 'Tratamiento para reducir manchas y unificar el tono de la piel del rostro.', NULL, 75.00, 60, 3, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(14, 'Maderoterapia', 'Masaje con instrumentos de madera para modelar el cuerpo y reducir celulitis.', NULL, 60.00, 60, 4, 2, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(15, 'Masaje Relajante', 'Masaje que alivia tensiones y promueve la relajación total del cuerpo.', NULL, 50.00, 60, 4, 2, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(16, 'Arreglo y Diseño de Barba', 'Perfilado y estilizado profesional de barba y bigote.', NULL, 20.00, 30, 5, 3, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(17, 'Corte de Cabello Masculino', 'Corte de cabello para caballero con estilo y precisión.', NULL, 25.00, 45, 5, 3, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(18, 'Coloración de Cabello', 'Aplicación profesional de tinte o color para el cabello.', NULL, 60.00, 90, 6, 4, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(19, 'Tratamiento Capilar', 'Tratamientos intensivos para la salud y reparación del cabello (hidratación, keratina, etc.).', NULL, 45.00, 60, 6, 4, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(20, 'Corte de Cabello General', 'Corte de cabello unisex, estilo moderno o clásico.', NULL, 30.00, 45, 6, 4, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(21, 'Depilación Láser SHR (Sesión)', 'Sesión individual de depilación permanente con tecnología SHR.', NULL, 40.00, 30, 7, 5, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(22, 'Diseño y Delineado de Cejas', 'Diseño personalizado y delineado semipermanente de cejas.', NULL, 35.00, 45, 8, 6, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(23, 'Perfilado de Cejas', 'Depilación y forma básica de cejas.', NULL, 15.00, 20, 8, 6, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL),
(24, 'Eliminación de Tatuajes (Sesión)', 'Sesión para remover tatuajes con tecnología láser.', NULL, 100.00, 30, 9, 1, 1, '2025-07-25 20:47:42', '2025-07-25 20:47:42', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio_personal`
--

DROP TABLE IF EXISTS `servicio_personal`;
CREATE TABLE `servicio_personal` (
  `servicio_id` bigint UNSIGNED NOT NULL,
  `personal_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `servicio_personal`
--

INSERT INTO `servicio_personal` VALUES
(1, 1, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 4, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 7, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(1, 10, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 1, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 4, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 7, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(2, 10, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(3, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(3, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(3, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(4, 1, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(4, 4, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(4, 7, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(4, 10, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(5, 1, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(5, 4, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(5, 7, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(5, 10, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(6, 3, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(6, 8, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(7, 3, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(7, 8, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(8, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(8, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(8, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(9, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(9, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(9, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(10, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(10, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(10, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(11, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(11, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(11, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(12, 2, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(12, 5, '2025-07-25 23:30:11', '2025-07-25 23:30:11'),
(12, 9, '2025-07-25 23:30:11', '2025-07-25 23:30:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio_sucursal`
--

DROP TABLE IF EXISTS `servicio_sucursal`;
CREATE TABLE `servicio_sucursal` (
  `servicio_id` bigint UNSIGNED NOT NULL,
  `sucursal_id` bigint UNSIGNED NOT NULL,
  `precio_en_sucursal` decimal(10,2) DEFAULT NULL COMMENT 'Precio específico del servicio en esta sucursal, si difiere del base del servicio',
  `esta_disponible` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Si el servicio está actualmente activo/ofreciéndose en esta sucursal',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `servicio_sucursal`
--

INSERT INTO `servicio_sucursal` VALUES
(1, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(1, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(2, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(3, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(4, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(5, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(6, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(7, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(8, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(9, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(10, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(11, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 1, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 2, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 3, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 4, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 5, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 6, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16'),
(12, 7, NULL, 1, '2025-07-25 23:29:16', '2025-07-25 23:29:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

DROP TABLE IF EXISTS `sucursales`;
CREATE TABLE `sucursales` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono_contacto` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_contacto` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_maps` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` VALUES
(15, 'BarberMusicSpa San Luis Potosí (Plaza San Luis)', NULL, '4441021114', 'barbermusicspa.plazasanluis@gmail.com', 'https://maps.app.goo.gl/59MadN6Ji22s3R677', 22.1558000, -101.0189000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(16, 'BarberMusicSpa Coatzacoalcos (Plaza Forum)', NULL, '9212104867', 'barbermusicspa.plazaforum@gmail.com', 'https://maps.app.goo.gl/1CHfFnaRmSVDyuqW6', 18.1367000, -94.4697000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(17, 'BarberMusicSpa Villahermosa (Plaza Altabrisa)', NULL, '9934120021', 'barbermusicspa.altabrisavillahermosa@gmail.com', 'https://maps.app.goo.gl/pTBbYJXVJXyo9ZSJ8', 17.9947000, -92.9304000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(18, 'MusicSpaVillahermosa Mérida (Plaza Altabrisa)', NULL, '9995188579', 'musicspavillahermosa.altabrisamerida@gmail.com', 'https://maps.app.goo.gl/zJ9SuGr6wbxug7En9', 21.0184000, -89.5828000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(19, 'BarberMusicSpa Ciudad del Carmen (Plaza Zentralia)', NULL, '9386886061', 'barbermusicspa.plazazentralia@gmail.com', 'https://maps.app.goo.gl/ai2KZKCc3Wx2kkrh8', 18.6366000, -91.8219000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(20, 'BarberMusicSpa Villahermosa II (Plaza Las Americas)', NULL, '9212104867', 'barbermusicspa.plazalasamericas@gmail.com', 'https://maps.app.goo.gl/nyGbqHxUZt9zyDaM9', 17.9866000, -92.9329000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(21, 'MusicSpaVillahermosa Villahermosa III (Plaza Altabrisa)', NULL, '9934120021', 'musicspavillahermosa.altabrisavillahermosa3@gmail.com', 'https://maps.app.goo.gl/R5GS9YzMc1zSgtFK9', 17.9947000, -92.9304000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transacciones_pago`
--

DROP TABLE IF EXISTS `transacciones_pago`;
CREATE TABLE `transacciones_pago` (
  `id` bigint UNSIGNED NOT NULL,
  `orden_id` bigint UNSIGNED DEFAULT NULL,
  `agendamiento_id` bigint UNSIGNED DEFAULT NULL,
  `cliente_usuario_id` bigint UNSIGNED NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `moneda` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MXN',
  `metodo_pago` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_transaccion_pasarela` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ej: PENDIENTE, COMPLETADO, FALLIDO, REEMBOLSADO',
  `fecha_transaccion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datos_pasarela_request` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `datos_pasarela_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `transacciones_pago`
--

INSERT INTO `transacciones_pago` VALUES
(1, 6, 6, 6, 99.40, 'USD', 'Tarjeta de Crédito (Visa)', 'TXN_ORD6_001', 'Completado', '2025-07-23 16:15:00', '{\"amount\": 99.40, \"currency\": \"USD\", \"card_type\": \"Visa\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD6_001\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(2, 7, 7, 7, 58.00, 'USD', 'PayPal', 'TXN_ORD7_002', 'Completado', '2025-07-24 13:00:00', '{\"amount\": 58.00, \"currency\": \"USD\", \"payer_id\": \"payerORD7\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD7_002\", \"message\": \"Pago completado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(3, 8, 8, 8, 193.80, 'USD', 'Tarjeta de Crédito (Mastercard)', 'TXN_ORD8_003', 'Completado', '2025-07-25 10:00:00', '{\"amount\": 193.80, \"currency\": \"USD\", \"card_type\": \"Mastercard\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD8_003\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(4, 9, 9, 9, 290.00, 'USD', 'Transferencia Bancaria', 'TXN_ORD9_004', 'Completado', '2025-07-25 12:00:00', '{\"amount\": 290.00, \"currency\": \"USD\", \"bank\": \"BankX\"}', '{\"status\": \"success\", \"message\": \"Pago recibido\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(5, 10, 10, 10, 198.00, 'USD', 'Tarjeta de Crédito (Visa)', 'TXN_ORD10_005', 'Pendiente', '2025-07-25 14:30:00', '{\"amount\": 198.00, \"currency\": \"USD\", \"card_type\": \"Visa\"}', '{\"status\": \"pending\", \"message\": \"Procesando pago\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(6, 11, 11, 11, 75.40, 'USD', 'PayPal', 'TXN_ORD11_006', 'Completado', '2025-07-26 09:00:00', '{\"amount\": 75.40, \"currency\": \"USD\", \"payer_id\": \"payerORD11\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD11_006\", \"message\": \"Pago completado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(7, 12, 12, 12, 155.40, 'USD', 'Tarjeta de Crédito (Mastercard)', 'TXN_ORD12_007', 'Completado', '2025-07-26 11:00:00', '{\"amount\": 155.40, \"currency\": \"USD\", \"card_type\": \"Mastercard\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD12_007\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(8, 13, 13, 13, 243.60, 'USD', 'Transferencia Bancaria', 'TXN_ORD13_008', 'Completado', '2025-07-27 10:10:00', '{\"amount\": 243.60, \"currency\": \"USD\", \"bank\": \"BankY\"}', '{\"status\": \"success\", \"message\": \"Pago recibido\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(9, 14, NULL, 21, 98.60, 'USD', 'Tarjeta de Crédito (Visa)', 'TXN_ORD14_009', 'Completado', '2025-07-27 13:00:00', '{\"amount\": 98.60, \"currency\": \"USD\", \"card_type\": \"Visa\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD14_009\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(10, 15, 15, 15, 216.20, 'USD', 'PayPal', 'TXN_ORD15_010', 'Pendiente', '2025-07-28 09:00:00', '{\"amount\": 216.20, \"currency\": \"USD\", \"payer_id\": \"payerORD15\"}', '{\"status\": \"pending\", \"message\": \"Procesando pago\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(11, 16, 16, 16, 185.60, 'USD', 'Tarjeta de Crédito (Mastercard)', 'TXN_ORD16_011', 'Completado', '2025-07-28 12:00:00', '{\"amount\": 185.60, \"currency\": \"USD\", \"card_type\": \"Mastercard\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD16_011\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(12, 17, 17, 17, 243.20, 'USD', 'Transferencia Bancaria', 'TXN_ORD17_012', 'Completado', '2025-07-29 11:00:00', '{\"amount\": 243.20, \"currency\": \"USD\", \"bank\": \"BankZ\"}', '{\"status\": \"success\", \"message\": \"Pago recibido\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(13, 18, 18, 18, 150.80, 'USD', 'Tarjeta de Crédito (Visa)', 'TXN_ORD18_013', 'Completado', '2025-07-29 12:00:00', '{\"amount\": 150.80, \"currency\": \"USD\", \"card_type\": \"Visa\"}', '{\"status\": \"success\", \"tx_id\": \"TXN_ORD18_013\", \"message\": \"Pago aprobado\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(14, 19, 19, 19, 299.80, 'USD', 'PayPal', 'TXN_ORD19_014', 'Pendiente', '2025-07-30 09:00:00', '{\"amount\": 299.80, \"currency\": \"USD\", \"payer_id\": \"payerORD19\"}', '{\"status\": \"pending\", \"message\": \"Procesando pago\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19'),
(15, 20, 20, 20, 299.80, 'USD', 'Tarjeta de Crédito (Mastercard)', 'TXN_ORD20_015', 'Pendiente', '2025-07-30 11:00:00', '{\"amount\": 299.80, \"currency\": \"USD\", \"card_type\": \"Mastercard\"}', '{\"status\": \"pending\", \"message\": \"Pendiente de aprobación\"}', '2025-07-26 00:18:19', '2025-07-26 00:18:19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id` bigint UNSIGNED NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CLIENTE' COMMENT 'Ej: CLIENTE, EMPLEADO. Si es EMPLEADO, tiene un registro en la tabla `personal`',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `musica_preferencia_navegacion_id` bigint UNSIGNED DEFAULT NULL,
  `sucursal_preferida_id` bigint UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` VALUES
(1, 'Ana García', 'anagarcia123@gmail.com', NULL, 'passwordAna1', NULL, '5512345678', 'user', 1, 2, 15, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(2, 'Carlos Martínez', 'carlosmrtz45@hotmail.com', NULL, 'passwordCar2', NULL, '3321098765', 'user', 1, 3, 16, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(3, 'Sofía López', 'sofialpz789@gmail.com', NULL, 'passwordSof3', NULL, '9987654321', 'user', 1, 5, 18, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(4, 'Javier Rodríguez', 'javier.rodri01@hotmail.com', NULL, 'passwordJav4', NULL, '8111223344', 'user', 1, 1, 19, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(5, 'Valeria Soto', 'valeriasoto55@gmail.com', NULL, 'passwordVal5', NULL, '2299887766', 'user', 1, 6, 17, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(6, 'Pedro Hernández', 'pedrohdz77@hotmail.com', NULL, 'passwordPed6', NULL, '4445556677', 'user', 1, 8, 20, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(7, 'Mariana Pérez', 'marianaprz23@gmail.com', NULL, 'passwordMar7', NULL, '9932109876', 'user', 1, 9, 21, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(8, 'Luis Ramírez', 'luis.ramirez99@hotmail.com', NULL, 'passwordLuis8', NULL, '9381234567', 'user', 1, 4, 19, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(9, 'Brenda Torres', 'brendatrs88@gmail.com', NULL, 'passwordBre9', NULL, '5587654321', 'user', 1, 7, 15, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(10, 'Diego Flores', 'diego.flores11@hotmail.com', NULL, 'passwordDie0', NULL, '3310987654', 'user', 1, 2, 16, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(11, 'Gabriela Ruíz', 'gabrielarz50@gmail.com', NULL, 'passwordGab1', NULL, '9991234567', 'user', 1, 3, 18, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(12, 'Fernando Castro', 'fercastro62@hotmail.com', NULL, 'passwordFer2', NULL, '8123456789', 'user', 1, 5, 19, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(13, 'Isabel Morales', 'isabelmlz17@gmail.com', NULL, 'passwordIsa3', NULL, '2223334455', 'user', 1, 1, 17, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(14, 'Ricardo Gómez', 'ricardogmz34@hotmail.com', NULL, 'passwordRic4', NULL, '4441112233', 'user', 1, 6, 20, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(15, 'Laura Díaz', 'lauradiaz05@gmail.com', NULL, 'passwordLau5', NULL, '9934567890', 'user', 1, 8, 21, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(16, 'Sergio Vázquez', 'sergiovaz71@hotmail.com', NULL, 'passwordSer6', NULL, '9389876543', 'user', 1, 2, 15, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(17, 'Andrea Salazar', 'andreaslz82@gmail.com', NULL, 'passwordAnd7', NULL, '5576543210', 'user', 1, 3, 16, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(18, 'Roberto Ortiz', 'roberto.ortz46@hotmail.com', NULL, 'passwordRob8', NULL, '9981020304', 'user', 1, 5, 18, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(19, 'Pamela Rivas', 'pamelarv93@gmail.com', NULL, 'passwordPam9', NULL, '8156789012', 'user', 1, 9, 19, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(20, 'Jorge Guerrero', 'jorgegurr02@hotmail.com', NULL, 'passwordJor0', NULL, '2291029384', 'user', 1, 7, 17, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `agendamientos`
--
ALTER TABLE `agendamientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `agendamientos_cliente_usuario_id_foreign` (`cliente_usuario_id`),
  ADD KEY `agendamientos_personal_id_foreign` (`personal_id`),
  ADD KEY `agendamientos_servicio_id_foreign` (`servicio_id`),
  ADD KEY `agendamientos_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categorias_nombre_unique` (`nombre`);

--
-- Indices de la tabla `detalle_ordenes`
--
ALTER TABLE `detalle_ordenes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `detalle_ordenes_orden_id_foreign` (`orden_id`),
  ADD KEY `detalle_ordenes_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `direcciones_direccionable_id_direccionable_type_index` (`direccionable_id`,`direccionable_type`);

--
-- Indices de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `especialidades_nombre_unique` (`nombre`);

--
-- Indices de la tabla `especialidad_personal`
--
ALTER TABLE `especialidad_personal`
  ADD PRIMARY KEY (`especialidad_id`,`personal_id`),
  ADD KEY `especialidad_personal_personal_id_foreign` (`personal_id`);

--
-- Indices de la tabla `excepciones_horario_sucursal`
--
ALTER TABLE `excepciones_horario_sucursal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `excepciones_horario_sucursal_sucursal_id_fecha_index` (`sucursal_id`,`fecha`);

--
-- Indices de la tabla `horarios_sucursal`
--
ALTER TABLE `horarios_sucursal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `horarios_sucursal_sucursal_id_dia_semana_unique` (`sucursal_id`,`dia_semana`);

--
-- Indices de la tabla `musica_preferencias_navegacion`
--
ALTER TABLE `musica_preferencias_navegacion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `musica_preferencias_navegacion_nombre_opcion_unique` (`nombre_opcion`);

--
-- Indices de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ordenes_numero_orden_unique` (`numero_orden`),
  ADD KEY `ordenes_cliente_usuario_id_foreign` (`cliente_usuario_id`);

--
-- Indices de la tabla `personal`
--
ALTER TABLE `personal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_usuario_id_unique` (`usuario_id`),
  ADD UNIQUE KEY `personal_numero_empleado_unique` (`numero_empleado`),
  ADD KEY `personal_sucursal_asignada_id_foreign` (`sucursal_asignada_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `productos_sku_unique` (`sku`),
  ADD KEY `productos_categoria_id_foreign` (`categoria_id`);

--
-- Indices de la tabla `producto_promocion`
--
ALTER TABLE `producto_promocion`
  ADD PRIMARY KEY (`promocion_id`,`producto_id`),
  ADD KEY `producto_promocion_producto_id_foreign` (`producto_id`);

--
-- Indices de la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `promociones_codigo_unique` (`codigo`);

--
-- Indices de la tabla `promocion_servicio`
--
ALTER TABLE `promocion_servicio`
  ADD PRIMARY KEY (`promocion_id`,`servicio_id`),
  ADD KEY `promocion_servicio_servicio_id_foreign` (`servicio_id`);

--
-- Indices de la tabla `recordatorios`
--
ALTER TABLE `recordatorios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recordatorios_usuario_id_foreign` (`usuario_id`),
  ADD KEY `recordatorios_agendamiento_id_foreign` (`agendamiento_id`);

--
-- Indices de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reseñas_cliente_usuario_id_foreign` (`cliente_usuario_id`),
  ADD KEY `reseñas_reseñable_id_reseñable_type_index` (`reseñable_id`,`reseñable_type`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `servicios_categoria_id_foreign` (`categoria_id`),
  ADD KEY `servicios_especialidad_requerida_id_foreign` (`especialidad_requerida_id`);

--
-- Indices de la tabla `servicio_personal`
--
ALTER TABLE `servicio_personal`
  ADD PRIMARY KEY (`servicio_id`,`personal_id`),
  ADD KEY `servicio_personal_personal_id_foreign` (`personal_id`);

--
-- Indices de la tabla `servicio_sucursal`
--
ALTER TABLE `servicio_sucursal`
  ADD PRIMARY KEY (`servicio_id`,`sucursal_id`),
  ADD KEY `servicio_sucursal_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sucursales_email_contacto_unique` (`email_contacto`);

--
-- Indices de la tabla `transacciones_pago`
--
ALTER TABLE `transacciones_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transacciones_pago_id_transaccion_pasarela_unique` (`id_transaccion_pasarela`),
  ADD KEY `transacciones_pago_orden_id_foreign` (`orden_id`),
  ADD KEY `transacciones_pago_agendamiento_id_foreign` (`agendamiento_id`),
  ADD KEY `transacciones_pago_cliente_usuario_id_foreign` (`cliente_usuario_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuarios_email_unique` (`email`),
  ADD UNIQUE KEY `usuarios_telefono_unique` (`telefono`),
  ADD KEY `usuarios_musica_preferencia_navegacion_id_foreign` (`musica_preferencia_navegacion_id`),
  ADD KEY `usuarios_sucursal_preferida_id_foreign` (`sucursal_preferida_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `agendamientos`
--
ALTER TABLE `agendamientos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `detalle_ordenes`
--
ALTER TABLE `detalle_ordenes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de la tabla `direcciones`
--
ALTER TABLE `direcciones`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `excepciones_horario_sucursal`
--
ALTER TABLE `excepciones_horario_sucursal`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT de la tabla `horarios_sucursal`
--
ALTER TABLE `horarios_sucursal`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT de la tabla `musica_preferencias_navegacion`
--
ALTER TABLE `musica_preferencias_navegacion`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `personal`
--
ALTER TABLE `personal`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `recordatorios`
--
ALTER TABLE `recordatorios`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `reseñas`
--
ALTER TABLE `reseñas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `transacciones_pago`
--
ALTER TABLE `transacciones_pago`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `agendamientos`
--
ALTER TABLE `agendamientos`
  ADD CONSTRAINT `agendamientos_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `agendamientos_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `agendamientos_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`),
  ADD CONSTRAINT `agendamientos_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`);

--
-- Filtros para la tabla `detalle_ordenes`
--
ALTER TABLE `detalle_ordenes`
  ADD CONSTRAINT `detalle_ordenes_orden_id_foreign` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_ordenes_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `especialidad_personal`
--
ALTER TABLE `especialidad_personal`
  ADD CONSTRAINT `especialidad_personal_especialidad_id_foreign` FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `especialidad_personal_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `excepciones_horario_sucursal`
--
ALTER TABLE `excepciones_horario_sucursal`
  ADD CONSTRAINT `excepciones_horario_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `horarios_sucursal`
--
ALTER TABLE `horarios_sucursal`
  ADD CONSTRAINT `horarios_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ordenes`
--
ALTER TABLE `ordenes`
  ADD CONSTRAINT `ordenes_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `personal`
--
ALTER TABLE `personal`
  ADD CONSTRAINT `personal_sucursal_asignada_id_foreign` FOREIGN KEY (`sucursal_asignada_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `personal_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `producto_promocion`
--
ALTER TABLE `producto_promocion`
  ADD CONSTRAINT `producto_promocion_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `producto_promocion_promocion_id_foreign` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `promocion_servicio`
--
ALTER TABLE `promocion_servicio`
  ADD CONSTRAINT `promocion_servicio_promocion_id_foreign` FOREIGN KEY (`promocion_id`) REFERENCES `promociones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `promocion_servicio_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `recordatorios`
--
ALTER TABLE `recordatorios`
  ADD CONSTRAINT `recordatorios_agendamiento_id_foreign` FOREIGN KEY (`agendamiento_id`) REFERENCES `agendamientos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `recordatorios_usuario_id_foreign` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reseñas`
--
ALTER TABLE `reseñas`
  ADD CONSTRAINT `reseñas_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD CONSTRAINT `servicios_categoria_id_foreign` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `servicios_especialidad_requerida_id_foreign` FOREIGN KEY (`especialidad_requerida_id`) REFERENCES `especialidades` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `servicio_personal`
--
ALTER TABLE `servicio_personal`
  ADD CONSTRAINT `servicio_personal_personal_id_foreign` FOREIGN KEY (`personal_id`) REFERENCES `personal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `servicio_personal_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `servicio_sucursal`
--
ALTER TABLE `servicio_sucursal`
  ADD CONSTRAINT `servicio_sucursal_servicio_id_foreign` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `servicio_sucursal_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `transacciones_pago`
--
ALTER TABLE `transacciones_pago`
  ADD CONSTRAINT `transacciones_pago_agendamiento_id_foreign` FOREIGN KEY (`agendamiento_id`) REFERENCES `agendamientos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transacciones_pago_cliente_usuario_id_foreign` FOREIGN KEY (`cliente_usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `transacciones_pago_orden_id_foreign` FOREIGN KEY (`orden_id`) REFERENCES `ordenes` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_musica_preferencia_navegacion_id_foreign` FOREIGN KEY (`musica_preferencia_navegacion_id`) REFERENCES `musica_preferencias_navegacion` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `usuarios_sucursal_preferida_id_foreign` FOREIGN KEY (`sucursal_preferida_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
