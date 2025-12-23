-- MySQL dump 10.13  Distrib 8.0.44, for macos15 (arm64)
--
-- Host: localhost    Database: DatVeXe
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chuyenxe`
--

DROP TABLE IF EXISTS `chuyenxe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chuyenxe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tu_noi` int DEFAULT NULL,
  `den_noi` int DEFAULT NULL,
  `gio_khoi_hanh` datetime DEFAULT NULL,
  `gia` decimal(10,2) DEFAULT NULL,
  `so_cho` int DEFAULT NULL,
  `bien_so_xe` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nhaxe_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tu_noi` (`tu_noi`),
  KEY `den_noi` (`den_noi`),
  KEY `nhaxe_id` (`nhaxe_id`),
  CONSTRAINT `chuyenxe_diadiem_1` FOREIGN KEY (`tu_noi`) REFERENCES `diadiem` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chuyenxe_diadiem_2` FOREIGN KEY (`den_noi`) REFERENCES `diadiem` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chuyenxe_ibfk_3` FOREIGN KEY (`nhaxe_id`) REFERENCES `nhaxe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chuyenxe`
--

LOCK TABLES `chuyenxe` WRITE;
/*!40000 ALTER TABLE `chuyenxe` DISABLE KEYS */;
INSERT INTO `chuyenxe` VALUES (1,1,2,'2025-08-02 08:00:00',120000.00,38,'29A-12345',1),(2,3,4,'2025-08-03 22:00:00',250000.00,44,'51B-67890',2),(3,5,6,'2025-08-04 10:30:00',100000.00,30,'43C-11223',1),(4,1,7,'2025-08-05 07:00:00',180000.00,32,'29B-55667',3),(5,8,3,'2025-08-06 15:30:00',200000.00,50,'65A-99999',4),(6,6,5,'2025-08-07 09:00:00',90000.00,25,'75C-33445',3),(7,3,9,'2025-08-08 22:00:00',220000.00,39,'51F-88888',2),(8,2,10,'2025-12-31 13:30:00',150000.00,30,'15B-44556',1),(9,11,12,'2025-08-10 14:00:00',170000.00,38,'61A-77665',2),(10,13,14,'2025-12-25 06:00:00',195000.00,35,'47C-88990',4),(11,14,55,'2025-12-19 17:30:00',360000.00,36,'36A-36363',1),(12,3,6,'2025-08-01 09:30:00',190000.00,40,'36C-23942',3),(13,3,6,'2025-08-05 09:30:00',290000.00,0,'51C-23924',2),(15,15,49,'2025-12-30 12:30:00',300000.00,38,'43C-83877',4);
/*!40000 ALTER TABLE `chuyenxe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datxe`
--

DROP TABLE IF EXISTS `datxe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datxe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `chuyenxe_id` int DEFAULT NULL,
  `so_luong` int DEFAULT NULL,
  `ngay_dat` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chuyenxe_id` (`chuyenxe_id`),
  CONSTRAINT `datxe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `datxe_ibfk_2` FOREIGN KEY (`chuyenxe_id`) REFERENCES `chuyenxe` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datxe`
--

LOCK TABLES `datxe` WRITE;
/*!40000 ALTER TABLE `datxe` DISABLE KEYS */;
INSERT INTO `datxe` VALUES (1,1,1,2,'2025-08-01 14:09:19'),(2,2,2,1,'2025-08-01 14:09:19'),(3,1,3,3,'2025-08-01 14:09:19'),(4,3,4,1,'2025-08-01 14:09:19'),(5,4,5,2,'2025-08-01 14:09:19'),(6,5,6,4,'2025-08-01 14:09:19'),(7,6,7,2,'2025-08-01 14:09:19'),(8,1,8,1,'2025-08-01 14:09:19'),(9,2,5,3,'2025-08-01 14:09:19'),(10,3,6,2,'2025-08-01 14:09:19'),(11,4,3,1,'2025-08-01 14:09:19'),(12,5,2,1,'2025-08-01 14:09:19'),(13,6,1,1,'2025-08-01 14:09:19'),(14,7,9,2,'2025-08-01 14:09:19'),(15,8,10,1,'2025-08-01 14:09:19'),(16,9,11,3,'2025-08-01 14:09:19'),(17,10,2,1,'2025-08-01 14:09:19'),(18,3,9,1,'2025-08-01 14:09:19'),(19,13,1,2,'2025-08-01 22:24:55'),(20,13,11,2,'2025-08-01 22:35:57'),(21,14,10,1,'2025-08-01 22:55:20'),(22,13,4,1,'2025-08-01 22:58:57'),(23,13,4,1,'2025-08-02 11:34:45'),(24,15,4,1,'2025-08-02 11:36:12'),(25,13,2,1,'2025-08-02 12:21:25'),(26,13,7,1,'2025-08-02 12:54:54'),(27,13,11,1,'2025-08-02 14:03:41'),(28,18,15,1,'2025-08-02 16:09:43'),(29,15,15,1,'2025-08-02 16:15:08');
/*!40000 ALTER TABLE `datxe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diadiem`
--

DROP TABLE IF EXISTS `diadiem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diadiem` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ten_tinh` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diadiem`
--

LOCK TABLES `diadiem` WRITE;
/*!40000 ALTER TABLE `diadiem` DISABLE KEYS */;
INSERT INTO `diadiem` VALUES (1,'An Giang'),(2,'Bà Rịa - Vũng Tàu'),(3,'Bắc Giang'),(4,'Bắc Kạn'),(5,'Bạc Liêu'),(6,'Bắc Ninh'),(7,'Bến Tre'),(8,'Bình Định'),(9,'Bình Dương'),(10,'Bình Phước'),(11,'Bình Thuận'),(12,'Cà Mau'),(13,'Cần Thơ'),(14,'Cao Bằng'),(15,'Đà Nẵng'),(16,'Đắk Lắk'),(17,'Đắk Nông'),(18,'Điện Biên'),(19,'Đồng Nai'),(20,'Đồng Tháp'),(21,'Gia Lai'),(22,'Hà Giang'),(23,'Hà Nam'),(24,'Hà Nội'),(25,'Hà Tĩnh'),(26,'Hải Dương'),(27,'Hải Phòng'),(28,'Hậu Giang'),(29,'Hòa Bình'),(30,'Hưng Yên'),(31,'Khánh Hòa'),(32,'Kiên Giang'),(33,'Kon Tum'),(34,'Lai Châu'),(35,'Lâm Đồng'),(36,'Lạng Sơn'),(37,'Lào Cai'),(38,'Long An'),(39,'Nam Định'),(40,'Nghệ An'),(41,'Ninh Bình'),(42,'Ninh Thuận'),(43,'Phú Thọ'),(44,'Phú Yên'),(45,'Quảng Bình'),(46,'Quảng Nam'),(47,'Quảng Ngãi'),(48,'Quảng Ninh'),(49,'Quảng Trị'),(50,'Sóc Trăng'),(51,'Sơn La'),(52,'Tây Ninh'),(53,'Thái Bình'),(54,'Thái Nguyên'),(55,'Thanh Hóa'),(56,'Thừa Thiên Huế'),(57,'Tiền Giang'),(58,'TP. Hồ Chí Minh'),(59,'Trà Vinh'),(60,'Tuyên Quang'),(61,'Vĩnh Long'),(62,'Vĩnh Phúc'),(63,'Yên Bái');
/*!40000 ALTER TABLE `diadiem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nhaxe`
--

DROP TABLE IF EXISTS `nhaxe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nhaxe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ten_nhaxe` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dia_chi` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sdt` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nhaxe`
--

LOCK TABLES `nhaxe` WRITE;
/*!40000 ALTER TABLE `nhaxe` DISABLE KEYS */;
INSERT INTO `nhaxe` VALUES (1,'Nha Xe Sena','Thanh Hoa','0363636363'),(2,'Nha Xe Phung Thanh Do','120 Yen Lang','0999999999'),(3,'Nhà xe Mai Linh','789 Nguyễn Trãi, Đà Nẵng','0966666666'),(4,'Nhà xe Thành Bưởi','1010 Quang Trung, Cần Thơ','0955555555'),(5,'Nhà xe Hiếu Hoa','215 Tôn Đức Thắng, Đà Nẵng','0983866780');
/*!40000 ALTER TABLE `nhaxe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id_role` int NOT NULL,
  `name_role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'user'),(2,'admin');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role` (`role`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role`) REFERENCES `role` (`id_role`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Mai Anh Luân','a@gmail.com','123456','0569348348',2),(2,'Trần Hà Linh','b@gmail.com','abcdef','0569348348',1),(3,'Duong Minh C','c@gmail.com','qwerty','0933456789',1),(4,'Nguyễn Thanh Liêm','d@gmail.com','password','0569343412',1),(5,'Linh Tây','e@gmail.com','letmein','0569348348',1),(6,'Yua Mikami','f@gmail.com','123abc','0966789012',1),(7,'Miu Shiromine','g@gmail.com','123456','0901122334',1),(8,'Bui Thi H','h@gmail.com','abcdef','0912233445',1),(9,'Ly Van I','i@gmail.com','zxcvbn','0923344556',1),(10,'Độ Bikini','dat@gmail.com','111111','0934455667',1),(13,'Hà Văn Toàn','luongvanvo29@gmail.com','voluong','0865321921',1),(14,'Việt Cửu Lục','nguyennguyendangbao8@gmail.com','baonguyen','0392663097',2),(15,'Trần Hà Linh','vohocgioi@gmail.com','baonguyen','0392663097',1),(18,'Ngọc Anh','anh1306@gmail.com','123456','0987451422',1),(19,'Ha Linh','l@gmail.com','123123','0569015738',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12 12:53:29
