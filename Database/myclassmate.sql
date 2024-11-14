-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 14, 2024 at 09:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myclassmate`
--

-- --------------------------------------------------------

--
-- Table structure for table `college`
--

CREATE TABLE `college` (
  `idCollege` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `emailExtension` varchar(50) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `college`
--

INSERT INTO `college` (`idCollege`, `name`, `emailExtension`, `createdAt`, `active`) VALUES
(1, 'Universidad Tecnológica de Chihuahua', '@utch.edu.mx', '2024-11-05 18:59:57', 1);

-- --------------------------------------------------------

--
-- Table structure for table `degree`
--

CREATE TABLE `degree` (
  `idDegree` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `degree`
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
-- Table structure for table `degree_subdegree`
--

CREATE TABLE `degree_subdegree` (
  `idDegree_subdegree` int(11) NOT NULL,
  `degree_idDegree` int(11) NOT NULL,
  `subdegree_idSubdegree` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `degree_subdegree`
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
-- Table structure for table `paymethod`
--

CREATE TABLE `paymethod` (
  `idPayMethod` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `petition`
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
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `idReview` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL CHECK (`rating` between 1 and 5),
  `description` varchar(100) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `review`
--
DELIMITER $$
CREATE TRIGGER `trg_meanRatingInsert` AFTER INSERT ON `review` FOR EACH ROW UPDATE tutor SET meanRating = (SELECT AVG(rating) FROM review GROUP BY tutor_user_idUser) WHERE NEW.tutor_user_idUser = tutor.user_idUser
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_meanRatingUpdate` AFTER INSERT ON `review` FOR EACH ROW UPDATE tutor SET meanRating = (SELECT AVG(rating) FROM review GROUP BY tutor_user_idUser) WHERE NEW.tutor_user_idUser = tutor.user_idUser
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sale`
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
-- Table structure for table `savedtutor`
--

CREATE TABLE `savedtutor` (
  `idSaveTutor` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `idSchedule` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `student_user_idUser` int(11) NOT NULL,
  `scheduledDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `slootTime_idSlootTime` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `slottime`
--

CREATE TABLE `slottime` (
  `idSlotTime` int(11) NOT NULL,
  `startTime` time NOT NULL,
  `endTime` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `idStatus` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `user_idUser` int(11) NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT 0 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
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
(16, 0, '2024-11-14 19:59:59', 1);

-- --------------------------------------------------------

--
-- Table structure for table `studentnotification`
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
-- Table structure for table `subdegree`
--

CREATE TABLE `subdegree` (
  `idSubdegree` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subdegree`
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
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `idSubject` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`idSubject`, `name`, `active`) VALUES
(1, 'Probabilidad y estadística', 1),
(2, 'Química básica', 1),
(3, 'Electricidad y magnetismo', 1),
(4, 'Desarrollo sustentable', 1),
(5, 'Informática', 1),
(6, 'Circuitos eléctricos', 1),
(7, 'Inglés I', 1),
(8, 'Expresión oral y escrita I', 1),
(9, 'Formación sociocultural I', 1),
(10, 'Álgebra lineal', 1),
(11, 'Física', 1),
(12, 'Termodinámica', 1),
(13, 'Instalaciones eléctricas', 1),
(14, 'Electrónica industrial', 1),
(15, 'Mecánica industrial', 1),
(16, 'Inglés II', 1),
(17, 'Formación sociocultural II', 1),
(18, 'Funciones matemáticas', 1),
(19, 'Fisicoquímica', 1),
(20, 'Instrumentación industrial', 1),
(21, 'Mantenimiento electromecánico', 1),
(22, 'Energías renovables', 1),
(23, 'Formulación de proyectos', 1),
(24, 'Calidad', 1),
(25, 'Cálculo diferencial', 1),
(26, 'Estructura y propiedades de los materiales', 1),
(27, 'Fisicoquímica aplicada', 1),
(28, 'Dibujo industrial', 1),
(29, 'Electrónica de potencia', 1),
(30, 'Estaciones meteorológicas', 1),
(31, 'Procesos industriales', 1),
(32, 'Inglés IV', 1),
(33, 'Formación sociocultural III', 1),
(34, 'Cálculo integral', 1),
(35, 'Seguridad industrial', 1),
(36, 'Celdas fotovoltaicas', 1),
(37, 'Colectores solares', 1),
(38, 'Administración de proyectos', 1),
(39, 'Adquisición de datos', 1),
(40, 'Inglés V', 1),
(41, 'Expresión oral y escrita II', 1),
(42, 'Organización industrial', 1),
(43, 'Metrología I', 1),
(44, 'Herramientas informáticas I', 1),
(45, 'Administración de la producción I', 1),
(46, 'Métodos y sistemas de trabajo I', 1),
(47, 'Tópicos de manufactura', 1),
(48, 'Costos de producción', 1),
(49, 'Control estadístico del proceso', 1),
(50, 'Procesos de manufactura I', 1),
(51, 'Distribución de planta', 1),
(52, 'Resistencia de los materiales', 1),
(53, 'Química II', 1),
(54, 'Gestión ambiental', 1),
(55, 'Fundamentos de automatización', 1),
(56, 'Proceso de maquinado de precisión no convencional', 1),
(57, 'Tolerancias geométricas y dimensionales', 1),
(58, 'Métodos y sistemas de trabajo II', 1),
(59, 'Seguridad e higiene industrial', 1),
(60, 'Procesos de fabricación de materiales cerámicos I', 1),
(61, 'Manejo de materiales', 1),
(62, 'Reología', 1),
(63, 'Almacenes y control de inventarios', 1),
(64, 'Análisis de las condiciones de trabajo', 1),
(65, 'Transformación de productos plásticos I', 1),
(66, 'Procesos de manufactura de moldes, cabezales y dad', 1),
(67, 'Mantenimiento autónomo en proceso', 1),
(68, 'Diseño de producto', 1),
(69, 'Metrología II', 1),
(70, 'Estructura y propiedad de los polímeros y los acer', 1),
(71, 'Proceso de maquinado de precisión convencional', 1),
(72, 'Dibujo asistido por la computadora', 1),
(73, 'Administración de la calidad', 1),
(74, 'Fundamentos de legislación industrial', 1),
(75, 'Fundamentos de ingeniería económica', 1),
(76, 'Procesos de manufactura II', 1),
(77, 'Cadena de suministros', 1),
(78, 'Manufactura aplicada', 1),
(79, 'Procesos químicos', 1),
(80, 'Proceso de maquinado de precisión CNC', 1),
(81, 'Manufactura asistida por computadora', 1),
(82, 'Prueba de los materiales', 1),
(83, 'Moldes cerámicos', 1),
(84, 'Procesos de fabricación de materiales cerámicos II', 1),
(85, 'Propiedades y pruebas de materias primas', 1),
(86, 'Herramientas informáticas II', 1),
(87, 'Automatización', 1),
(88, 'Transformación de productos plásticos II', 1),
(89, 'Moldes', 1),
(90, 'Reciclado de polímeros', 1),
(91, 'Principios de automatización', 1),
(92, 'Desarrollo humano y valores', 1),
(93, 'Mercadotecnia', 1),
(94, 'Matemáticas', 1),
(95, 'Fundamentos de administración y entorno empresaria', 1),
(96, 'Comunicación y habilidades digitales', 1),
(97, 'Habilidades socioemocionales y manejo de conflicto', 1),
(98, 'Estadística I', 1),
(99, 'Planeación estratégica', 1),
(100, 'Contabilidad para negocios', 1),
(101, 'Comportamiento del consumidor', 1),
(102, 'Economía', 1),
(103, 'Desarrollo del pensamiento y toma de decisiones', 1),
(104, 'Legislación comercial', 1),
(105, 'Estadística II', 1),
(106, 'Sistema de investigación de mercados I', 1),
(107, 'Estrategias de producto y precio', 1),
(108, 'Ética profesional', 1),
(109, 'Mezcla promocional', 1),
(110, 'Diseño digital y multimedia', 1),
(111, 'Sistema de investigación de mercados II', 1),
(112, 'Gestión de ventas', 1),
(113, 'Administración del tiempo', 1),
(114, 'Liderazgo de equipos de alto desempeño', 1),
(115, 'Logística y distribución', 1),
(116, 'Mercadotecnia de servicios', 1),
(117, 'Mercadotecnia digital I', 1),
(118, 'Mercadotecnia estratégica', 1),
(119, 'Introducción al mantenimiento', 1),
(120, 'Seguridad y medio ambiente', 1),
(121, 'Administración del personal', 1),
(122, 'Gestión del mantenimiento', 1),
(123, 'Calidad en el mantenimiento', 1),
(124, 'Costos y presupuestos', 1),
(125, 'Sistemas eléctricos', 1),
(126, 'Máquinas y mecanismos', 1),
(127, 'Electrónica analógica', 1),
(128, 'Máquinas eléctricas', 1),
(129, 'Redes de servicios industriales', 1),
(130, 'Electrónica digital', 1),
(131, 'Principios de programación', 1),
(132, 'Sistemas neumáticos e hidráulicos', 1),
(133, 'Máquinas térmicas', 1),
(134, 'Mantenimiento a procesos de manufactura', 1),
(135, 'Automatización y robótica', 1),
(136, 'Ingeniería de materiales', 1),
(137, 'Fundamentos matemáticos', 1),
(138, 'Metodología para la programación', 1),
(139, 'Metrología', 1),
(140, 'Cálculo de varias variables', 1),
(141, 'Control de motores eléctricos', 1),
(142, 'Ecuaciones diferenciales', 1),
(143, 'Controladores lógicos programables', 1),
(144, 'Implementación de sistemas automáticos', 1),
(145, 'Desarrollo de habilidades de pensamiento lógico', 1),
(146, 'Fundamentos de TI', 1),
(147, 'Fundamentos de redes', 1),
(148, 'Metodologías de desarrollo de software', 1),
(149, 'Interconexión de redes', 1),
(150, 'Programación orientada a objetos', 1),
(151, 'Introducción al diseño digital', 1),
(152, 'Base de datos', 1),
(153, 'Sistemas operativos', 1),
(154, 'Aplicaciones WEB', 1),
(155, 'Bases de datos para aplicaciones', 1),
(156, 'Mercadotecnia digital', 1),
(157, 'Diseño digital', 1),
(158, 'Conmutación en redes de datos', 1),
(159, 'Infraestructura de redes de datos', 1),
(160, 'Estándares y métricas para el desarrollo de softwa', 1),
(161, 'Principios para IoT', 1),
(162, 'Diseño de APPS', 1),
(163, 'Estructura de datos aplicadas', 1),
(164, 'Aplicaciones WEB orientadas a servicios', 1),
(165, 'Evaluación y mejora para el desarrollo de software', 1),
(166, 'Electrónica para IDC', 1),
(167, 'Conexión de redes WAN', 1),
(168, 'Administración de servidores I', 1),
(169, 'Programación de redes', 1),
(170, 'Aplicaciones de IoT', 1),
(171, 'Desarrollo móvil multiplataforma', 1),
(172, 'Aplicaciones WEB para I4.0', 1),
(173, 'Bases de datos para cómputo en la nube', 1),
(174, 'Producción audiovisual', 1),
(175, 'Animación 3D', 1),
(176, 'Desarrollo de aplicaciones de realidad virtual', 1),
(177, 'Desarrollo de aplicaciones para negocios digitales', 1),
(178, 'Introducción a BIG DATA', 1),
(179, 'Administración de redes de datos', 1),
(180, 'Administración de servidores II', 1),
(181, 'Ciberseguridad', 1),
(182, 'Fundamentos pedagógicos de la educación', 1),
(183, 'Estadística aplicada a la educación', 1),
(184, 'Metodología de la investigación', 1),
(185, 'Diseño de material didáctico', 1),
(186, 'Metodología de la didáctica', 1),
(187, 'La educación en México', 1),
(188, 'Planeación docente', 1),
(189, 'Evaluación del proceso enseñanza y aprendizaje', 1),
(190, 'Estrategias enseñanza de la lengua inglesa I', 1),
(191, 'Diseño de situaciones de aprendizaje', 1),
(192, 'Instrumentos de evaluación', 1),
(193, 'Fonética', 1),
(194, 'Estrategias de enseñanza de la lengua inglesa II', 1),
(195, 'Estructura gramatical', 1),
(196, 'Enseñanza de habilidades productivas', 1),
(197, 'Enseñanzas de habilidades receptivas', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tutor`
--

CREATE TABLE `tutor` (
  `user_idUser` int(11) NOT NULL,
  `asesoryCost` decimal(10,2) NOT NULL,
  `meanRating` decimal(3,2) NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT 0 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutornotification`
--

CREATE TABLE `tutornotification` (
  `idTutorNotification` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT 1 CHECK (`seen` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutor_subject`
--

CREATE TABLE `tutor_subject` (
  `idTutor_subject` int(11) NOT NULL,
  `tutor_user_idUser` int(11) NOT NULL,
  `subject_idSubject` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `idUser` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `college_idCollege` int(11) NOT NULL,
  `idDegree_subdegree` int(11) NOT NULL,
  `term` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`idUser`, `name`, `lastName`, `college_idCollege`, `idDegree_subdegree`, `term`, `email`, `password`) VALUES
(7, 'Juan Carlos', 'Pérez Martínez', 1, 2, 3, 'a1234567890@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(8, 'María Fernanda', 'Gómez Rodríguez', 1, 10, 5, 'a2345678901@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(9, 'José Luis', 'Hernández Rivera', 1, 8, 2, 'a3456789012@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(10, 'Ana Isabel', 'Sánchez Morales', 1, 1, 8, 'a4567890123@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(11, 'Pedro Antonio', 'López García', 1, 3, 6, 'a5678901234@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(12, 'Laura Beatriz', 'Ramírez Torres', 1, 11, 7, 'a6789012345@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(13, 'Carlos Eduardo', 'Jiménez Vargas', 1, 5, 4, 'a7890123456@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(14, 'Sofía Valentina', 'Ortiz Castillo', 1, 1, 1, 'a8901234567@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(15, 'Luis Fernando', 'Ramírez Gutiérrez', 1, 10, 9, 'a9012345678@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec'),
(16, 'Gabriela Alejandra', 'Martínez Sánchez', 1, 2, 10, 'a9876543210@utch.edu.mx', '9af15b336e6a9619928537df30b2e6a2376569fcf9d7e773ec');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `tg_passwordEncryption` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
	SET NEW.`password` = SHA2(NEW.`password`, 256);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_student` AFTER INSERT ON `user` FOR EACH ROW INSERT INTO student (user_idUser) VALUES (NEW.idUser)
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `college`
--
ALTER TABLE `college`
  ADD PRIMARY KEY (`idCollege`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `emailExtension` (`emailExtension`);

--
-- Indexes for table `degree`
--
ALTER TABLE `degree`
  ADD PRIMARY KEY (`idDegree`),
  ADD UNIQUE KEY `Uq_degree_name` (`name`);

--
-- Indexes for table `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  ADD PRIMARY KEY (`idDegree_subdegree`),
  ADD KEY `fk_degree_subdegree_degree_idDegree` (`degree_idDegree`),
  ADD KEY `fk_degree_subdegree_subdegree_idSubdegree` (`subdegree_idSubdegree`);

--
-- Indexes for table `paymethod`
--
ALTER TABLE `paymethod`
  ADD PRIMARY KEY (`idPayMethod`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `petition`
--
ALTER TABLE `petition`
  ADD PRIMARY KEY (`idPetiton`),
  ADD KEY `fk_petition_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_petition_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_petition_subject_idSubject` (`subject_idSubject`),
  ADD KEY `fk_petition_status_idStatus` (`status_idStatus`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`idReview`),
  ADD KEY `fk_review_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_review_tutor_user_idUser` (`tutor_user_idUser`);

--
-- Indexes for table `sale`
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
-- Indexes for table `savedtutor`
--
ALTER TABLE `savedtutor`
  ADD PRIMARY KEY (`idSaveTutor`),
  ADD KEY `fk_savedTutor_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_savedTutor_student_user_idUser` (`student_user_idUser`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD PRIMARY KEY (`idSchedule`),
  ADD KEY `fk_schedule_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_schedule_student_user_idUser` (`student_user_idUser`),
  ADD KEY `fk_schedule_slootTime_idSlootTime` (`slootTime_idSlootTime`);

--
-- Indexes for table `slottime`
--
ALTER TABLE `slottime`
  ADD PRIMARY KEY (`idSlotTime`) USING BTREE,
  ADD UNIQUE KEY `startTime` (`startTime`),
  ADD UNIQUE KEY `endTime` (`endTime`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`idStatus`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD KEY `fk_student_user_idUser` (`user_idUser`);

--
-- Indexes for table `studentnotification`
--
ALTER TABLE `studentnotification`
  ADD PRIMARY KEY (`idTutorNotification`),
  ADD KEY `fk_notification_student_user_idUser` (`student_user_idUser`);

--
-- Indexes for table `subdegree`
--
ALTER TABLE `subdegree`
  ADD PRIMARY KEY (`idSubdegree`),
  ADD UNIQUE KEY `Uq_subdegree_name` (`name`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`idSubject`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `tutor`
--
ALTER TABLE `tutor`
  ADD KEY `fk_tutor_user_idUser` (`user_idUser`);

--
-- Indexes for table `tutornotification`
--
ALTER TABLE `tutornotification`
  ADD PRIMARY KEY (`idTutorNotification`),
  ADD KEY `fk_notification_tutor_user_idUser` (`tutor_user_idUser`);

--
-- Indexes for table `tutor_subject`
--
ALTER TABLE `tutor_subject`
  ADD PRIMARY KEY (`idTutor_subject`),
  ADD KEY `fk_tutor_subject_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_tutor_subject_idSubject` (`subject_idSubject`) USING BTREE;

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `Uq_user_email` (`email`) USING BTREE,
  ADD KEY `fk_user_idDegree_subdegree` (`idDegree_subdegree`),
  ADD KEY `fk_user_college_idCollege` (`college_idCollege`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `college`
--
ALTER TABLE `college`
  MODIFY `idCollege` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `degree`
--
ALTER TABLE `degree`
  MODIFY `idDegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  MODIFY `idDegree_subdegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `paymethod`
--
ALTER TABLE `paymethod`
  MODIFY `idPayMethod` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `petition`
--
ALTER TABLE `petition`
  MODIFY `idPetiton` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `idReview` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `sale`
--
ALTER TABLE `sale`
  MODIFY `idSale` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `savedtutor`
--
ALTER TABLE `savedtutor`
  MODIFY `idSaveTutor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `schedule`
--
ALTER TABLE `schedule`
  MODIFY `idSchedule` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `slottime`
--
ALTER TABLE `slottime`
  MODIFY `idSlotTime` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `idStatus` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `studentnotification`
--
ALTER TABLE `studentnotification`
  MODIFY `idTutorNotification` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subdegree`
--
ALTER TABLE `subdegree`
  MODIFY `idSubdegree` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `idSubject` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT for table `tutornotification`
--
ALTER TABLE `tutornotification`
  MODIFY `idTutorNotification` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutor_subject`
--
ALTER TABLE `tutor_subject`
  MODIFY `idTutor_subject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  ADD CONSTRAINT `fk_degree_subdegree_degree_idDegree` FOREIGN KEY (`degree_idDegree`) REFERENCES `degree` (`idDegree`),
  ADD CONSTRAINT `fk_degree_subdegree_subdegree_idSubdegree` FOREIGN KEY (`subdegree_idSubdegree`) REFERENCES `subdegree` (`idSubdegree`);

--
-- Constraints for table `petition`
--
ALTER TABLE `petition`
  ADD CONSTRAINT `fk_petition_status_idStatus` FOREIGN KEY (`status_idStatus`) REFERENCES `status` (`idStatus`),
  ADD CONSTRAINT `fk_petition_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_petition_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`),
  ADD CONSTRAINT `fk_petition_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON UPDATE CASCADE;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`),
  ADD CONSTRAINT `fk_review_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`);

--
-- Constraints for table `sale`
--
ALTER TABLE `sale`
  ADD CONSTRAINT `fk_sale_payMethod_idPayMethod` FOREIGN KEY (`payMethod_idPayMethod`) REFERENCES `paymethod` (`idPayMethod`),
  ADD CONSTRAINT `fk_sale_schedule_idSchedule` FOREIGN KEY (`schedule_idSchedule`) REFERENCES `schedule` (`idSchedule`),
  ADD CONSTRAINT `fk_sale_status_idStatus` FOREIGN KEY (`status_idStatus`) REFERENCES `status` (`idStatus`),
  ADD CONSTRAINT `fk_sale_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sale_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`),
  ADD CONSTRAINT `fk_sale_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON UPDATE CASCADE;

--
-- Constraints for table `savedtutor`
--
ALTER TABLE `savedtutor`
  ADD CONSTRAINT `fk_savedTutor_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_savedTutor_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `fk_schedule_slootTime_idSlootTime` FOREIGN KEY (`slootTime_idSlootTime`) REFERENCES `slottime` (`idSlotTime`),
  ADD CONSTRAINT `fk_schedule_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_schedule_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `fk_student_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

--
-- Constraints for table `studentnotification`
--
ALTER TABLE `studentnotification`
  ADD CONSTRAINT `fk_notification_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor`
--
ALTER TABLE `tutor`
  ADD CONSTRAINT `fk_tutor_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

--
-- Constraints for table `tutornotification`
--
ALTER TABLE `tutornotification`
  ADD CONSTRAINT `fk_notification_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tutor_subject`
--
ALTER TABLE `tutor_subject`
  ADD CONSTRAINT `fk_tutor_subject_idSubject` FOREIGN KEY (`subject_idSubject`) REFERENCES `subject` (`idSubject`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tutor_subject_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_college_idCollege` FOREIGN KEY (`college_idCollege`) REFERENCES `college` (`idCollege`),
  ADD CONSTRAINT `fk_user_idDegree_subdegree` FOREIGN KEY (`idDegree_subdegree`) REFERENCES `degree_subdegree` (`idDegree_subdegree`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
