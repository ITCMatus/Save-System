-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u1
-- http://www.phpmyadmin.net
--
-- Hostiteľ: localhost
-- Čas generovania: Ne 31.Júl 2016, 13:34
-- Verzia serveru: 10.0.25-MariaDB-0+deb8u1
-- Verzia PHP: 7.0.8-1~dotdeb+8.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databáza: `San_Andreas`
--

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `account`
--

CREATE TABLE IF NOT EXISTS `account` (
`ID` int(10) NOT NULL,
  `UserName` varchar(25) CHARACTER SET cp1250 NOT NULL,
  `Password` varchar(129) CHARACTER SET cp1250 NOT NULL,
  `Wanted` int(5) NOT NULL,
  `Skin` int(4) NOT NULL,
  `Kill` int(10) NOT NULL,
  `Death` int(10) NOT NULL,
  `Admin` int(2) NOT NULL,
  `PosX` float NOT NULL,
  `PosY` float NOT NULL,
  `PosZ` float NOT NULL,
  `PosR` float NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf32 COLLATE=utf32_slovak_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
 ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
