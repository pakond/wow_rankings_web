-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-10-2017 a las 03:23:12
-- Versión del servidor: 10.1.25-MariaDB
-- Versión de PHP: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `blizzardrankings`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `wow_specs`
--

CREATE TABLE `wow_specs_es` (
  `id` int(3) NOT NULL,
  `name` text CHARACTER SET utf8 NOT NULL,
  `class` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `wow_specs`
--

INSERT INTO `wow_specs_es` (`id`, `name`, `class`) VALUES
(62, 'Arcano', 'Mago'),
(63, 'Fuego', 'Mago'),
(64, 'Escarcha', 'Mago'),
(65, 'Sagrado', 'Paladín'),
(66, 'Protección', 'Paladín'),
(70, 'Retribución', 'Paladín'),
(71, 'Armas', 'Guerrero'),
(72, 'Fury', 'Guerrero'),
(73, 'Protección', 'Guerrero'),
(102, 'Equilibrio', 'Druida'),
(103, 'Feral', 'Druida'),
(104, 'Guardian', 'Druida'),
(105, 'Restauración', 'Druida'),
(250, 'Sangre', 'Caballero de la Muerte'),
(251, 'Escarcha', 'Caballero de la Muerte'),
(252, 'Profano', 'Caballero de la Muerte'),
(253, 'Bestías', 'Cazador'),
(254, 'Puntería', 'Cazador'),
(255, 'Supervivencia', 'Cazador'),
(256, 'Discíplina', 'Sacerdote'),
(257, 'Sagrado', 'Sacerdote'),
(258, 'Sombras', 'Sacerdote'),
(259, 'Asesinato', 'Pícaro'),
(260, 'Combate', 'Pícaro'),
(261, 'Sutileza', 'Pícaro'),
(262, 'Elemental', 'Chamán'),
(263, 'Enhancement', 'Chamán'),
(264, 'Restoration', 'Chamán'),
(265, 'Affliccion', 'Brujo'),
(266, 'Demonologia', 'Brujo'),
(267, 'Destruccion', 'Brujo'),
(268, 'Maestro cervecero', 'Monje'),
(269, 'Viajero del viento', 'Monje'),
(270, 'Tejedor de niebla', 'Monje'),
(577, 'Venganza', 'Cazador de demonios'),
(578, 'Devastación', 'Cazador de demonios');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
