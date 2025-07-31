-- Script para insertar datos adicionales en la base de datos BarberMusicSpa
-- Este script agrega más sucursales, servicios, productos y contenido para la aplicación

USE `barbermusicspa`;

-- Insertar más sucursales
INSERT INTO `sucursales` VALUES
(22, 'BarberMusicSpa CDMX Centro', 'Av. Juárez 123, Centro Histórico', '5555123456', 'barbermusicspa.cdmx@gmail.com', 'https://maps.app.goo.gl/example1', 19.4326, -99.1332, 1, NOW(), NOW(), NULL),
(23, 'BarberMusicSpa Guadalajara', 'Av. Vallarta 456, Centro', '3333456789', 'barbermusicspa.gdl@gmail.com', 'https://maps.app.goo.gl/example2', 20.6597, -103.3496, 1, NOW(), NOW(), NULL),
(24, 'BarberMusicSpa Monterrey', 'Av. Constitución 789, Centro', '8181987654', 'barbermusicspa.mty@gmail.com', 'https://maps.app.goo.gl/example3', 25.6866, -100.3161, 1, NOW(), NOW(), NULL),
(25, 'BarberMusicSpa Puebla', 'Av. Juárez 321, Centro', '2222345678', 'barbermusicspa.pue@gmail.com', 'https://maps.app.goo.gl/example4', 19.0413, -98.2062, 1, NOW(), NOW(), NULL);

-- Insertar más servicios
INSERT INTO `servicios` VALUES
(25, 'Tratamiento Capilar Premium', 'Tratamiento intensivo con keratina y proteínas para cabello dañado', NULL, 85.00, 90, 6, 4, 1, NOW(), NOW(), NULL),
(26, 'Corte Degradado Moderno', 'Corte de cabello con técnica degradado y diseño personalizado', NULL, 35.00, 60, 5, 3, 1, NOW(), NOW(), NULL),
(27, 'Tratamiento Facial Anti-Edad', 'Tratamiento facial con ácido hialurónico y colágeno', NULL, 120.00, 75, 3, 1, 1, NOW(), NOW(), NULL),
(28, 'Masaje Terapéutico Profundo', 'Masaje para aliviar tensiones musculares y estrés', NULL, 75.00, 90, 4, 2, 1, NOW(), NOW(), NULL),
(29, 'Depilación Láser Piernas Completas', 'Sesión de depilación láser para piernas completas', NULL, 150.00, 60, 7, 5, 1, NOW(), NOW(), NULL),
(30, 'Diseño de Barba Artístico', 'Diseño y modelado artístico de barba con técnicas avanzadas', NULL, 45.00, 45, 5, 3, 1, NOW(), NOW(), NULL),
(31, 'Tratamiento de Hidratación Facial', 'Hidratación profunda con mascarillas y sueros especializados', NULL, 65.00, 60, 3, 1, 1, NOW(), NOW(), NULL),
(32, 'Corte de Cabello Femenino', 'Corte de cabello para dama con técnicas modernas', NULL, 40.00, 60, 6, 4, 1, NOW(), NOW(), NULL);

-- Insertar más productos
INSERT INTO `productos` VALUES
(59, 'Kit Premium de Cuidado Facial', 'Kit completo con limpiador, tónico, crema hidratante y protector solar', NULL, 89.99, 150, 'PROD001FP', 13, 1, NOW(), NOW(), NULL),
(60, 'Aceite Esencial de Lavanda', 'Aceite esencial puro para relajación y cuidado de la piel', NULL, 24.99, 100, 'PROD002FP', 13, 1, NOW(), NOW(), NULL),
(61, 'Mascarilla de Arcilla Verde', 'Mascarilla purificante con arcilla verde para piel mixta y grasa', NULL, 19.99, 80, 'PROD003FP', 13, 1, NOW(), NOW(), NULL),
(62, 'Serum Vitamina C', 'Serum con vitamina C para iluminar y unificar el tono de la piel', NULL, 34.99, 120, 'PROD004FP', 13, 1, NOW(), NOW(), NULL),
(63, 'Crema Hidratante Nocturna', 'Crema hidratante especial para uso nocturno con retinol', NULL, 29.99, 90, 'PROD005FP', 13, 1, NOW(), NOW(), NULL),
(64, 'Protector Solar SPF 50', 'Protector solar facial con factor 50 y textura ligera', NULL, 22.99, 200, 'PROD006FP', 13, 1, NOW(), NOW(), NULL),
(65, 'Exfoliante Corporal de Sal Marina', 'Exfoliante corporal con sal marina y aceites esenciales', NULL, 18.99, 150, 'PROD007FP', 13, 1, NOW(), NOW(), NULL),
(66, 'Aceite Corporal Hidratante', 'Aceite corporal con almendras dulces y vitamina E', NULL, 26.99, 100, 'PROD008FP', 13, 1, NOW(), NOW(), NULL),
(67, 'Gel de Ducha Aromático', 'Gel de ducha con fragancias naturales y pH balanceado', NULL, 15.99, 180, 'PROD009FP', 13, 1, NOW(), NOW(), NULL),
(68, 'Desodorante Natural', 'Desodorante natural sin aluminio con aceites esenciales', NULL, 12.99, 120, 'PROD010FP', 13, 1, NOW(), NOW(), NULL),
(69, 'Kit de Maquillaje Básico', 'Kit completo con base, polvo, rubor, sombras y labial', NULL, 45.99, 80, 'PROD011FP', 13, 1, NOW(), NOW(), NULL),
(70, 'Paleta de Sombras Profesional', 'Paleta con 18 sombras mate y brillantes para looks profesionales', NULL, 32.99, 60, 'PROD012FP', 13, 1, NOW(), NOW(), NULL),
(71, 'Set de Brochas Profesionales', 'Set de 12 brochas profesionales para maquillaje', NULL, 28.99, 100, 'PROD013FP', 13, 1, NOW(), NOW(), NULL),
(72, 'Labial Mate de Larga Duración', 'Labial mate con fórmula de larga duración y colores vibrantes', NULL, 16.99, 150, 'PROD014FP', 13, 1, NOW(), NOW(), NULL),
(73, 'Máscara de Pestañas Volumizadora', 'Máscara de pestañas con fórmula volumizadora y alargadora', NULL, 14.99, 200, 'PROD015FP', 13, 1, NOW(), NOW(), NULL),
(74, 'Corrector de Ojeras', 'Corrector cremoso para ojeras con cobertura alta', NULL, 18.99, 120, 'PROD016FP', 13, 1, NOW(), NOW(), NULL),
(75, 'Polvo Compacto Transparente', 'Polvo compacto transparente para fijar el maquillaje', NULL, 12.99, 180, 'PROD017FP', 13, 1, NOW(), NOW(), NULL);

-- Insertar relaciones servicio-sucursal para las nuevas sucursales
INSERT INTO `servicio_sucursal` VALUES
(1, 22, 1, NOW(), NOW()),
(2, 22, 1, NOW(), NOW()),
(3, 22, 1, NOW(), NOW()),
(4, 22, 1, NOW(), NOW()),
(5, 22, 1, NOW(), NOW()),
(6, 22, 1, NOW(), NOW()),
(7, 22, 1, NOW(), NOW()),
(8, 22, 1, NOW(), NOW()),
(9, 22, 1, NOW(), NOW()),
(10, 22, 1, NOW(), NOW()),
(11, 22, 1, NOW(), NOW()),
(12, 22, 1, NOW(), NOW()),
(13, 22, 1, NOW(), NOW()),
(14, 22, 1, NOW(), NOW()),
(15, 22, 1, NOW(), NOW()),
(16, 22, 1, NOW(), NOW()),
(17, 22, 1, NOW(), NOW()),
(18, 22, 1, NOW(), NOW()),
(19, 22, 1, NOW(), NOW()),
(20, 22, 1, NOW(), NOW()),
(21, 22, 1, NOW(), NOW()),
(22, 22, 1, NOW(), NOW()),
(23, 22, 1, NOW(), NOW()),
(24, 22, 1, NOW(), NOW()),
(25, 22, 1, NOW(), NOW()),
(26, 22, 1, NOW(), NOW()),
(27, 22, 1, NOW(), NOW()),
(28, 22, 1, NOW(), NOW()),
(29, 22, 1, NOW(), NOW()),
(30, 22, 1, NOW(), NOW()),
(31, 22, 1, NOW(), NOW()),
(32, 22, 1, NOW(), NOW());

-- Insertar horarios para las nuevas sucursales
INSERT INTO `horarios_sucursal` VALUES
(1, 22, 1, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 22, 2, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 22, 3, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 22, 4, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 22, 5, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 22, 6, '09:00:00', '18:00:00', 1, NOW(), NOW()),
(1, 22, 7, '10:00:00', '16:00:00', 1, NOW(), NOW()),
(1, 23, 1, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 23, 2, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 23, 3, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 23, 4, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 23, 5, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 23, 6, '09:00:00', '18:00:00', 1, NOW(), NOW()),
(1, 23, 7, '10:00:00', '16:00:00', 1, NOW(), NOW()),
(1, 24, 1, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 24, 2, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 24, 3, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 24, 4, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 24, 5, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 24, 6, '09:00:00', '18:00:00', 1, NOW(), NOW()),
(1, 24, 7, '10:00:00', '16:00:00', 1, NOW(), NOW()),
(1, 25, 1, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 25, 2, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 25, 3, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 25, 4, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 25, 5, '09:00:00', '20:00:00', 1, NOW(), NOW()),
(1, 25, 6, '09:00:00', '18:00:00', 1, NOW(), NOW()),
(1, 25, 7, '10:00:00', '16:00:00', 1, NOW(), NOW());

-- Insertar más reseñas para productos y servicios
INSERT INTO `reseñas` VALUES
(101, 1, 1, 5, 'Excelente servicio, muy profesional y puntual', 'El personal fue muy amable y el resultado superó mis expectativas', NOW(), NOW()),
(102, 2, 1, 4, 'Muy buen servicio, lo recomiendo', 'El corte quedó perfecto y el ambiente es muy agradable', NOW(), NOW()),
(103, 3, 1, 5, 'Servicio de primera calidad', 'Excelente atención y resultados profesionales', NOW(), NOW()),
(104, 4, 1, 4, 'Muy satisfecho con el servicio', 'El personal es muy profesional y el lugar está muy limpio', NOW(), NOW()),
(105, 5, 1, 5, 'Recomendado 100%', 'El mejor lugar para cortarse el cabello', NOW(), NOW()),
(106, 6, 1, 4, 'Buen servicio y precio justo', 'Muy contento con el resultado', NOW(), NOW()),
(107, 7, 1, 5, 'Excelente atención al cliente', 'El personal es muy amable y profesional', NOW(), NOW()),
(108, 8, 1, 4, 'Muy buen servicio', 'Recomendado para toda la familia', NOW(), NOW()),
(109, 9, 1, 5, 'El mejor lugar de la ciudad', 'Servicio de primera calidad', NOW(), NOW()),
(110, 10, 1, 4, 'Muy satisfecho', 'Excelente atención y resultados', NOW(), NOW());

-- Insertar más promociones
INSERT INTO `promociones` VALUES
(9, 'Descuento 20% en Servicios de Barba', 'Obtén 20% de descuento en todos los servicios de barba', 20.00, '2025-01-01', '2025-12-31', 1, NOW(), NOW()),
(10, '2x1 en Tratamientos Faciales', 'Lleva 2 tratamientos faciales por el precio de 1', 50.00, '2025-01-01', '2025-12-31', 1, NOW(), NOW()),
(11, 'Descuento 15% en Productos de Cuidado', '15% de descuento en toda la línea de productos de cuidado', 15.00, '2025-01-01', '2025-12-31', 1, NOW(), NOW()),
(12, 'Paquete Completo de Belleza', 'Incluye corte, color y tratamiento por precio especial', 25.00, '2025-01-01', '2025-12-31', 1, NOW(), NOW());

-- Insertar relaciones promoción-servicio
INSERT INTO `promocion_servicio` VALUES
(9, 16, NOW(), NOW()),
(9, 30, NOW(), NOW()),
(10, 7, NOW(), NOW()),
(10, 8, NOW(), NOW()),
(10, 9, NOW(), NOW()),
(10, 11, NOW(), NOW()),
(10, 12, NOW(), NOW()),
(10, 13, NOW(), NOW()),
(10, 27, NOW(), NOW()),
(10, 31, NOW(), NOW()),
(12, 16, NOW(), NOW()),
(12, 17, NOW(), NOW()),
(12, 18, NOW(), NOW()),
(12, 19, NOW(), NOW()),
(12, 20, NOW(), NOW()),
(12, 25, NOW(), NOW()),
(12, 26, NOW(), NOW()),
(12, 32, NOW(), NOW());

-- Insertar relaciones promoción-producto
INSERT INTO `producto_promocion` VALUES
(11, 59, NOW(), NOW()),
(11, 60, NOW(), NOW()),
(11, 61, NOW(), NOW()),
(11, 62, NOW(), NOW()),
(11, 63, NOW(), NOW()),
(11, 64, NOW(), NOW()),
(11, 65, NOW(), NOW()),
(11, 66, NOW(), NOW()),
(11, 67, NOW(), NOW()),
(11, 68, NOW(), NOW()),
(11, 69, NOW(), NOW()),
(11, 70, NOW(), NOW()),
(11, 71, NOW(), NOW()),
(11, 72, NOW(), NOW()),
(11, 73, NOW(), NOW()),
(11, 74, NOW(), NOW()),
(11, 75, NOW(), NOW());

-- Actualizar algunos productos y servicios como destacados
UPDATE `productos` SET `destacado` = 1 WHERE `id` IN (1, 3, 6, 26, 59, 62, 69);
UPDATE `servicios` SET `destacado` = 1 WHERE `id` IN (1, 7, 16, 17, 25, 27, 30);

-- Insertar más personal para las nuevas sucursales
INSERT INTO `personal` VALUES
(11, 'María González', 'maria.gonzalez@barbermusicspa.com', '5551234567', 'Estilista Senior', 'Especialista en cortes modernos y coloración', 22, 1, NOW(), NOW()),
(12, 'Carlos Ruiz', 'carlos.ruiz@barbermusicspa.com', '5551234568', 'Barbero Profesional', 'Especialista en barbas y cortes clásicos', 22, 1, NOW(), NOW()),
(13, 'Ana Martínez', 'ana.martinez@barbermusicspa.com', '5551234569', 'Esteticista', 'Especialista en tratamientos faciales', 22, 1, NOW(), NOW()),
(14, 'Luis Pérez', 'luis.perez@barbermusicspa.com', '5551234570', 'Masajista', 'Especialista en masajes terapéuticos', 22, 1, NOW(), NOW()),
(15, 'Sofía López', 'sofia.lopez@barbermusicspa.com', '5551234571', 'Estilista', 'Especialista en cabello femenino', 23, 1, NOW(), NOW()),
(16, 'Roberto Silva', 'roberto.silva@barbermusicspa.com', '5551234572', 'Barbero', 'Especialista en cortes masculinos', 23, 1, NOW(), NOW()),
(17, 'Carmen Vega', 'carmen.vega@barbermusicspa.com', '5551234573', 'Esteticista Senior', 'Especialista en tratamientos anti-edad', 23, 1, NOW(), NOW()),
(18, 'Miguel Torres', 'miguel.torres@barbermusicspa.com', '5551234574', 'Masajista', 'Especialista en masajes relajantes', 23, 1, NOW(), NOW());

-- Insertar relaciones servicio-personal para el nuevo personal
INSERT INTO `servicio_personal` VALUES
(16, 11, NOW(), NOW()),
(17, 11, NOW(), NOW()),
(18, 11, NOW(), NOW()),
(19, 11, NOW(), NOW()),
(20, 11, NOW(), NOW()),
(25, 11, NOW(), NOW()),
(26, 11, NOW(), NOW()),
(32, 11, NOW(), NOW()),
(16, 12, NOW(), NOW()),
(17, 12, NOW(), NOW()),
(18, 12, NOW(), NOW()),
(19, 12, NOW(), NOW()),
(20, 12, NOW(), NOW()),
(25, 12, NOW(), NOW()),
(26, 12, NOW(), NOW()),
(30, 12, NOW(), NOW()),
(7, 13, NOW(), NOW()),
(8, 13, NOW(), NOW()),
(9, 13, NOW(), NOW()),
(11, 13, NOW(), NOW()),
(12, 13, NOW(), NOW()),
(13, 13, NOW(), NOW()),
(27, 13, NOW(), NOW()),
(31, 13, NOW(), NOW()),
(14, 14, NOW(), NOW()),
(15, 14, NOW(), NOW()),
(28, 14, NOW(), NOW()),
(16, 15, NOW(), NOW()),
(17, 15, NOW(), NOW()),
(18, 15, NOW(), NOW()),
(19, 15, NOW(), NOW()),
(20, 15, NOW(), NOW()),
(25, 15, NOW(), NOW()),
(26, 15, NOW(), NOW()),
(32, 15, NOW(), NOW()),
(16, 16, NOW(), NOW()),
(17, 16, NOW(), NOW()),
(18, 16, NOW(), NOW()),
(19, 16, NOW(), NOW()),
(20, 16, NOW(), NOW()),
(25, 16, NOW(), NOW()),
(26, 16, NOW(), NOW()),
(30, 16, NOW(), NOW()),
(7, 17, NOW(), NOW()),
(8, 17, NOW(), NOW()),
(9, 17, NOW(), NOW()),
(11, 17, NOW(), NOW()),
(12, 17, NOW(), NOW()),
(13, 17, NOW(), NOW()),
(27, 17, NOW(), NOW()),
(31, 17, NOW(), NOW()),
(14, 18, NOW(), NOW()),
(15, 18, NOW(), NOW()),
(28, 18, NOW(), NOW());

COMMIT; 