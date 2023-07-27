-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 27, 2023 at 05:44 PM
-- Server version: 8.1.0
-- PHP Version: 7.4.3-4ubuntu2.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `spnvtestdb01`
--
CREATE DATABASE IF NOT EXISTS `spnvtestdb01` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `spnvtestdb01`;

-- --------------------------------------------------------

--
-- Table structure for table `bronze_d_product`
--

DROP TABLE IF EXISTS `bronze_d_product`;
CREATE TABLE IF NOT EXISTS `bronze_d_product` (
  `productId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `price` decimal(10,6) DEFAULT NULL,
  `discountPercentage` decimal(10,6) DEFAULT NULL,
  `rating` decimal(10,6) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `thumbnail` varchar(100) DEFAULT NULL,
  `images` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bronze_d_user`
--

DROP TABLE IF EXISTS `bronze_d_user`;
CREATE TABLE IF NOT EXISTS `bronze_d_user` (
  `userId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `maidenName` varchar(100) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `birthDate` date DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `bloodGroup` varchar(5) DEFAULT NULL,
  `height` int DEFAULT NULL,
  `weight` decimal(4,1) DEFAULT NULL,
  `eyeColor` varchar(100) DEFAULT NULL,
  `hairColor` varchar(100) DEFAULT NULL,
  `hairType` varchar(100) DEFAULT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `coordinatesLat` decimal(20,6) DEFAULT NULL,
  `coordinatesLng` decimal(20,6) DEFAULT NULL,
  `postalCode` int DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `macAddress` varchar(100) DEFAULT NULL,
  `university` varchar(100) DEFAULT NULL,
  `bankCardExpire` varchar(5) DEFAULT NULL,
  `bankCardNumber` varchar(100) DEFAULT NULL,
  `bankCardType` varchar(100) DEFAULT NULL,
  `bankCurrency` varchar(100) DEFAULT NULL,
  `bankIban` varchar(100) DEFAULT NULL,
  `companyAddress` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `companyCity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `companyCoordinatesLat` decimal(20,6) DEFAULT NULL,
  `companyCoordinatesLng` decimal(20,14) DEFAULT NULL,
  `companyPostalCode` int DEFAULT NULL,
  `companyState` varchar(100) DEFAULT NULL,
  `companyDepartment` varchar(100) DEFAULT NULL,
  `companyName` varchar(100) DEFAULT NULL,
  `companyTitle` varchar(100) DEFAULT NULL,
  `ein` varchar(100) DEFAULT NULL,
  `ssn` varchar(100) DEFAULT NULL,
  `userAgent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bronze_f_cart`
--

DROP TABLE IF EXISTS `bronze_f_cart`;
CREATE TABLE IF NOT EXISTS `bronze_f_cart` (
  `cartId` int NOT NULL,
  `userId` int NOT NULL,
  `productId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `price` decimal(10,6) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `discountPercentage` decimal(10,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bronze_f_comment`
--

DROP TABLE IF EXISTS `bronze_f_comment`;
CREATE TABLE IF NOT EXISTS `bronze_f_comment` (
  `commentId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `postId` int NOT NULL,
  `userId` int NOT NULL,
  `body` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bronze_f_post`
--

DROP TABLE IF EXISTS `bronze_f_post`;
CREATE TABLE IF NOT EXISTS `bronze_f_post` (
  `postId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `userId` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `body` longtext,
  `reactions` int DEFAULT NULL,
  `tags` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_d_product`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_d_product`;
CREATE TABLE IF NOT EXISTS `gold_d_product` (
`productId` int
,`title` varchar(100)
,`description` varchar(100)
,`price` decimal(10,6)
,`discountPercentage` decimal(10,6)
,`rating` decimal(10,6)
,`stock` int
,`brand` varchar(100)
,`category` varchar(100)
,`thumbnail` varchar(100)
,`images` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_d_user`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_d_user`;
CREATE TABLE IF NOT EXISTS `gold_d_user` (
`userId` int
,`firstName` varchar(100)
,`lastName` varchar(100)
,`maidenName` varchar(100)
,`age` int
,`gender` varchar(100)
,`email` varchar(100)
,`phone` varchar(100)
,`username` varchar(100)
,`password` varchar(100)
,`birthDate` date
,`image` varchar(100)
,`bloodGroup` varchar(5)
,`height` int
,`weight` decimal(4,1)
,`eyeColor` varchar(100)
,`hairColor` varchar(100)
,`hairType` varchar(100)
,`domain` varchar(100)
,`ip` varchar(16)
,`address` varchar(100)
,`city` varchar(100)
,`coordinatesLat` decimal(20,6)
,`coordinatesLng` decimal(20,6)
,`postalCode` int
,`state` varchar(100)
,`macAddress` varchar(100)
,`university` varchar(100)
,`bankCardExpire` varchar(5)
,`bankCardNumber` varchar(100)
,`bankCardType` varchar(100)
,`bankCurrency` varchar(100)
,`bankIban` varchar(100)
,`companyAddress` varchar(100)
,`companyCity` varchar(100)
,`companyCoordinatesLat` decimal(20,6)
,`companyCoordinatesLng` decimal(20,14)
,`companyPostalCode` int
,`companyState` varchar(100)
,`companyDepartment` varchar(100)
,`companyName` varchar(100)
,`companyTitle` varchar(100)
,`ein` varchar(100)
,`ssn` varchar(100)
,`userAgent` varchar(1000)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_d_user_address`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_d_user_address`;
CREATE TABLE IF NOT EXISTS `gold_d_user_address` (
`userId` int
,`address` varchar(100)
,`city` varchar(100)
,`coordinatesLat` decimal(20,6)
,`coordinatesLng` decimal(20,6)
,`postalCode` int
,`state` varchar(100)
,`companyAddress` varchar(100)
,`companyCity` varchar(100)
,`companyCoordinatesLat` decimal(20,6)
,`companyCoordinatesLng` decimal(20,14)
,`companyPostalCode` int
,`companyState` varchar(100)
,`companyDepartment` varchar(100)
,`companyName` varchar(100)
,`companyTitle` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_f_cart`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_f_cart`;
CREATE TABLE IF NOT EXISTS `gold_f_cart` (
`cartId` int
,`userId` int
,`productId` int
,`title` varchar(100)
,`price` decimal(10,6)
,`quantity` int
,`total` decimal(20,6)
,`discountPercentage` decimal(10,6)
,`discountedPrice` decimal(20,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_f_comment`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_f_comment`;
CREATE TABLE IF NOT EXISTS `gold_f_comment` (
`commentId` int
,`postId` int
,`userId` int
,`username` varchar(100)
,`title` varchar(100)
,`body` longtext
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `gold_f_post`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `gold_f_post`;
CREATE TABLE IF NOT EXISTS `gold_f_post` (
`postId` int
,`userId` int
,`title` varchar(100)
,`body` longtext
,`reactions` int
,`tags` varchar(1000)
);

-- --------------------------------------------------------

--
-- Table structure for table `silver_d_product`
--

DROP TABLE IF EXISTS `silver_d_product`;
CREATE TABLE IF NOT EXISTS `silver_d_product` (
  `productId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `current` tinyint(1) NOT NULL,
  `effectiveDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `price` decimal(10,6) DEFAULT NULL,
  `discountPercentage` decimal(10,6) DEFAULT NULL,
  `rating` decimal(10,6) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `thumbnail` varchar(100) DEFAULT NULL,
  `images` varchar(100) DEFAULT NULL,
  `productWid` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`productWid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `silver_d_user`
--

DROP TABLE IF EXISTS `silver_d_user`;
CREATE TABLE IF NOT EXISTS `silver_d_user` (
  `userId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `current` tinyint(1) NOT NULL,
  `effectiveDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `maidenName` varchar(100) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `birthDate` date DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `bloodGroup` varchar(5) DEFAULT NULL,
  `height` int DEFAULT NULL,
  `weight` decimal(4,1) DEFAULT NULL,
  `eyeColor` varchar(100) DEFAULT NULL,
  `hairColor` varchar(100) DEFAULT NULL,
  `hairType` varchar(100) DEFAULT NULL,
  `domain` varchar(100) DEFAULT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `coordinatesLat` decimal(20,6) DEFAULT NULL,
  `coordinatesLng` decimal(20,6) DEFAULT NULL,
  `postalCode` int DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `macAddress` varchar(100) DEFAULT NULL,
  `university` varchar(100) DEFAULT NULL,
  `bankCardExpire` varchar(5) DEFAULT NULL,
  `bankCardNumber` varchar(100) DEFAULT NULL,
  `bankCardType` varchar(100) DEFAULT NULL,
  `bankCurrency` varchar(100) DEFAULT NULL,
  `bankIban` varchar(100) DEFAULT NULL,
  `companyAddress` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `companyCity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `companyCoordinatesLat` decimal(20,6) DEFAULT NULL,
  `companyCoordinatesLng` decimal(20,14) DEFAULT NULL,
  `companyPostalCode` int DEFAULT NULL,
  `companyState` varchar(100) DEFAULT NULL,
  `companyDepartment` varchar(100) DEFAULT NULL,
  `companyName` varchar(100) DEFAULT NULL,
  `companyTitle` varchar(100) DEFAULT NULL,
  `ein` varchar(100) DEFAULT NULL,
  `ssn` varchar(100) DEFAULT NULL,
  `userAgent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `userWid` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`userWid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `silver_f_cart`
--

DROP TABLE IF EXISTS `silver_f_cart`;
CREATE TABLE IF NOT EXISTS `silver_f_cart` (
  `cartId` int NOT NULL,
  `cartWid` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `productId` int NOT NULL,
  `batchId` bigint NOT NULL,
  `createdDate` datetime NOT NULL,
  `updatedDate` datetime NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`cartWid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `silver_f_comment`
--

DROP TABLE IF EXISTS `silver_f_comment`;
CREATE TABLE IF NOT EXISTS `silver_f_comment` (
  `commentId` int NOT NULL,
  `commentWid` int NOT NULL AUTO_INCREMENT,
  `batchId` bigint NOT NULL,
  `postId` int NOT NULL,
  `userId` int NOT NULL,
  `createdDate` datetime NOT NULL,
  `updatedDate` datetime NOT NULL,
  `body` longtext NOT NULL,
  PRIMARY KEY (`commentWid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `silver_f_post`
--

DROP TABLE IF EXISTS `silver_f_post`;
CREATE TABLE IF NOT EXISTS `silver_f_post` (
  `postId` int NOT NULL,
  `postWid` int NOT NULL AUTO_INCREMENT,
  `batchId` bigint NOT NULL,
  `userId` int NOT NULL,
  `createdDate` datetime NOT NULL,
  `updatedDate` datetime NOT NULL,
  `title` varchar(100) NOT NULL,
  `body` longtext,
  `reactions` int DEFAULT NULL,
  `tags` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`postWid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure for view `gold_d_product`
--
DROP TABLE IF EXISTS `gold_d_product`;

DROP VIEW IF EXISTS `gold_d_product`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_d_product`  AS SELECT `silver_d_product`.`productId` AS `productId`, `silver_d_product`.`title` AS `title`, `silver_d_product`.`description` AS `description`, `silver_d_product`.`price` AS `price`, `silver_d_product`.`discountPercentage` AS `discountPercentage`, `silver_d_product`.`rating` AS `rating`, `silver_d_product`.`stock` AS `stock`, `silver_d_product`.`brand` AS `brand`, `silver_d_product`.`category` AS `category`, `silver_d_product`.`thumbnail` AS `thumbnail`, `silver_d_product`.`images` AS `images` FROM `silver_d_product` WHERE (`silver_d_product`.`current` = true) ;

-- --------------------------------------------------------

--
-- Structure for view `gold_d_user`
--
DROP TABLE IF EXISTS `gold_d_user`;

DROP VIEW IF EXISTS `gold_d_user`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_d_user`  AS SELECT `silver_d_user`.`userId` AS `userId`, `silver_d_user`.`firstName` AS `firstName`, `silver_d_user`.`lastName` AS `lastName`, `silver_d_user`.`maidenName` AS `maidenName`, `silver_d_user`.`age` AS `age`, `silver_d_user`.`gender` AS `gender`, `silver_d_user`.`email` AS `email`, `silver_d_user`.`phone` AS `phone`, `silver_d_user`.`username` AS `username`, `silver_d_user`.`password` AS `password`, `silver_d_user`.`birthDate` AS `birthDate`, `silver_d_user`.`image` AS `image`, `silver_d_user`.`bloodGroup` AS `bloodGroup`, `silver_d_user`.`height` AS `height`, `silver_d_user`.`weight` AS `weight`, `silver_d_user`.`eyeColor` AS `eyeColor`, `silver_d_user`.`hairColor` AS `hairColor`, `silver_d_user`.`hairType` AS `hairType`, `silver_d_user`.`domain` AS `domain`, `silver_d_user`.`ip` AS `ip`, `silver_d_user`.`address` AS `address`, `silver_d_user`.`city` AS `city`, `silver_d_user`.`coordinatesLat` AS `coordinatesLat`, `silver_d_user`.`coordinatesLng` AS `coordinatesLng`, `silver_d_user`.`postalCode` AS `postalCode`, `silver_d_user`.`state` AS `state`, `silver_d_user`.`macAddress` AS `macAddress`, `silver_d_user`.`university` AS `university`, `silver_d_user`.`bankCardExpire` AS `bankCardExpire`, `silver_d_user`.`bankCardNumber` AS `bankCardNumber`, `silver_d_user`.`bankCardType` AS `bankCardType`, `silver_d_user`.`bankCurrency` AS `bankCurrency`, `silver_d_user`.`bankIban` AS `bankIban`, `silver_d_user`.`companyAddress` AS `companyAddress`, `silver_d_user`.`companyCity` AS `companyCity`, `silver_d_user`.`companyCoordinatesLat` AS `companyCoordinatesLat`, `silver_d_user`.`companyCoordinatesLng` AS `companyCoordinatesLng`, `silver_d_user`.`companyPostalCode` AS `companyPostalCode`, `silver_d_user`.`companyState` AS `companyState`, `silver_d_user`.`companyDepartment` AS `companyDepartment`, `silver_d_user`.`companyName` AS `companyName`, `silver_d_user`.`companyTitle` AS `companyTitle`, `silver_d_user`.`ein` AS `ein`, `silver_d_user`.`ssn` AS `ssn`, `silver_d_user`.`userAgent` AS `userAgent` FROM `silver_d_user` WHERE (`silver_d_user`.`current` = true) ;

-- --------------------------------------------------------

--
-- Structure for view `gold_d_user_address`
--
DROP TABLE IF EXISTS `gold_d_user_address`;

DROP VIEW IF EXISTS `gold_d_user_address`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_d_user_address`  AS SELECT `silver_d_user`.`userId` AS `userId`, `silver_d_user`.`address` AS `address`, `silver_d_user`.`city` AS `city`, `silver_d_user`.`coordinatesLat` AS `coordinatesLat`, `silver_d_user`.`coordinatesLng` AS `coordinatesLng`, `silver_d_user`.`postalCode` AS `postalCode`, `silver_d_user`.`state` AS `state`, `silver_d_user`.`companyAddress` AS `companyAddress`, `silver_d_user`.`companyCity` AS `companyCity`, `silver_d_user`.`companyCoordinatesLat` AS `companyCoordinatesLat`, `silver_d_user`.`companyCoordinatesLng` AS `companyCoordinatesLng`, `silver_d_user`.`companyPostalCode` AS `companyPostalCode`, `silver_d_user`.`companyState` AS `companyState`, `silver_d_user`.`companyDepartment` AS `companyDepartment`, `silver_d_user`.`companyName` AS `companyName`, `silver_d_user`.`companyTitle` AS `companyTitle` FROM `silver_d_user` WHERE (`silver_d_user`.`current` = true) ;

-- --------------------------------------------------------

--
-- Structure for view `gold_f_cart`
--
DROP TABLE IF EXISTS `gold_f_cart`;

DROP VIEW IF EXISTS `gold_f_cart`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_f_cart`  AS SELECT `f`.`cartId` AS `cartId`, `f`.`userId` AS `userId`, `f`.`productId` AS `productId`, `p`.`title` AS `title`, `p`.`price` AS `price`, `f`.`quantity` AS `quantity`, (`p`.`price` * `f`.`quantity`) AS `total`, `p`.`discountPercentage` AS `discountPercentage`, round((((`p`.`price` * `f`.`quantity`) * (100 - `p`.`discountPercentage`)) / 100),0) AS `discountedPrice` FROM (`silver_f_cart` `f` join `silver_d_product` `p` on((`f`.`productId` = `p`.`productId`))) WHERE (`p`.`current` = true) ;

-- --------------------------------------------------------

--
-- Structure for view `gold_f_comment`
--
DROP TABLE IF EXISTS `gold_f_comment`;

DROP VIEW IF EXISTS `gold_f_comment`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_f_comment`  AS SELECT `f`.`commentId` AS `commentId`, `f`.`postId` AS `postId`, `f`.`userId` AS `userId`, `u`.`username` AS `username`, `p`.`title` AS `title`, `f`.`body` AS `body` FROM ((`silver_f_comment` `f` join `silver_f_post` `p` on((`f`.`postId` = `p`.`postId`))) join `silver_d_user` `u` on((`f`.`userId` = `u`.`userId`))) ;

-- --------------------------------------------------------

--
-- Structure for view `gold_f_post`
--
DROP TABLE IF EXISTS `gold_f_post`;

DROP VIEW IF EXISTS `gold_f_post`;
CREATE ALGORITHM=UNDEFINED DEFINER=`supernovaadmin01`@`%` SQL SECURITY DEFINER VIEW `gold_f_post`  AS SELECT `f`.`postId` AS `postId`, `f`.`userId` AS `userId`, `f`.`title` AS `title`, `f`.`body` AS `body`, `f`.`reactions` AS `reactions`, `f`.`tags` AS `tags` FROM `silver_f_post` AS `f` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
