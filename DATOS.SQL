-- Script Corregido para insertar datos en la base de datos 'bmspa_laravel'
-- Se han ajustado las sentencias INSERT para que coincidan con tu estructura actual
-- y se ha reordenado para respetar las dependencias de claves foráneas.

-- 1. Desactivamos temporalmente la revisión de claves foráneas para evitar errores de orden.
SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Usamos tu base de datos
USE `bmspa_laravel`;

-- 2. Vaciamos las tablas para evitar conflictos de IDs duplicados.
-- ¡ADVERTENCIA! Esto eliminará los datos existentes en estas tablas.
DELETE FROM `agendamientos`;
DELETE FROM `categorias`;
DELETE FROM `detalle_ordenes`;
DELETE FROM `direcciones`;
DELETE FROM `especialidades`;
DELETE FROM `especialidad_personal`;
DELETE FROM `excepciones_horario_sucursal`;
DELETE FROM `horarios_sucursal`;
DELETE FROM `musica_preferencias_navegacion`;
DELETE FROM `ordenes`;
DELETE FROM `personal`;
DELETE FROM `productos`;
DELETE FROM `producto_promocion`;
DELETE FROM `promociones`;
DELETE FROM `promocion_servicio`;
DELETE FROM `recordatorios`;
DELETE FROM `reseñas`;
DELETE FROM `servicios`;
DELETE FROM `servicio_personal`;
DELETE FROM `servicio_sucursal`;
DELETE FROM `sucursales`;
DELETE FROM `transacciones_pago`;
DELETE FROM `usuarios`;


-- 3. Insertamos los datos en un orden lógico para respetar las dependencias.

--
-- Volcado de datos para la tabla `musica_preferencias_navegacion`
--
INSERT INTO `musica_preferencias_navegacion` (`id`, `nombre_opcion`, `descripcion`, `stream_url_ejemplo`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Música Electrónica', 'Género musical que utiliza instrumentos electrónicos y tecnología musical para producir sonidos, ideal para un ambiente moderno y energizante.', 'https://open.spotify.com/playlist/37i9dQZF1DX0FkEbt6HOwE', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(2, 'Música Pop', 'Género musical popular con melodías pegadizas y estructuras sencillas, ideal para un ambiente animado y familiar.', 'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(3, 'Rock Clásico', 'Género que abarca una amplia gama de estilos musicales evolucionados del rock and roll de los años 60-80, perfecto para un ambiente con carácter y nostalgia.', 'https://open.spotify.com/playlist/37i9dQZF1DXcBWIGoYBM5M', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(4, 'Indie Pop / Rock', 'Música alternativa con influencias de rock y pop, a menudo asociada con sellos discográficos independientes, para un ambiente fresco y relajado.', 'https://open.spotify.com/playlist/37i9dQZF1DX2L0iB2NEaK2', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(5, 'Jazz Suave', 'Un estilo de jazz relajante y melódico, ideal para ambientes tranquilos, sofisticados y que invitan a la calma.', 'https://open.spotify.com/playlist/37i9dQZF1DXbKgb5liG50K', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(6, 'Música Latina Pop', 'Géneros populares de habla hispana como reggaetón, pop latino y baladas, para un ambiente alegre y con ritmo.', 'https://open.spotify.com/playlist/37i9dQZF1DX2Nc3B7A90rp', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(7, 'R&B Suave', 'Ritmo y blues contemporáneo con melodías melancólicas y beats relajantes, perfecto para un ambiente íntimo y con estilo.', 'https://open.spotify.com/playlist/37i9dQZF1DXd2tK8sE7wwS', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(8, 'Lo-fi Beats', 'Un género de música electrónica con elementos de jazz, hip-hop y funk, caracterizado por su sonido relajado y atmosférico, ideal para concentración o relajación.', 'https://open.spotify.com/playlist/37i9dQZF1DXc8kgYqQLMfN', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07'),
(9, 'Clásica Relajante', 'Obras de música clásica seleccionadas por su efecto calmante y sereno, para un ambiente de máxima tranquilidad y elegancia.', 'https://open.spotify.com/playlist/37i9dQZF1DXdK7fA3p7y5W', 1, '2025-07-25 19:26:07', '2025-07-25 19:26:07');

--
-- Volcado de datos para la tabla `sucursales`
--
INSERT INTO `sucursales` (`id`, `nombre`, `imagen_path`, `telefono_contacto`, `email_contacto`, `link_maps`, `latitud`, `longitud`, `activo`, `created_at`, `updated_at`, `deleted_at`) VALUES
(15, 'BarberMusicSpa San Luis Potosí (Plaza San Luis)', NULL, '4441021114', 'barbermusicspa.plazasanluis@gmail.com', 'https://maps.app.goo.gl/59MadN6Ji22s3R677', 22.1558000, -101.0189000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(16, 'BarberMusicSpa Coatzacoalcos (Plaza Forum)', NULL, '9212104867', 'barbermusicspa.plazaforum@gmail.com', 'https://maps.app.goo.gl/1CHfFnaRmSVDyuqW6', 18.1367000, -94.4697000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(17, 'BarberMusicSpa Villahermosa (Plaza Altabrisa)', NULL, '9934120021', 'barbermusicspa.altabrisavillahermosa@gmail.com', 'https://maps.app.goo.gl/pTBbYJXVJXyo9ZSJ8', 17.9947000, -92.9304000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(18, 'MusicSpaVillahermosa Mérida (Plaza Altabrisa)', NULL, '9995188579', 'musicspavillahermosa.altabrisamerida@gmail.com', 'https://maps.app.goo.gl/zJ9SuGr6wbxug7En9', 21.0184000, -89.5828000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(19, 'BarberMusicSpa Ciudad del Carmen (Plaza Zentralia)', NULL, '9386886061', 'barbermusicspa.plazazentralia@gmail.com', 'https://maps.app.goo.gl/ai2KZKCc3Wx2kkrh8', 18.6366000, -91.8219000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(20, 'BarberMusicSpa Villahermosa II (Plaza Las Americas)', NULL, '9212104867', 'barbermusicspa.plazalasamericas@gmail.com', 'https://maps.app.goo.gl/nyGbqHxUZt9zyDaM9', 17.9866000, -92.9329000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL),
(21, 'MusicSpaVillahermosa Villahermosa III (Plaza Altabrisa)', NULL, '9934120021', 'musicspavillahermosa.altabrisavillahermosa3@gmail.com', 'https://maps.app.goo.gl/R5GS9YzMc1zSgtFK9', 17.9947000, -92.9304000, 1, '2025-07-25 20:14:19', '2025-07-25 20:14:19', NULL);

--
-- Volcado de datos para la tabla `usuarios`
--
INSERT INTO `usuarios` (`id`, `nombre`, `email`, `email_verified_at`, `password`, `imagen_path`, `telefono`, `rol`, `activo`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Ana García', 'anagarcia123@gmail.com', NULL, 'passwordAna1', NULL, '5512345678', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(2, 'Carlos Martínez', 'carlosmrtz45@hotmail.com', NULL, 'passwordCar2', NULL, '3321098765', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(3, 'Sofía López', 'sofialpz789@gmail.com', NULL, 'passwordSof3', NULL, '9987654321', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(4, 'Javier Rodríguez', 'javier.rodri01@hotmail.com', NULL, 'passwordJav4', NULL, '8111223344', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(5, 'Valeria Soto', 'valeriasoto55@gmail.com', NULL, 'passwordVal5', NULL, '2299887766', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(6, 'Pedro Hernández', 'pedrohdz77@hotmail.com', NULL, 'passwordPed6', NULL, '4445556677', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(7, 'Mariana Pérez', 'marianaprz23@gmail.com', NULL, 'passwordMar7', NULL, '9932109876', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(8, 'Luis Ramírez', 'luis.ramirez99@hotmail.com', NULL, 'passwordLuis8', NULL, '9381234567', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(9, 'Brenda Torres', 'brendatrs88@gmail.com', NULL, 'passwordBre9', NULL, '5587654321', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(10, 'Diego Flores', 'diego.flores11@hotmail.com', NULL, 'passwordDie0', NULL, '3310987654', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(11, 'Gabriela Ruíz', 'gabrielarz50@gmail.com', NULL, 'passwordGab1', NULL, '9991234567', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(12, 'Fernando Castro', 'fercastro62@hotmail.com', NULL, 'passwordFer2', NULL, '8123456789', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(13, 'Isabel Morales', 'isabelmlz17@gmail.com', NULL, 'passwordIsa3', NULL, '2223334455', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(14, 'Ricardo Gómez', 'ricardogmz34@hotmail.com', NULL, 'passwordRic4', NULL, '4441112233', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(15, 'Laura Díaz', 'lauradiaz05@gmail.com', NULL, 'passwordLau5', NULL, '9934567890', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(16, 'Sergio Vázquez', 'sergiovaz71@hotmail.com', NULL, 'passwordSer6', NULL, '9389876543', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(17, 'Andrea Salazar', 'andreaslz82@gmail.com', NULL, 'passwordAnd7', NULL, '5576543210', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(18, 'Roberto Ortiz', 'roberto.ortz46@hotmail.com', NULL, 'passwordRob8', NULL, '9981020304', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(19, 'Pamela Rivas', 'pamelarv93@gmail.com', NULL, 'passwordPam9', NULL, '8156789012', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL),
(20, 'Jorge Guerrero', 'jorgegurr02@hotmail.com', NULL, 'passwordJor0', NULL, '2291029384', 'user', 1, NULL, '2025-07-25 20:39:52', '2025-07-25 20:39:52', NULL);

--
-- Volcado de datos para la tabla `personal`
--
INSERT INTO `personal` (`id`, `usuario_id`, `sucursal_asignada_id`, `tipo_personal`, `numero_empleado`, `fecha_contratacion`, `activo_en_empresa`, `created_at`, `updated_at`, `deleted_at`) VALUES
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

--
-- Volcado de datos para la tabla `categorias`
--
INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `tipo_categoria`, `icono_clave`, `activo`, `created_at`, `updated_at`) VALUES
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

--
-- Volcado de datos para la tabla `especialidades`
--
INSERT INTO `especialidades` (`id`, `nombre`, `descripcion`, `icono_clave`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Cosmiatra / Terapeuta en Estética Avanzada', 'Profesional especializado en tratamientos faciales de alta tecnología, corporales avanzados, despigmentación y eliminación de tatuajes.', 'icono_estetica_avanzada', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(2, 'Masajista / Terapeuta Corporal', 'Profesional encargado de maderoterapia y masajes relajantes.', 'icono_masajista', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(3, 'Barbero / Estilista Masculino', 'Especialista en arreglo y diseño de barba, cortes de cabello masculinos y perfilado de cejas para hombres.', 'icono_barbero', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(4, 'Estilista / Colorista', 'Profesional de cabello que realiza coloraciones, cortes generales (masculinos y femeninos), y tratamientos capilares.', 'icono_estilista', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(5, 'Técnico en Depilación Láser', 'Profesional certificado para la operación de equipos de depilación láser SHR.', 'icono_depilacion_laser', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43'),
(6, 'Diseñador de Cejas / Micropigmentador', 'Especialista en diseño y delineado de cejas y posiblemente otras técnicas de micropigmentación.', 'icono_cejas_micropigmentacion', 1, '2025-07-25 19:07:43', '2025-07-25 19:07:43');

--
-- Volcado de datos para la tabla `servicios`
--
INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `imagen_path`, `precio_base`, `duracion_minutos`, `categoria_id`, `especialidad_requerida_id`, `activo`, `created_at`, `updated_at`, `deleted_at`) VALUES
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

--
-- Volcado de datos para la tabla `agendamientos`
--
INSERT INTO `agendamientos` (`id`, `cliente_usuario_id`, `personal_id`, `servicio_id`, `sucursal_id`, `fecha_hora_inicio`, `fecha_hora_fin`, `precio_final`, `estado`, `notas_cliente`, `notas_internas`, `created_at`, `updated_at`, `deleted_at`) VALUES
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

--
-- 4. Reactivamos la revisión de claves foráneas y confirmamos la transacción.
--
SET FOREIGN_KEY_CHECKS=1;
COMMIT;
