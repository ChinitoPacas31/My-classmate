-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-11-2024 a las 02:40:17
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `myclassmate`
--
CREATE DATABASE IF NOT EXISTS `myclassmate` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `myclassmate`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `college`
--

CREATE TABLE `college` (
  `idCollege` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `emailExtension` varchar(50) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `college`
--

INSERT INTO `college` (`idCollege`, `name`, `emailExtension`, `createdAt`, `active`) VALUES
(1, 'Universidad Tecnológica de Chihuahua', '@utch.edu.mx', '2024-11-05 18:59:57', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `degree`
--

CREATE TABLE `degree` (
  `idDegree` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `degree`
--

INSERT INTO `degree` (`idDegree`, `name`, `active`) VALUES
(1, 'Tecnologías de la información', 1),
(2, 'Energía y Desarrollo Sostenible', 1),
(3, 'Ingeniería Industrial', 1),
(4, 'Negocios y mercadotecnia', 1),
(5, 'Mantenimiento Industrial', 1),
(6, 'Mecatrónica', 1),
(7, 'Lengua Inglesa', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `degree_subdegree`
--

CREATE TABLE `degree_subdegree` (
  `idDegree_subdegree` int(11) NOT NULL,
  `degree_idDegree` int(11) NOT NULL,
  `subdegree_idSubdegree` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `degree_subdegree`
--

INSERT INTO `degree_subdegree` (`idDegree_subdegree`, `degree_idDegree`, `subdegree_idSubdegree`) VALUES
(1, 2, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 4),
(5, 3, 5),
(6, 4, 6),
(7, 5, 7),
(8, 6, 8),
(9, 7, 9),
(10, 1, 10),
(11, 1, 11),
(12, 1, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paymethod`
--

CREATE TABLE `paymethod` (
  `idPayMethod` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `petition`
--

CREATE TABLE `petition` (
  `idPetiton` int(11) NOT NULL,
  `tutor_user_idUser` int(11) DEFAULT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `subject_idSubject` int(11) NOT NULL,
  `description` varchar(100) NOT NULL,
  `petitionDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `supply` decimal(10,2) DEFAULT NULL,
  `status_idStatus` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `review`
--

CREATE TABLE `review` (
  `idReview` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL CHECK (`rating` between 1 and 5),
  `description` text DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `review`
--

INSERT INTO `review` (`idReview`, `tutor_user_idUser`, `student_user_idUser`, `rating`, `description`, `createdAt`) VALUES
(56, 7, 16, 5, 'Muy profesional el tutor. Súper atento. Se nota que sabe del tema.', '2024-11-25 14:44:43'),
(57, 7, 12, 4, NULL, '2024-11-25 14:44:43'),
(58, 8, 13, 3, 'Es bueno como tutor, pero llegó tarde a la asesoría.', '2024-11-25 14:44:43'),
(59, 11, 13, 5, NULL, '2024-11-25 14:44:43'),
(60, 10, 15, 3, 'Se confundía facilmente con sus propias explicaciones.', '2024-11-25 14:44:43'),
(61, 9, 15, 2, 'Se nota que no preparó el material para la asesoría.', '2024-11-25 14:44:43'),
(62, 9, 16, 5, NULL, '2024-11-25 14:44:43'),
(63, 8, 14, 4, 'Muy bueno. La recomiendo completamente.', '2024-11-25 14:44:43'),
(64, 11, 12, 4, NULL, '2024-11-25 14:44:43'),
(65, 7, 16, 1, 'No se presentó y ni siquiera avisó. Por ninguna circunstancia lo recomendaría', '2024-11-25 14:44:43'),
(66, 10, 9, 4, 'ok', '2024-11-25 14:55:28'),
(67, 8, 9, 3, 'ok', '2024-11-25 14:56:07'),
(68, 7, 10, 3, 'si', '2024-11-25 14:56:40'),
(69, 7, 11, 4, 'bien', '2024-11-25 14:57:09'),
(70, 8, 16, 5, 'Ok\r\n', '2024-11-26 19:17:18'),
(71, 20, 20, 3, 'OK', '2024-11-26 20:14:17'),
(72, 20, 20, 4, 'Ok', '2024-11-27 08:14:29');

--
-- Disparadores `review`
--
DELIMITER $$
CREATE TRIGGER `trg_meanRatingInsert` AFTER INSERT ON `review` FOR EACH ROW UPDATE tutor SET meanRating = (SELECT AVG(rating) FROM review WHERE tutor_user_idUser = NEW.tutor_user_idUser) WHERE NEW.tutor_user_idUser = tutor.user_idUser
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_meanRatingUpdate` AFTER INSERT ON `review` FOR EACH ROW UPDATE tutor SET meanRating = (SELECT AVG(rating) FROM review WHERE tutor_user_idUser = NEW.tutor_user_idUser) WHERE NEW.tutor_user_idUser = tutor.user_idUser
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sale`
--

CREATE TABLE `sale` (
  `idSale` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `subject_idSubject` int(11) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `payMethod_idPayMethod` int(11) NOT NULL,
  `schedule_idSchedule` int(11) NOT NULL,
  `quantity` decimal(10,1) NOT NULL,
  `total` decimal(10,1) NOT NULL,
  `status_idStatus` int(11) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `savedtutor`
--

CREATE TABLE `savedtutor` (
  `idSaveTutor` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `schedule`
--

CREATE TABLE `schedule` (
  `idSchedule` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `scheduledDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `slootTime_idSlootTime` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `schedule`
--

INSERT INTO `schedule` (`idSchedule`, `tutor_user_idUser`, `student_user_idUser`, `scheduledDate`, `slootTime_idSlootTime`) VALUES
(3, 11, 9, '2024-11-29 06:00:00', 6),
(4, 19, 12, '2024-11-29 06:00:00', 9),
(10, 17, 16, '2024-11-29 06:00:00', 10),
(11, 10, 16, '2024-11-12 06:00:00', 9),
(12, 8, 7, '2024-11-20 06:00:00', 7),
(13, 8, 23, '2024-11-27 06:00:00', 3),
(14, 10, 23, '2024-11-22 06:00:00', 5),
(15, 17, 23, '2024-11-21 06:00:00', 4),
(16, 20, 23, '2024-12-04 06:00:00', 5),
(17, 20, 20, '2024-11-15 06:00:00', 5),
(18, 20, 20, '2024-11-07 06:00:00', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `slottime`
--

CREATE TABLE `slottime` (
  `idSlotTime` int(11) NOT NULL,
  `startTime` time NOT NULL,
  `endTime` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `slottime`
--

INSERT INTO `slottime` (`idSlotTime`, `startTime`, `endTime`) VALUES
(1, '06:00:00', '07:00:00'),
(2, '06:30:00', '07:30:00'),
(3, '07:00:00', '08:00:00'),
(4, '07:30:00', '08:30:00'),
(5, '08:00:00', '09:00:00'),
(6, '08:30:00', '09:30:00'),
(7, '09:00:00', '10:00:00'),
(8, '09:30:00', '10:30:00'),
(9, '10:00:00', '11:00:00'),
(10, '10:30:00', '11:30:00'),
(11, '11:00:00', '12:00:00'),
(12, '11:30:00', '12:30:00'),
(13, '12:00:00', '13:00:00'),
(14, '12:30:00', '13:30:00'),
(15, '13:00:00', '14:00:00'),
(16, '13:30:00', '14:30:00'),
(17, '14:00:00', '15:00:00'),
(18, '14:30:00', '15:30:00'),
(19, '15:00:00', '16:00:00'),
(20, '15:30:00', '16:30:00'),
(21, '16:00:00', '17:00:00'),
(22, '16:30:00', '17:30:00'),
(23, '17:00:00', '18:00:00'),
(24, '17:30:00', '18:30:00'),
(25, '18:00:00', '19:00:00'),
(26, '18:30:00', '19:30:00'),
(27, '19:00:00', '20:00:00'),
(28, '19:30:00', '20:30:00'),
(29, '20:00:00', '21:00:00'),
(30, '20:30:00', '21:30:00'),
(31, '21:00:00', '22:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `status`
--

CREATE TABLE `status` (
  `idStatus` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `student`
--

CREATE TABLE `student` (
  `user_idUser` int(11) NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT 0 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `student`
--

INSERT INTO `student` (`user_idUser`, `online`, `createdAt`, `active`) VALUES
(7, 0, '2024-11-14 19:59:59', 1),
(8, 0, '2024-11-14 19:59:59', 1),
(9, 0, '2024-11-14 19:59:59', 1),
(10, 0, '2024-11-14 19:59:59', 1),
(11, 0, '2024-11-14 19:59:59', 1),
(12, 0, '2024-11-14 19:59:59', 1),
(13, 0, '2024-11-14 19:59:59', 1),
(14, 0, '2024-11-14 19:59:59', 1),
(15, 0, '2024-11-14 19:59:59', 1),
(16, 0, '2024-11-14 19:59:59', 1),
(17, 0, '2024-11-26 00:06:42', 1),
(18, 0, '2024-11-26 00:07:33', 1),
(19, 0, '2024-11-26 00:11:13', 1),
(20, 0, '2024-11-26 00:31:32', 1),
(21, 0, '2024-11-26 00:32:26', 1),
(22, 0, '2024-11-26 02:45:35', 1),
(23, 0, '2024-11-27 01:56:06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `studentnotification`
--

CREATE TABLE `studentnotification` (
  `idTutorNotification` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 1 CHECK (`seen` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subdegree`
--

CREATE TABLE `subdegree` (
  `idSubdegree` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subdegree`
--

INSERT INTO `subdegree` (`idSubdegree`, `name`, `active`) VALUES
(1, 'Energía y Desarrollo Sostenible', 1),
(2, 'Cerámicos', 1),
(3, 'Moldeo de Plásticos', 1),
(4, 'Procesos Productivos', 1),
(5, 'Maquinados de Precisión', 1),
(6, 'Mercadotecnia', 1),
(7, 'Mantenimiento Industrial', 1),
(8, 'Mecatrónica', 1),
(9, 'Maestro de inglés', 1),
(10, 'Desarrollo de Software Multiplataforma', 1),
(11, 'Entornos Virtuales y Negocios Digitales', 1),
(12, 'Infraestructura de Redes Digitales', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subject`
--

CREATE TABLE `subject` (
  `idSubject` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1)),
  `subjectCategory_idSubjectCategory` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subject`
--

INSERT INTO `subject` (`idSubject`, `name`, `active`, `subjectCategory_idSubjectCategory`) VALUES
(1, 'Probabilidad y estadística', 1, 1),
(2, 'Química básica', 1, 2),
(3, 'Electricidad y magnetismo', 1, 2),
(4, 'Desarrollo sustentable', 1, 10),
(5, 'Informática', 1, 5),
(6, 'Circuitos eléctricos', 1, 6),
(7, 'Inglés I', 1, 11),
(8, 'Expresión oral y escrita I', 1, 3),
(9, 'Formación sociocultural I', 1, 3),
(10, 'Álgebra lineal', 1, 1),
(11, 'Física', 1, 2),
(12, 'Termodinámica', 1, 2),
(13, 'Instalaciones eléctricas', 1, 6),
(14, 'Electrónica industrial', 1, 6),
(15, 'Mecánica industrial', 1, 7),
(16, 'Inglés II', 1, 11),
(17, 'Formación sociocultural II', 1, 3),
(18, 'Funciones matemáticas', 1, 1),
(19, 'Fisicoquímica', 1, 2),
(20, 'Instrumentación industrial', 1, 6),
(21, 'Mantenimiento electromecánico', 1, 7),
(22, 'Energías renovables', 1, 6),
(23, 'Formulación de proyectos', 1, 0),
(24, 'Calidad', 1, 0),
(25, 'Cálculo diferencial', 1, 1),
(26, 'Estructura y propiedades de los materiales', 1, 0),
(27, 'Fisicoquímica aplicada', 1, 2),
(28, 'Dibujo industrial', 1, 0),
(29, 'Electrónica de potencia', 1, 0),
(30, 'Estaciones meteorológicas', 1, 0),
(31, 'Procesos industriales', 1, 7),
(32, 'Inglés IV', 1, 11),
(33, 'Formación sociocultural III', 1, 3),
(34, 'Cálculo integral', 1, 1),
(35, 'Seguridad industrial', 1, 0),
(36, 'Celdas fotovoltaicas', 1, 0),
(37, 'Colectores solares', 1, 0),
(38, 'Administración de proyectos', 1, 4),
(39, 'Adquisición de datos', 1, 0),
(40, 'Inglés V', 1, 11),
(41, 'Expresión oral y escrita II', 1, 0),
(42, 'Organización industrial', 1, 0),
(43, 'Metrología I', 1, 6),
(44, 'Herramientas informáticas I', 1, 5),
(45, 'Administración de la producción I', 1, 4),
(46, 'Métodos y sistemas de trabajo I', 1, 0),
(47, 'Tópicos de manufactura', 1, 0),
(48, 'Costos de producción', 1, 4),
(49, 'Control estadístico del proceso', 1, 6),
(50, 'Procesos de manufactura I', 1, 7),
(51, 'Distribución de planta', 1, 7),
(52, 'Resistencia de los materiales', 1, 6),
(53, 'Química II', 1, 2),
(54, 'Gestión ambiental', 1, 10),
(55, 'Fundamentos de automatización', 1, 6),
(56, 'Proceso de maquinado de precisión no convencional', 1, 0),
(57, 'Tolerancias geométricas y dimensionales', 1, 0),
(58, 'Métodos y sistemas de trabajo II', 1, 0),
(59, 'Seguridad e higiene industrial', 1, 0),
(60, 'Procesos de fabricación de materiales cerámicos I', 1, 7),
(61, 'Manejo de materiales', 1, 0),
(62, 'Reología', 1, 0),
(63, 'Almacenes y control de inventarios', 1, 0),
(64, 'Análisis de las condiciones de trabajo', 1, 0),
(65, 'Transformación de productos plásticos I', 1, 0),
(66, 'Procesos de manufactura de moldes, cabezales y dad', 1, 7),
(67, 'Mantenimiento autónomo en proceso', 1, 7),
(68, 'Diseño de producto', 1, 8),
(69, 'Metrología II', 1, 6),
(70, 'Estructura y propiedad de los polímeros y los acer', 1, 0),
(71, 'Proceso de maquinado de precisión convencional', 1, 0),
(72, 'Dibujo asistido por la computadora', 1, 8),
(73, 'Administración de la calidad', 1, 4),
(74, 'Fundamentos de legislación industrial', 1, 0),
(75, 'Fundamentos de ingeniería económica', 1, 0),
(76, 'Procesos de manufactura II', 1, 7),
(77, 'Cadena de suministros', 1, 4),
(78, 'Manufactura aplicada', 1, 0),
(79, 'Procesos químicos', 1, 7),
(80, 'Proceso de maquinado de precisión CNC', 1, 0),
(81, 'Manufactura asistida por computadora', 1, 0),
(82, 'Prueba de los materiales', 1, 2),
(83, 'Moldes cerámicos', 1, 0),
(84, 'Procesos de fabricación de materiales cerámicos II', 1, 7),
(85, 'Propiedades y pruebas de materias primas', 1, 2),
(86, 'Herramientas informáticas II', 1, 5),
(87, 'Automatización', 1, 6),
(88, 'Transformación de productos plásticos II', 1, 0),
(89, 'Moldes', 1, 7),
(90, 'Reciclado de polímeros', 1, 0),
(91, 'Principios de automatización', 1, 6),
(92, 'Desarrollo humano y valores', 1, 3),
(93, 'Mercadotecnia', 1, 4),
(94, 'Matemáticas', 1, 1),
(95, 'Fundamentos de administración y entorno empresaria', 1, 0),
(96, 'Comunicación y habilidades digitales', 1, 3),
(97, 'Habilidades socioemocionales y manejo de conflicto', 1, 3),
(98, 'Estadística I', 1, 0),
(99, 'Planeación estratégica', 1, 4),
(100, 'Contabilidad para negocios', 1, 4),
(101, 'Comportamiento del consumidor', 1, 0),
(102, 'Economía', 1, 0),
(103, 'Desarrollo del pensamiento y toma de decisiones', 1, 0),
(104, 'Legislación comercial', 1, 0),
(105, 'Estadística II', 1, 0),
(106, 'Sistema de investigación de mercados I', 1, 0),
(107, 'Estrategias de producto y precio', 1, 4),
(108, 'Ética profesional', 1, 3),
(109, 'Mezcla promocional', 1, 0),
(110, 'Diseño digital y multimedia', 1, 8),
(111, 'Sistema de investigación de mercados II', 1, 0),
(112, 'Gestión de ventas', 1, 4),
(113, 'Administración del tiempo', 1, 4),
(114, 'Liderazgo de equipos de alto desempeño', 1, 3),
(115, 'Logística y distribución', 1, 4),
(116, 'Mercadotecnia de servicios', 1, 4),
(117, 'Mercadotecnia digital I', 1, 4),
(118, 'Mercadotecnia estratégica', 1, 4),
(119, 'Introducción al mantenimiento', 1, 0),
(120, 'Seguridad y medio ambiente', 1, 10),
(121, 'Administración del personal', 1, 4),
(122, 'Gestión del mantenimiento', 1, 0),
(123, 'Calidad en el mantenimiento', 1, 0),
(124, 'Costos y presupuestos', 1, 4),
(125, 'Sistemas eléctricos', 1, 6),
(126, 'Máquinas y mecanismos', 1, 6),
(127, 'Electrónica analógica', 1, 0),
(128, 'Máquinas eléctricas', 1, 6),
(129, 'Redes de servicios industriales', 1, 5),
(130, 'Electrónica digital', 1, 0),
(131, 'Principios de programación', 1, 0),
(132, 'Sistemas neumáticos e hidráulicos', 1, 6),
(133, 'Máquinas térmicas', 1, 6),
(134, 'Mantenimiento a procesos de manufactura', 1, 0),
(135, 'Automatización y robótica', 1, 6),
(136, 'Ingeniería de materiales', 1, 6),
(137, 'Fundamentos matemáticos', 1, 1),
(138, 'Metodología para la programación', 1, 0),
(139, 'Metrología', 1, 6),
(140, 'Cálculo de varias variables', 1, 1),
(141, 'Control de motores eléctricos', 1, 7),
(142, 'Ecuaciones diferenciales', 1, 1),
(143, 'Controladores lógicos programables', 1, 6),
(144, 'Implementación de sistemas automáticos', 1, 0),
(145, 'Desarrollo de habilidades de pensamiento lógico', 1, 9),
(146, 'Fundamentos de TI', 1, 5),
(147, 'Fundamentos de redes', 1, 0),
(148, 'Metodologías de desarrollo de software', 1, 5),
(149, 'Interconexión de redes', 1, 5),
(150, 'Programación orientada a objetos', 1, 0),
(151, 'Introducción al diseño digital', 1, 0),
(152, 'Base de datos', 1, 5),
(153, 'Sistemas operativos', 1, 0),
(154, 'Aplicaciones WEB', 1, 5),
(155, 'Bases de datos para aplicaciones', 1, 5),
(156, 'Mercadotecnia digital', 1, 4),
(157, 'Diseño digital', 1, 8),
(158, 'Conmutación en redes de datos', 1, 5),
(159, 'Infraestructura de redes de datos', 1, 5),
(160, 'Estándares y métricas para el desarrollo de softwa', 1, 0),
(161, 'Principios para IoT', 1, 0),
(162, 'Diseño de APPS', 1, 5),
(163, 'Estructura de datos aplicadas', 1, 0),
(164, 'Aplicaciones WEB orientadas a servicios', 1, 5),
(165, 'Evaluación y mejora para el desarrollo de software', 1, 0),
(166, 'Electrónica para IDC', 1, 0),
(167, 'Conexión de redes WAN', 1, 5),
(168, 'Administración de servidores I', 1, 4),
(169, 'Programación de redes', 1, 5),
(170, 'Aplicaciones de IoT', 1, 0),
(171, 'Desarrollo móvil multiplataforma', 1, 0),
(172, 'Aplicaciones WEB para I4.0', 1, 5),
(173, 'Bases de datos para cómputo en la nube', 1, 5),
(174, 'Producción audiovisual', 1, 8),
(175, 'Animación 3D', 1, 8),
(176, 'Desarrollo de aplicaciones de realidad virtual', 1, 8),
(177, 'Desarrollo de aplicaciones para negocios digitales', 1, 0),
(178, 'Introducción a BIG DATA', 1, 5),
(179, 'Administración de redes de datos', 1, 4),
(180, 'Administración de servidores II', 1, 4),
(181, 'Ciberseguridad', 1, 5),
(182, 'Fundamentos pedagógicos de la educación', 1, 0),
(183, 'Estadística aplicada a la educación', 1, 0),
(184, 'Metodología de la investigación', 1, 9),
(185, 'Diseño de material didáctico', 1, 0),
(186, 'Metodología de la didáctica', 1, 9),
(187, 'La educación en México', 1, 3),
(188, 'Planeación docente', 1, 0),
(189, 'Evaluación del proceso enseñanza y aprendizaje', 1, 9),
(190, 'Estrategias enseñanza de la lengua inglesa I', 1, 9),
(191, 'Diseño de situaciones de aprendizaje', 1, 0),
(192, 'Instrumentos de evaluación', 1, 9),
(193, 'Fonética', 1, 9),
(194, 'Estrategias de enseñanza de la lengua inglesa II', 1, 9),
(195, 'Estructura gramatical', 1, 9),
(196, 'Enseñanza de habilidades productivas', 1, 9),
(197, 'Enseñanzas de habilidades receptivas', 1, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subjectcategory`
--

CREATE TABLE `subjectcategory` (
  `idSubjectCategory` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `subjectcategory`
--

INSERT INTO `subjectcategory` (`idSubjectCategory`, `name`) VALUES
(4, 'Administración y Negocios'),
(2, 'Ciencias Naturales y Exactas'),
(3, 'Ciencias Sociales y Humanidades'),
(8, 'Diseño y Creatividad'),
(9, 'Educación y Pedagogía'),
(11, 'Idiomas'),
(5, 'Informática y Computación'),
(6, 'Ingeniería y Tecnología'),
(1, 'Matemáticas Básicas y Aplicadas'),
(0, 'Otras Asignaturas'),
(7, 'Producción y Manufactura'),
(10, 'Sostenibilidad y Desarrollo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutor`
--

CREATE TABLE `tutor` (
  `user_idUser` int(11) NOT NULL,
  `asesoryCost` decimal(10,2) NOT NULL,
  `meanRating` decimal(3,2) NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT 0 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tutor`
--

INSERT INTO `tutor` (`user_idUser`, `asesoryCost`, `meanRating`, `online`, `createdAt`, `active`) VALUES
(7, 70.00, 3.40, 0, '2024-11-20 23:12:01', 1),
(8, 50.00, 3.75, 0, '2024-11-20 23:12:01', 1),
(9, 60.00, 3.50, 0, '2024-11-20 23:12:01', 1),
(10, 50.00, 3.50, 0, '2024-11-20 23:12:01', 1),
(11, 100.00, 4.50, 0, '2024-11-20 23:12:01', 1),
(17, 50.00, 0.00, 0, '2024-11-26 00:06:42', 1),
(18, 30.00, 0.00, 0, '2024-11-26 00:07:33', 1),
(19, 40.00, 0.00, 0, '2024-11-26 00:11:13', 1),
(20, 40.00, 3.50, 0, '2024-11-26 00:31:32', 1),
(21, 60.00, 0.00, 0, '2024-11-26 00:32:26', 1),
(23, 52.00, 0.00, 0, '2024-11-27 01:56:06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutorsnotification`
--

CREATE TABLE `tutorsnotification` (
  `idTutorNotification` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `description` text NOT NULL,
  `seen` tinyint(1) DEFAULT 0,
  `createdAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tutorsnotification`
--

INSERT INTO `tutorsnotification` (`idTutorNotification`, `tutor_user_idUser`, `student_user_idUser`, `description`, `seen`, `createdAt`) VALUES
(1, 11, 0, 'El estudiante José Luis ha agendado una cita para 2024-11-29.', 0, '2024-11-26 16:41:46'),
(2, 19, 0, 'El estudiante Laura Beatriz ha agendado una cita para 2024-11-29.', 0, '2024-11-26 17:26:28'),
(5, 17, 16, 'El estudiante Gabriela Alejandra ha agendado una cita para 2024-11-29 00:00:00.', 0, '2024-11-26 18:46:41'),
(6, 10, 16, 'El estudiante Gabriela Alejandra ha agendado una cita para 2024-11-12 00:00:00.', 0, '2024-11-26 19:17:40'),
(7, 8, 7, 'El estudiante Juan Carlos ha agendado una cita para 2024-11-20 00:00:00.', 0, '2024-11-26 19:36:29'),
(8, 8, 23, 'El estudiante Homero  ha agendado una cita para 2024-11-27 00:00:00.', 0, '2024-11-26 19:58:54'),
(9, 10, 23, 'El estudiante Homero  ha agendado una cita para 2024-11-22 00:00:00.', 0, '2024-11-26 20:02:29'),
(10, 17, 23, 'El estudiante Homero  ha agendado una cita para 2024-11-21 00:00:00.', 0, '2024-11-26 20:06:29'),
(13, 20, 20, 'El estudiante Emiliano  ha agendado una cita para 2024-11-07 00:00:00.', 0, '2024-11-27 08:20:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutor_subject`
--

CREATE TABLE `tutor_subject` (
  `idTutor_subject` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `subject_idSubject` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `idUser` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `college_idCollege` int(11) NOT NULL,
  `idDegree_subdegree` int(11) NOT NULL,
  `term` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(300) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`idUser`, `name`, `lastName`, `college_idCollege`, `idDegree_subdegree`, `term`, `email`, `password`, `profile_picture`) VALUES
(7, 'Juan Carlos', 'Pérez Martínez', 1, 2, 3, 'a1234567890@utch.edu.mx', '5c587d49767fdced067af147fbd9329c:8625B5EC17B9EE8135EBF03F270757A3E06ECA343133D4362F6E37CCB9439D1F', NULL),
(8, 'María Fernanda', 'Gómez Rodríguez', 1, 10, 5, 'a2345678901@utch.edu.mx', '579aece507f498769d30a41cf1353eb6:D762809E3134A64986BC40D79E57710EF90CF95AB919D364907A9CB7E4BBBDAC', NULL),
(9, 'José Luis', 'Hernández Rivera', 1, 8, 2, 'a3456789012@utch.edu.mx', '8d23568009ceac66ed7a0100a5977626:46ED6B2533D4A5D9828DD2A403991D02B541F5749B79F4472BD51DA41D6F8BBB', NULL),
(10, 'Ana Isabel', 'Sánchez Morales', 1, 1, 8, 'a4567890123@utch.edu.mx', '4beabfab649cf34395c34687a1f4272b:41363AD9D8FFBF4B73A2F0F47E15AE3917C55EB2DCA70CB6AA866B51A4EDB244', NULL),
(11, 'Pedro Antonio', 'López García', 1, 3, 6, 'a5678901234@utch.edu.mx', '1c5c686abde1871555889e9c007770f9:AE3E55AD817C354B78D83C8CEF5DE566D38CBB0BB0A6A6D98711B5DF2D321176', NULL),
(12, 'Laura Beatriz', 'Ramírez Torres', 1, 11, 7, 'a6789012345@utch.edu.mx', '949bff47fc53d70d8e031b46d4fc04e3:F69B208926BB12F09DA8EB41A728773B0241AADE9FF06C6E78BA42FC05B8F2F3', NULL),
(13, 'Carlos Eduardo', 'Jiménez Vargas', 1, 5, 4, 'a7890123456@utch.edu.mx', '81b145225a9eda43aa7b58c00de6ecde:224B87D86C4C32F03A72F199B1D221FECDDAB9A0DC6276722238756C4BE3CBFB', NULL),
(14, 'Sofía Valentina', 'Ortiz Castillo', 1, 1, 1, 'a8901234567@utch.edu.mx', '0143c90badb7110cd8148cc153a8056d:638F8F37C82B3D2D9D1CE5DE5A850069754EC8C5EB0AB0E852DC4F257E07179F', NULL),
(15, 'Luis Fernando', 'Ramírez Gutiérrez', 1, 10, 9, 'a9012345678@utch.edu.mx', '7ddba72523cea445912fb02aa338e010:1EE572DE6D6BF4653BA710F08C31167AD273ABF3C0972682B870B61D45C703DA', NULL),
(16, 'Gabriela Alejandra', 'Martínez Sánchez', 1, 2, 10, 'a9876543210@utch.edu.mx', 'd7db773456da60dae7e1e4311da4531a:41704C64DB5166E4680D2632399777A480481D25CE1CF2522CA9DB61109F78DE', NULL),
(17, 'Luis Carlos', 'Domínguez Banda', 1, 10, 3, 'a6523150031@utch.edu.mx', 'a2db6a6db60c6bc83ca5568ae4e1a2ed:E478222B443A323A190A92719CD07E7E8321D21D6ED41D40AEEE6803E879F391', 'static/uploads/2693507.png'),
(18, 'Josué Ricardo', 'Temoltzi Rivera', 1, 10, 3, 'a6523150089@utch.edu.mx', '664d643927102ac74c2641ff97ee5b77:D875476403BE2224BC1FDAAE66B435596D604BE5F01499511B3142B3C3AD5A4C', 'static/uploads/2693507.png'),
(19, 'Joel Uriel', 'Rocha Rivero', 1, 10, 3, 'a8473628974@utch.edu.mx', 'c41aef7d5645e2b19207471a9c4324ed:E26A06B0E541234A2E6C756008656652AE445FCE3CF8C2CD6491A175514EC1D7', 'static/uploads/2693507.png'),
(20, 'Emiliano ', 'Saez Carrillo', 1, 10, 3, 'a853948329@utch.edu.mx', 'a30868d26558bb694c767ea8ce7ea2a4:DD6E9D4ABDF57C70E5E66350D27F3E5D953B0DD5876C08B1BCF5D0B39FC28E2C', 'static/uploads/fortnite_20241125_183132.jpg'),
(21, 'Rodrigo', 'Zapata Villa', 1, 10, 3, 'a6473859061@utch.edu.mx', '00e59acb58d74b8ba5d95a9ebdaf9c5d:43B4E8570DD087ABD9CEE580D5E27C1234B1A6957F787E32D80C010646EF6CAB', 'static/uploads/fortnite_20241125_183226.jpg'),
(22, 'Alonso Manuel', 'Estrada Gutierrez', 1, 10, 3, 'a7385325983@utch.edu.mx', '8c4b1925040ee44c84407e93315f5b7d:E48B31DD67E6A1FE9D763383ABCC3912BEEB1A1A6CBCB1A47FD7B4FCE7B64C58', 'static/uploads/code_20241125_204535.jpeg'),
(23, 'Homero ', 'Simpson', 1, 10, 3, 'homero@utch.edu.mx', 'a3f01d8e5c05101b0b008c13f31ade4e:85AAB689F6160C9A6DBC486D39EF36D1411C72FE7B0BBB9F60D1958CAC2DC43C', 'static/uploads/homero_20241126_195606.gif');

--
-- Disparadores `user`
--
DELIMITER $$
CREATE TRIGGER `trg_EncryptedPasswordInsert` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    DECLARE salt CHAR(32);
    DECLARE hashed_password VARCHAR(256);

    SET salt = SUBSTRING(MD5(RAND()), 1, 32);

    SET hashed_password = UPPER(SHA2(CONCAT(salt, NEW.password), 256));

    SET NEW.password = CONCAT(salt, ':', hashed_password);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_EncryptedPasswordUpdate` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
    DECLARE salt CHAR(32);
    DECLARE hashed_password VARCHAR(256);

    SET salt = SUBSTRING(MD5(RAND()), 1, 32);

    SET hashed_password = UPPER(SHA2(CONCAT(salt, NEW.password), 256));

    SET NEW.password = CONCAT(salt, ':', hashed_password);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_student` AFTER INSERT ON `user` FOR EACH ROW INSERT INTO student (user_idUser) VALUES (NEW.idUser)
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `college`
--
ALTER TABLE `college`
  ADD PRIMARY KEY (`idCollege`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `emailExtension` (`emailExtension`);

--
-- Indices de la tabla `degree`
--
ALTER TABLE `degree`
  ADD PRIMARY KEY (`idDegree`),
  ADD UNIQUE KEY `Uq_degree_name` (`name`);

--
-- Indices de la tabla `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  ADD PRIMARY KEY (`idDegree_subdegree`),
  ADD KEY `fk_degree_subdegree_degree_idDegree` (`degree_idDegree`),
  ADD KEY `fk_degree_subdegree_subdegree_idSubdegree` (`subdegree_idSubdegree`);

--
-- Indices de la tabla `paymethod`
--
ALTER TABLE `paymethod`
  ADD PRIMARY KEY (`idPayMethod`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `petition`
--
ALTER TABLE `petition`
  ADD PRIMARY KEY (`idPetiton`),
  ADD KEY `fk_petition_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_petition_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_petition_subject_idSubject` (`subject_idSubject`),
  ADD KEY `fk_petition_status_idStatus` (`status_idStatus`);

--
-- Indices de la tabla `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`idReview`),
  ADD KEY `fk_review_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_review_tutor_user_idUser` (`tutor_user_idUser`);

--
-- Indices de la tabla `sale`
--
ALTER TABLE `sale`
  ADD PRIMARY KEY (`idSale`),
  ADD KEY `fk_sale_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_sale_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_sale_subject_idSubject` (`subject_idSubject`),
  ADD KEY `fk_sale_payMethod_idPayMethod` (`payMethod_idPayMethod`),
  ADD KEY `fk_sale_schedule_idSchedule` (`schedule_idSchedule`),
  ADD KEY `fk_sale_status_idStatus` (`status_idStatus`);

--
-- Indices de la tabla `savedtutor`
--
ALTER TABLE `savedtutor`
  ADD PRIMARY KEY (`idSaveTutor`),
  ADD KEY `fk_savedTutor_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_savedTutor_student_user_idUser` (`student_user_idUser`);

--
-- Indices de la tabla `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`idSchedule`),
  ADD KEY `fk_schedule_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_schedule_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_schedule_slootTime_idSlootTime` (`slootTime_idSlootTime`);

--
-- Indices de la tabla `slottime`
--
ALTER TABLE `slottime`
  ADD PRIMARY KEY (`idSlotTime`) USING BTREE,
  ADD UNIQUE KEY `startTime` (`startTime`),
  ADD UNIQUE KEY `endTime` (`endTime`);

--
-- Indices de la tabla `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`idStatus`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `student`
--
ALTER TABLE `student`
  ADD UNIQUE KEY `uni_user_idUser` (`user_idUser`),
  ADD UNIQUE KEY `user_idUser` (`user_idUser`),
  ADD KEY `fk_student_user_idUser` (`user_idUser`);

--
-- Indices de la tabla `studentnotification`
--
ALTER TABLE `studentnotification`
  ADD PRIMARY KEY (`idTutorNotification`),
  ADD KEY `fk_notification_student_user_idUser` (`student_user_idUser`);

--
-- Indices de la tabla `subdegree`
--
ALTER TABLE `subdegree`
  ADD PRIMARY KEY (`idSubdegree`),
  ADD UNIQUE KEY `Uq_subdegree_name` (`name`);

--
-- Indices de la tabla `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`idSubject`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `fk_subject_subjectCategory_idSubject` (`subjectCategory_idSubjectCategory`);

--
-- Indices de la tabla `subjectcategory`
--
ALTER TABLE `subjectcategory`
  ADD PRIMARY KEY (`idSubjectCategory`),
  ADD UNIQUE KEY `Uq_subjectCategory_name` (`name`);

--
-- Indices de la tabla `tutor`
--
ALTER TABLE `tutor`
  ADD UNIQUE KEY `uni_user_idUser` (`user_idUser`),
  ADD KEY `fk_tutor_user_idUser` (`user_idUser`);

--
-- Indices de la tabla `tutorsnotification`
--
ALTER TABLE `tutorsnotification`
  ADD PRIMARY KEY (`idTutorNotification`),
  ADD KEY `tutor_user_idUser` (`tutor_user_idUser`);

--
-- Indices de la tabla `tutor_subject`
--
ALTER TABLE `tutor_subject`
  ADD PRIMARY KEY (`idTutor_subject`),
  ADD KEY `fk_tutor_subject_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_tutor_subject_idSubject` (`subject_idSubject`) USING BTREE;

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `Uq_user_email` (`email`) USING BTREE,
  ADD KEY `fk_user_idDegree_subdegree` (`idDegree_subdegree`),
  ADD KEY `fk_user_college_idCollege` (`college_idCollege`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `college`
--
ALTER TABLE `college`
  MODIFY `idCollege` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `degree`
--
ALTER TABLE `degree`
  MODIFY `idDegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  MODIFY `idDegree_subdegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `paymethod`
--
ALTER TABLE `paymethod`
  MODIFY `idPayMethod` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `petition`
--
ALTER TABLE `petition`
  MODIFY `idPetiton` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `review`
--
ALTER TABLE `review`
  MODIFY `idReview` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `sale`
--
ALTER TABLE `sale`
  MODIFY `idSale` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `savedtutor`
--
ALTER TABLE `savedtutor`
  MODIFY `idSaveTutor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `schedule`
--
ALTER TABLE `schedule`
  MODIFY `idSchedule` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `slottime`
--
ALTER TABLE `slottime`
  MODIFY `idSlotTime` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `status`
--
ALTER TABLE `status`
  MODIFY `idStatus` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `studentnotification`
--
ALTER TABLE `studentnotification`
  MODIFY `idTutorNotification` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subdegree`
--
ALTER TABLE `subdegree`
  MODIFY `idSubdegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `subject`
--
ALTER TABLE `subject`
  MODIFY `idSubject` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT de la tabla `subjectcategory`
--
ALTER TABLE `subjectcategory`
  MODIFY `idSubjectCategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `tutorsnotification`
--
ALTER TABLE `tutorsnotification`
  MODIFY `idTutorNotification` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tutor_subject`
--
ALTER TABLE `tutor_subject`
  MODIFY `idTutor_subject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  ADD CONSTRAINT `fk_degree_subdegree_degree_idDegree` FOREIGN KEY (`degree_idDegree`) REFERENCES `degree` (`idDegree`),
  ADD CONSTRAINT `fk_degree_subdegree_subdegree_idSubdegree` FOREIGN KEY (`subdegree_idSubdegree`) REFERENCES `subdegree` (`idSubdegree`);

--
-- Filtros para la tabla `petition`
--
ALTER TABLE `petition`
  ADD CONSTRAINT `fk_petition_status_idStatus` FOREIGN KEY (`status_idStatus`) REFERENCES `status` (`idStatus`),
  ADD CONSTRAINT `fk_petition_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_petition_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`),
  ADD CONSTRAINT `fk_petition_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`),
  ADD CONSTRAINT `fk_review_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`);

--
-- Filtros para la tabla `sale`
--
ALTER TABLE `sale`
  ADD CONSTRAINT `fk_sale_payMethod_idPayMethod` FOREIGN KEY (`payMethod_idPayMethod`) REFERENCES `paymethod` (`idPayMethod`),
  ADD CONSTRAINT `fk_sale_schedule_idSchedule` FOREIGN KEY (`schedule_idSchedule`) REFERENCES `schedule` (`idSchedule`),
  ADD CONSTRAINT `fk_sale_status_idStatus` FOREIGN KEY (`status_idStatus`) REFERENCES `status` (`idStatus`),
  ADD CONSTRAINT `fk_sale_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sale_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`),
  ADD CONSTRAINT `fk_sale_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `savedtutor`
--
ALTER TABLE `savedtutor`
  ADD CONSTRAINT `fk_savedTutor_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_savedTutor_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `fk_schedule_slootTime_idSlootTime` FOREIGN KEY (`slootTime_idSlootTime`) REFERENCES `slottime` (`idSlotTime`),
  ADD CONSTRAINT `fk_schedule_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_schedule_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `fk_student_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

--
-- Filtros para la tabla `studentnotification`
--
ALTER TABLE `studentnotification`
  ADD CONSTRAINT `fk_notification_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `subject`
--
ALTER TABLE `subject`
  ADD CONSTRAINT `fk_subject_subjectCategory_idSubject` FOREIGN KEY (`subjectCategory_idSubjectCategory`) REFERENCES `subjectcategory` (`idSubjectCategory`);

--
-- Filtros para la tabla `tutor`
--
ALTER TABLE `tutor`
  ADD CONSTRAINT `fk_tutor_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

--
-- Filtros para la tabla `tutorsnotification`
--
ALTER TABLE `tutorsnotification`
  ADD CONSTRAINT `tutorsnotification_ibfk_1` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`);

--
-- Filtros para la tabla `tutor_subject`
--
ALTER TABLE `tutor_subject`
  ADD CONSTRAINT `fk_tutor_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor_subject_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_college_idCollege` FOREIGN KEY (`college_idCollege`) REFERENCES `college` (`idCollege`),
  ADD CONSTRAINT `fk_user_idDegree_subdegree` FOREIGN KEY (`idDegree_subdegree`) REFERENCES `degree_subdegree` (`idDegree_subdegree`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
