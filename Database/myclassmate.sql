-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 05, 2024 at 01:40 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `degree`
--

CREATE TABLE `degree` (
  `idDegree` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `degree_subdegree`
--

CREATE TABLE `degree_subdegree` (
  `idDegree_subdegree` int(11) NOT NULL,
  `degree_idDegree` int(11) NOT NULL,
  `subdegree_idSubdegree` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `level`
--

CREATE TABLE `level` (
  `idLevel` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `online` tinyint(1) NOT NULL DEFAULT 1 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
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

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `idSubject` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `level_idLevel` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutor`
--

CREATE TABLE `tutor` (
  `user_idUser` int(11) NOT NULL,
  `asesoryCost` decimal(10,2) NOT NULL,
  `meanRating` decimal(3,2) NOT NULL,
  `online` tinyint(1) NOT NULL DEFAULT 1 CHECK (`online` in (0,1)),
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) NOT NULL DEFAULT 1 CHECK (`active` in (0,1))
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
-- Indexes for dumped tables
--

--
-- Indexes for table `college`
--
ALTER TABLE `college`
  ADD PRIMARY KEY (`idCollege`);

--
-- Indexes for table `degree`
--
ALTER TABLE `degree`
  ADD PRIMARY KEY (`idDegree`);

--
-- Indexes for table `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  ADD PRIMARY KEY (`idDegree_subdegree`),
  ADD KEY `fk_degree_subdegree_degree_idDegree` (`degree_idDegree`),
  ADD KEY `fk_degree_subdegree_subdegree_idSubdegree` (`subdegree_idSubdegree`);

--
-- Indexes for table `level`
--
ALTER TABLE `level`
  ADD PRIMARY KEY (`idLevel`);

--
-- Indexes for table `paymethod`
--
ALTER TABLE `paymethod`
  ADD PRIMARY KEY (`idPayMethod`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`idReview`),
  ADD KEY `fk_review_tutor_user_idUser` (`tutor_user_idUser`),
  ADD KEY `fk_review_student_user_idUser` (`student_user_idUser`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`idStatus`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD KEY `fk_student_user_idUser` (`user_idUser`);

--
-- Indexes for table `subdegree`
--
ALTER TABLE `subdegree`
  ADD PRIMARY KEY (`idSubdegree`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`idSubject`),
  ADD KEY `fk_subject_level_idLevel` (`level_idLevel`);

--
-- Indexes for table `tutor`
--
ALTER TABLE `tutor`
  ADD KEY `fk_tutor_user_idUser` (`user_idUser`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`),
  ADD KEY `fk_user_idDegree_subdegree` (`idDegree_subdegree`),
  ADD KEY `fk_user_college_idCollege` (`college_idCollege`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `college`
--
ALTER TABLE `college`
  MODIFY `idCollege` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `degree`
--
ALTER TABLE `degree`
  MODIFY `idDegree` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `degree_subdegree`
--
ALTER TABLE `degree_subdegree`
  MODIFY `idDegree_subdegree` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `level`
--
ALTER TABLE `level`
  MODIFY `idLevel` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paymethod`
--
ALTER TABLE `paymethod`
  MODIFY `idPayMethod` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `idReview` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `idStatus` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subdegree`
--
ALTER TABLE `subdegree`
  MODIFY `idSubdegree` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `idSubject` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `fk_review_student_user_idUser` FOREIGN KEY (`student_user_idUser`) REFERENCES `student` (`user_idUser`),
  ADD CONSTRAINT `fk_review_tutor_user_idUser` FOREIGN KEY (`tutor_user_idUser`) REFERENCES `tutor` (`user_idUser`);

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `fk_student_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

--
-- Constraints for table `subject`
--
ALTER TABLE `subject`
  ADD CONSTRAINT `fk_subject_level_idLevel` FOREIGN KEY (`level_idLevel`) REFERENCES `level` (`idLevel`);

--
-- Constraints for table `tutor`
--
ALTER TABLE `tutor`
  ADD CONSTRAINT `fk_tutor_user_idUser` FOREIGN KEY (`user_idUser`) REFERENCES `user` (`idUser`);

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
