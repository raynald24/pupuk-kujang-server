-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 08, 2025 at 05:33 AM
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
-- Database: `auth_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `analysisresult`
--

CREATE TABLE `analysisresult` (
  `id` int(11) NOT NULL,
  `sampleId` int(11) NOT NULL,
  `parameterId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `parameterInputId` int(11) NOT NULL,
  `hasilPerhitungan` float DEFAULT NULL,
  `tanggalAnalisa` datetime NOT NULL,
  `analisaNumber` varchar(255) NOT NULL,
  `publishAnalisa` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `namabahan`
--

CREATE TABLE `namabahan` (
  `id` int(11) NOT NULL,
  `namaBahan` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `namabahan`
--

INSERT INTO `namabahan` (`id`, `namaBahan`, `createdAt`, `updatedAt`) VALUES
(1, 'H2SO4', '2025-04-30 14:52:55', '2025-04-30 14:52:55'),
(2, 'NaOH', '2025-04-30 14:52:55', '2025-04-30 14:52:55'),
(3, 'Clay', '2025-04-30 14:52:55', '2025-04-30 14:52:55');

-- --------------------------------------------------------

--
-- Table structure for table `parameter`
--

CREATE TABLE `parameter` (
  `id` int(11) NOT NULL,
  `namaBahanId` int(11) NOT NULL,
  `namaParameter` varchar(255) NOT NULL,
  `rumus` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parameter`
--

INSERT INTO `parameter` (`id`, `namaBahanId`, `namaParameter`, `rumus`, `createdAt`, `updatedAt`) VALUES
(14, 1, 'Kadar H2SO4', '([V1] * [N1] * 49 * [fp] / ([BS1]*1000))*100', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(15, 1, 'Fe', 'Input Hasil Manual', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(16, 1, 'Organic Matter', '[V2] * [N2] * 31.6 * 1000 / [BS2]', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(17, 1, 'Turbidity 4% Larutan', 'Input Hasil Manual', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(18, 2, 'Kadar NaOH', '(V * N * 40 * Fp / [BS] * 1000) * 100', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(19, 2, 'Fe', 'Input Hasil Manual', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(20, 2, 'SiO2', 'Input Hasil Manual', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(21, 3, 'H2O', 'Sudah', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(22, 3, 'Tertahan di Mesh 100', '(100/[BS1])*[BS2]', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(23, 3, 'Pan', '100 - [Tertahan di Mesh 100]', '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(24, 3, 'Kelengketan', 'Enum(Lengket/Tidak Lengket)', '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `parameterinput`
--

CREATE TABLE `parameterinput` (
  `id` int(11) NOT NULL,
  `sampleId` int(11) NOT NULL,
  `parameterId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `v1` float DEFAULT NULL,
  `v2` float DEFAULT NULL,
  `v3` float DEFAULT NULL,
  `faktorPengenceran` float DEFAULT NULL,
  `bobotKosong` float DEFAULT NULL,
  `bobotSampel` float DEFAULT NULL,
  `bobotSetelahPemanasan` float DEFAULT NULL,
  `hasil` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sample`
--

CREATE TABLE `sample` (
  `id` int(11) NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `userId` int(11) NOT NULL,
  `namaUnitPemohon` varchar(255) NOT NULL,
  `tanggalSurat` datetime NOT NULL,
  `nomorPO` varchar(255) NOT NULL,
  `nomorSurat` varchar(255) NOT NULL,
  `status` enum('pending','complete','cancelled') NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `namaBahanId` int(11) NOT NULL,
  `noKendaraan` varchar(255) DEFAULT NULL,
  `isiBerat` float DEFAULT NULL,
  `jumlahContoh` int(11) DEFAULT NULL,
  `noKodeContoh` varchar(255) DEFAULT NULL,
  `noSuratPOK` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sample`
--

INSERT INTO `sample` (`id`, `uuid`, `userId`, `namaUnitPemohon`, `tanggalSurat`, `nomorPO`, `nomorSurat`, `status`, `createdAt`, `updatedAt`, `namaBahanId`, `noKendaraan`, `isiBerat`, `jumlahContoh`, `noKodeContoh`, `noSuratPOK`) VALUES
(29, '663ad84a-9652-4827-b01f-978a5b72f0cd', 1, 'Unit B', '2025-04-30 00:00:00', 'PO4321', 'SURAT4321', 'pending', '2025-04-30 08:55:08', '2025-04-30 08:55:08', 3, 'PW 1234 PW', 1, 2, 'PW1234', 'Pw1234'),
(30, 'ada33b80-09cd-4856-9df9-4247f0ae59fa', 1, 'Unit A', '2025-05-06 00:00:00', 'PO8887', 'SURAT8887', 'pending', '2025-05-06 07:39:14', '2025-05-06 07:39:14', 1, 'PW 4321 PW', 2, 2, 'PW4321', 'PW4321'),
(31, '0460cb79-abee-451f-8abc-adfd87a42035', 1, 'Unit F', '2025-05-07 00:00:00', 'PO3333', 'Surat 333', 'complete', '2025-05-07 06:50:34', '2025-05-07 06:50:41', 2, 'PW 4321 PW', 2, 3, 'PW3333', 'PE3333');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `sid` varchar(36) NOT NULL,
  `expires` datetime DEFAULT NULL,
  `data` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`sid`, `expires`, `data`, `createdAt`, `updatedAt`) VALUES
('4pyOncOmImlcPqvUxHAS1Fn4HNgCdyou', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('AdxfPzKUjTSfQNrkNDf168gX_I-oE6yY', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('c7uREhiX9vypbnoIxCmWlwMX3EtLwKFF', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('h6DazAaI_V9CGEHPXnymp3ZkbcVe4XhQ', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('huC1cequNmyHYyPuW_tjOp1K-Eu-kWa1', '2025-05-08 06:50:34', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-07 06:50:34', '2025-05-07 06:50:34'),
('j0VZObwa4V_sx_NKbI6cXXjgMr9rXUI1', '2025-05-08 06:50:41', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-07 06:50:41', '2025-05-07 06:50:41'),
('m8sdbrPr4fyZHdz60HZMladhfmkYV-gy', '2025-05-08 09:04:43', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"userId\":\"dc0a13f3-8040-4c0d-acbb-6e9c59156c0e\"}', '2025-05-06 01:07:28', '2025-05-07 09:04:43'),
('mSXR6pX3an1WL4sXYexrnbLq-sLOkoos', '2025-05-09 01:18:03', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:18:03', '2025-05-08 01:18:03'),
('pppGaJ8-E7IG-NpUPFCOPtqk8lXzD9O6', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('RTrIxrg-YBp3xUogs4p22Jkq9oyTyV-g', '2025-05-09 03:29:46', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"userId\":\"dc0a13f3-8040-4c0d-acbb-6e9c59156c0e\"}', '2025-05-08 01:17:59', '2025-05-08 03:29:46'),
('VDnSPk1VoCm-CtKo2aFsxOmfz4JUBcQv', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59'),
('z_aUn2Ar-IdQLLC4P3GxuQwFTge6XfXS', '2025-05-09 01:17:59', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"}}', '2025-05-08 01:17:59', '2025-05-08 01:17:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `uuid`, `name`, `email`, `password`, `role`, `createdAt`, `updatedAt`) VALUES
(1, 'dc0a13f3-8040-4c0d-acbb-6e9c59156c0e', 'Ray updated', 'Ray@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$lfjqOs/SDw8ko+C2hxkaDg$/Inw/CtQcUr+m+mVWjd0Tqb6mQMpX9psLBfbFcF4l4w', 'admin', '2025-02-19 06:49:27', '2025-04-08 14:00:35'),
(5, '434b399e-11f2-490d-aab0-eb506281415c', 'Indah', 'indah@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$7vfru1HPY5Dg8pvX6huKRA$duztX55b/erOwwZatcz3vdygQoeACoJk4+1GpLAW/1U', 'user', '2025-02-25 03:41:08', '2025-02-25 03:41:08'),
(14, '6044993d-aae6-4fe9-965d-90c9e2712e26', 'andrew', 'andrew@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$8qQE270jg39YI60BDFQ58w$u14Gsl5gaIiTeZ24Lal+4UKNh4k66UNkcE850O0fOrE', 'user', '2025-04-23 12:01:36', '2025-04-23 12:01:36'),
(15, 'f138d8d2-a831-4b96-aa6e-d7b9767e93dc', 'ester', 'ess@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$hKx5KQ+jtT60k6glXuRTnw$TjH+cD21Wl7b+Y+1zVCkm93QECoWWPCUEW4B795Fg0s', 'user', '2025-04-25 05:31:03', '2025-04-25 05:31:03'),
(16, '5923f647-d77b-4e4f-9f21-f4f63420d20c', 'aldo', 'aldo@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$fV/UOJzr/rfEFBQtou0bKA$qDIWD/xawlrbkHOt7ynSAZV0fuU4YKmqeoiWv4MOVHc', 'user', '2025-04-25 05:32:53', '2025-04-25 05:32:53'),
(17, '7208aa84-49b1-4e5a-8138-122eaac306dd', 'aldi', 'aldi@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$elZGevX4rWLkP1X5KIP18g$DlgMyKP7bXiSdrIu83nHyf4RYnfBOPGToqERb2CJCDk', 'user', '2025-04-25 05:33:14', '2025-04-25 05:33:14'),
(18, '254da0c1-43d2-43b3-9dc2-7e6a6e4d7219', 'ani', 'ani@gmail.com', '$argon2id$v=19$m=65536,t=3,p=4$FTGXMniwLGWeDVwpSNk7Fw$Ksocj7bWY8K+sD0CgdOzDXaPB4kgUGuvUtmJrQJAWNs', 'user', '2025-04-25 05:33:36', '2025-04-25 05:33:36');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `analysisresult`
--
ALTER TABLE `analysisresult`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sampleId` (`sampleId`),
  ADD KEY `parameterId` (`parameterId`),
  ADD KEY `parameterInputId` (`parameterInputId`);

--
-- Indexes for table `namabahan`
--
ALTER TABLE `namabahan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parameter`
--
ALTER TABLE `parameter`
  ADD PRIMARY KEY (`id`),
  ADD KEY `namaBahanId` (`namaBahanId`);

--
-- Indexes for table `parameterinput`
--
ALTER TABLE `parameterinput`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sampleId` (`sampleId`),
  ADD KEY `parameterId` (`parameterId`);

--
-- Indexes for table `sample`
--
ALTER TABLE `sample`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `namaBahanId` (`namaBahanId`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`sid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `analysisresult`
--
ALTER TABLE `analysisresult`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `namabahan`
--
ALTER TABLE `namabahan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `parameter`
--
ALTER TABLE `parameter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `parameterinput`
--
ALTER TABLE `parameterinput`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sample`
--
ALTER TABLE `sample`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `analysisresult`
--
ALTER TABLE `analysisresult`
  ADD CONSTRAINT `AnalysisResult_parameterInputId_foreign_idx` FOREIGN KEY (`parameterInputId`) REFERENCES `parameterinput` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_1` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_10` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_11` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_12` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_13` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_14` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_15` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_16` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_17` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_18` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_19` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `analysisresult_ibfk_2` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_20` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `analysisresult_ibfk_21` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `analysisresult_ibfk_22` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `analysisresult_ibfk_23` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_24` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_25` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_26` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_27` FOREIGN KEY (`parameterInputId`) REFERENCES `parameterinput` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_28` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_29` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_3` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_30` FOREIGN KEY (`parameterInputId`) REFERENCES `parameterinput` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_31` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_32` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_33` FOREIGN KEY (`parameterInputId`) REFERENCES `parameterinput` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_4` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_5` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_6` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_7` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_8` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `analysisresult_ibfk_9` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `parameter`
--
ALTER TABLE `parameter`
  ADD CONSTRAINT `parameter_ibfk_1` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_10` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_11` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_12` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_13` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_14` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_15` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_16` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_17` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_18` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_19` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_2` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_20` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_21` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_22` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_23` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_24` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_25` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_26` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_27` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_28` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_29` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_3` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_30` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_31` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_32` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_33` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_34` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_4` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_5` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_6` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_7` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_8` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameter_ibfk_9` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `parameterinput`
--
ALTER TABLE `parameterinput`
  ADD CONSTRAINT `parameterinput_ibfk_1` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_10` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_11` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_12` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_13` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_14` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_15` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_16` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_17` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_18` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_19` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_2` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_20` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_21` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_22` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_23` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_24` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_25` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_26` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_27` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_28` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_29` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_3` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_30` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`),
  ADD CONSTRAINT `parameterinput_ibfk_4` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_5` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_6` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_7` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_8` FOREIGN KEY (`parameterId`) REFERENCES `parameter` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `parameterinput_ibfk_9` FOREIGN KEY (`sampleId`) REFERENCES `sample` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `sample`
--
ALTER TABLE `sample`
  ADD CONSTRAINT `Sample_namaBahanId_foreign_idx` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_10` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_12` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_14` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_16` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_18` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_2` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_20` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_22` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_24` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_26` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_28` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_30` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_32` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_34` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_36` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_38` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_4` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_40` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_42` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_44` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_46` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_48` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_50` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_52` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_54` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_56` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_58` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_59` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_6` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_60` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sample_ibfk_8` FOREIGN KEY (`namaBahanId`) REFERENCES `namabahan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
