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

CREATE TABLE `wow_specs` (
  `id` int(3) NOT NULL,
  `name` text CHARACTER SET utf8 NOT NULL,
  `class` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `wow_specs`
--

INSERT INTO `wow_specs` (`id`, `name`, `class`) VALUES
(62, 'Arcane', 'Mage'),
(63, 'Fire', 'Mage'),
(64, 'Frost', 'Mage'),
(65, 'Holy', 'Paladin'),
(66, 'Protection', 'Paladin'),
(70, 'Retribution', 'Paladin'),
(71, 'Arms', 'Warrior'),
(72, 'Fury', 'Warrior'),
(73, 'Protection', 'Warrior'),
(102, 'Balance', 'Druid'),
(103, 'Feral', 'Druid'),
(104, 'Guardian', 'Druid'),
(105, 'Restoration', 'Druid'),
(250, 'Blood', 'Death Knight'),
(251, 'Frost', 'Death Knight'),
(252, 'Unholy', 'Death Knight'),
(253, 'Beast Mastery', 'Hunter'),
(254, 'Marksmanship', 'Hunter'),
(255, 'Survival', 'Hunter'),
(256, 'Discipline', 'Priest'),
(257, 'Holy', 'Priest'),
(258, 'Shadow', 'Priest'),
(259, 'Assassination', 'Rogue'),
(260, 'Combat', 'Rogue'),
(261, 'Subtlety', 'Rogue'),
(262, 'Elemental', 'Shaman'),
(263, 'Enhancement', 'Shaman'),
(264, 'Restoration', 'Shaman'),
(265, 'Affliction', 'Warlock'),
(266, 'Demonology', 'Warlock'),
(267, 'Destruction', 'Warlock'),
(268, 'Brewmaster', 'Monk'),
(269, 'Windwalker', 'Monk'),
(270, 'Mistweaver', 'Monk'),
(577, 'Havoc', 'Demon Hunter'),
(578, 'Devastation', 'Demon Hunter');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
