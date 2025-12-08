-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Generation Time: Dec 08, 2025 at 07:43 AM
-- Server version: 10.6.20-MariaDB-ubu2004
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `x`
--

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `comment_pk` char(32) NOT NULL,
  `comment_user_fk` char(32) NOT NULL,
  `comment_post_fk` char(32) NOT NULL,
  `comment_message` varchar(280) NOT NULL,
  `comment_created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `comment_deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`comment_pk`, `comment_user_fk`, `comment_post_fk`, `comment_message`, `comment_created_at`, `comment_deleted_at`) VALUES
('097eaca5c0124f02a0bf3bc1dfce3f16', 'db54bf983ede476fa4ac4930d1267ca9', '79d96e90734f47f28a80f48886242d40', 'stop', '2025-12-07 11:46:39', NULL),
('243caece91f44c9ca518de454d50e770', '486426e9b9d54219a85e509527a06363', '99fefea24ea5419da19ed1f8cf8e9499', 'tsf', '2025-12-07 11:31:14', NULL),
('3b5502b603d248c9bcfd4b2f703101cd', 'db54bf983ede476fa4ac4930d1267ca9', 'e40967338e8c466985dbde4e3f9c712a', 'ok bad test', '2025-12-07 17:50:18', NULL),
('7f968503811c4cf9bc8af742fd4d5cc9', 'd54dbfbf482744e59fc407f94529d55e', '2126589cc85a4dd79177fdbc984bde0f', 'i love this post dogg', '2025-12-07 19:16:04', NULL),
('8f1c5693067847d7b5281c867bd49f03', '486426e9b9d54219a85e509527a06363', '23a6fd4b34d7448ea6c7b519755e7aa5', 'delete please', '2025-12-04 14:17:35', NULL),
('93b8a99f67194276a09600ecdbb191d1', 'db54bf983ede476fa4ac4930d1267ca9', '6f52e919368d4d56b41c518474d858e0', 'very nice', '2025-12-07 19:27:55', NULL),
('be71beb89a914ad18b579bfc49170437', '486426e9b9d54219a85e509527a06363', 'b8f59662ce5b4b58bf19a5fe0eda3122', 'cru', '2025-12-07 10:59:03', NULL),
('f2c45d6e151f437b9fe228564b27a131', 'db54bf983ede476fa4ac4930d1267ca9', 'c36a2581789142809dfbe4c875022de7', 'bad post', '2025-12-07 17:50:06', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `follows`
--

CREATE TABLE `follows` (
  `follow_pk` char(32) NOT NULL,
  `follow_follower_fk` char(32) NOT NULL,
  `follow_following_fk` char(32) NOT NULL,
  `follow_created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `follow_deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `follows`
--

INSERT INTO `follows` (`follow_pk`, `follow_follower_fk`, `follow_following_fk`, `follow_created_at`, `follow_deleted_at`) VALUES
('052da5d72ab746558eb7ac2a7b136b95', '6b48c6095913402eb4841529830e5415', '8873bb59d52d461981e8ffc2647e0482', '2025-11-29 20:15:40', '2025-11-29 20:18:18'),
('0dc86febbad2454cbce49c7a15d600df', 'd54dbfbf482744e59fc407f94529d55e', 'db54bf983ede476fa4ac4930d1267ca9', '2025-12-07 19:25:58', NULL),
('225b0d226082430ebe67233cf0a88446', '77eeba6e07394d8a89f08bc41fec91b2', '88a93bb5267e443eb0047f421a7a2f34', '2025-12-02 09:41:52', NULL),
('22df6ef9dd29499686d79fed6f430cc3', '486426e9b9d54219a85e509527a06363', '8873bb59d52d461981e8ffc2647e0482', '2025-12-04 13:53:32', '2025-12-04 13:53:32'),
('302451c4e01b4a149400ed49f5962940', '8af38d2708d54057b5b5244d67f5a548', '225a9fc15b8f409aa5c8ee7eafee516b', '2025-12-03 10:58:00', '2025-12-03 10:58:00'),
('505cb5c1065e4977ae44ccde2419b73d', 'db54bf983ede476fa4ac4930d1267ca9', '21e66977ccb74fdbb6cbdb3e7e3a12cb', '2025-12-07 12:50:26', '2025-12-07 12:50:27'),
('5b1d29084ae34c619661810853d7b1cf', 'd54dbfbf482744e59fc407f94529d55e', '486426e9b9d54219a85e509527a06363', '2025-12-07 19:15:55', NULL),
('646d850686b54b0fbf63445cd364235b', '6b48c6095913402eb4841529830e5415', '59ac8f8892bc45528a631d4415151f13', '2025-11-29 20:34:33', '2025-11-29 20:34:35'),
('6921c1bc50274409a0f789564eb1c8d8', '77eeba6e07394d8a89f08bc41fec91b2', '225a9fc15b8f409aa5c8ee7eafee516b', '2025-12-02 09:41:53', NULL),
('79657e6ec72e4ccebe0dfff3cf80f931', 'db54bf983ede476fa4ac4930d1267ca9', '486426e9b9d54219a85e509527a06363', '2025-12-07 17:50:20', NULL),
('b427737a7add4f5880a4bafe135f6713', 'd54dbfbf482744e59fc407f94529d55e', '225a9fc15b8f409aa5c8ee7eafee516b', '2025-12-07 19:25:58', NULL),
('d1225663689c400e9176c2403c09983f', '6b48c6095913402eb4841529830e5415', '88a93bb5267e443eb0047f421a7a2f34', '2025-11-29 20:21:47', '2025-11-29 20:21:48'),
('dd1a2525b76c4fab96b517e0e9fc8bbc', '6b48c6095913402eb4841529830e5415', '805a39cd8c854ee8a83555a308645bf5', '2025-12-02 08:33:14', '2025-12-02 08:33:14'),
('f6efdb1958334c329b2e9cbfa01ff6ec', '6b48c6095913402eb4841529830e5415', '21e66977ccb74fdbb6cbdb3e7e3a12cb', '2025-12-02 08:33:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `like_user_fk` char(32) NOT NULL,
  `like_post_fk` char(32) NOT NULL,
  `like_created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `like_deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`like_user_fk`, `like_post_fk`, `like_created_at`, `like_deleted_at`) VALUES
('486426e9b9d54219a85e509527a06363', '99fefea24ea5419da19ed1f8cf8e9499', '2025-12-07 11:31:11', NULL),
('486426e9b9d54219a85e509527a06363', 'b8f59662ce5b4b58bf19a5fe0eda3122', '2025-12-07 10:59:04', NULL),
('6b48c6095913402eb4841529830e5415', '1e5ecc804e1f46bc8e723437bf4bfc4b', '2025-11-27 20:54:49', NULL),
('6b48c6095913402eb4841529830e5415', '221b816a7f2f45e1bdeaf9d63031ebcc', '2025-12-02 08:33:07', NULL),
('6b48c6095913402eb4841529830e5415', '3f534678ba324c3aa2624c1f118573f7', '2025-11-27 20:52:30', NULL),
('d54dbfbf482744e59fc407f94529d55e', '2126589cc85a4dd79177fdbc984bde0f', '2025-12-07 19:15:58', NULL),
('d54dbfbf482744e59fc407f94529d55e', '9320138cf0ee429b96a90f492c364207', '2025-12-07 19:16:06', NULL),
('db54bf983ede476fa4ac4930d1267ca9', '0a24f95f7db84e70b018003241e3c812', '2025-12-07 17:49:38', NULL),
('db54bf983ede476fa4ac4930d1267ca9', '6f52e919368d4d56b41c518474d858e0', '2025-12-07 19:27:52', NULL),
('db54bf983ede476fa4ac4930d1267ca9', '79d96e90734f47f28a80f48886242d40', '2025-12-07 11:46:36', NULL),
('db54bf983ede476fa4ac4930d1267ca9', 'bf3bbaf46d694e5288201f19894f1ef0', '2025-12-07 17:50:46', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_pk` char(32) NOT NULL,
  `post_user_fk` char(32) NOT NULL,
  `post_message` varchar(280) NOT NULL,
  `post_total_likes` bigint(20) UNSIGNED NOT NULL,
  `post_image_path` varchar(255) NOT NULL,
  `post_deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_pk`, `post_user_fk`, `post_message`, `post_total_likes`, `post_image_path`, `post_deleted_at`) VALUES
('0a24f95f7db84e70b018003241e3c812', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('0d8791a573c54a2c8d28030d8aa1d07d', '77eeba6e07394d8a89f08bc41fec91b2', 'hello my first post!', 0, '', NULL),
('14b6d9812e814497b23b689d0130483d', '486426e9b9d54219a85e509527a06363', 'WHEN DELETED IS THIS SHOWN?', 0, '', '2025-12-04 14:07:29'),
('184695b2bdf6460e90cf3cd7d6cfd54d', '8873bb59d52d461981e8ffc2647e0482', 'does you work', 1, '', NULL),
('1e5ecc804e1f46bc8e723437bf4bfc4b', '225a9fc15b8f409aa5c8ee7eafee516b', 'And this just works!', 1, 'post_3.jpg', NULL),
('2126589cc85a4dd79177fdbc984bde0f', 'db54bf983ede476fa4ac4930d1267ca9', 'i would like my own post', 0, '', NULL),
('221b816a7f2f45e1bdeaf9d63031ebcc', '8873bb59d52d461981e8ffc2647e0482', 'test post', 0, '', NULL),
('23a6fd4b34d7448ea6c7b519755e7aa5', '486426e9b9d54219a85e509527a06363', 'dsa', 0, '', '2025-12-04 14:19:48'),
('258aeac7242348058c8c36f025b10fd5', '225a9fc15b8f409aa5c8ee7eafee516b', 'tes5', 1, '', NULL),
('28dd4c1671634d73acd29a0ab109bef1', '805a39cd8c854ee8a83555a308645bf5', 'My first super life !', 1, 'post_3.jpg', NULL),
('299323cf81924589b0de265e715a1f9e', '225a9fc15b8f409aa5c8ee7eafee516b', 'test3', 1, 'post_1.jpg', NULL),
('2c478cd6841749e6851c630931ac022b', '486426e9b9d54219a85e509527a06363', 'detete', 0, '', NULL),
('323ec3f20fcf4f5a8a86967a12dc994b', '486426e9b9d54219a85e509527a06363', 'detete', 0, '', '2025-12-04 14:20:21'),
('3cb78d73518c4c01a29ad33d196ce962', '225a9fc15b8f409aa5c8ee7eafee516b', 'This is new', 0, '', NULL),
('3e4f0c3ab65344d8b79c849400418758', '225a9fc15b8f409aa5c8ee7eafee516b', 'test1', 1, '', NULL),
('3f534678ba324c3aa2624c1f118573f7', '6b48c6095913402eb4841529830e5415', 'dfdfd', 0, '', NULL),
('4c6faa50672a484f9dd19f9388a196d9', '486426e9b9d54219a85e509527a06363', '12345IKKKSS', 0, '', NULL),
('4e77d92e2b6040cbb194b937d395fab7', '486426e9b9d54219a85e509527a06363', 'delete', 0, '', '2025-12-04 14:20:36'),
('50293af4d1f64798af9b7dfcbf5ed3e7', '225a9fc15b8f409aa5c8ee7eafee516b', 'new', 1, '', NULL),
('5a4f663798ef4694ac13dfe2c61d8e88', 'db54bf983ede476fa4ac4930d1267ca9', 'i love posting', 0, '', NULL),
('5b147eb4f0064bd9be7f18e6be2b3347', '225a9fc15b8f409aa5c8ee7eafee516b', 'First great test', 1, '', NULL),
('616c38c6e9e14406a92439e2d81490fc', '225a9fc15b8f409aa5c8ee7eafee516b', 'A browser', 0, '', NULL),
('63ed90b8cafc47fa9a3253fa1ecfeb04', '225a9fc15b8f409aa5c8ee7eafee516b', 'this', 1, '', NULL),
('69d3ed14f15047139b6cd8bd8180c104', '59ac8f8892bc45528a631d4415151f13', 'This is Daniel\'s post', 1, '', NULL),
('6b7bc6fd2b57486db21325030f63fd90', '6b48c6095913402eb4841529830e5415', 'erere', 1, '', NULL),
('6bae1e557dc841298bb88750a7926bc7', 'db54bf983ede476fa4ac4930d1267ca9', 'hahah', 0, '', NULL),
('6f301f6e820b43559821db8be9da02fc', '486426e9b9d54219a85e509527a06363', 'ss', 0, '', '2025-12-04 14:05:03'),
('6f52e919368d4d56b41c518474d858e0', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('762dc4750c624811943e42feed51b5ce', '486426e9b9d54219a85e509527a06363', 'tetete', 0, '', '2025-12-04 14:22:43'),
('76b24d5b62e0478f882a36436ce4f0c0', '486426e9b9d54219a85e509527a06363', 'stomach', 0, '', NULL),
('79c5470b54da40f5ac19729738b37a38', '6b48c6095913402eb4841529830e5415', 'dfdfd', 1, '', NULL),
('79d96e90734f47f28a80f48886242d40', '486426e9b9d54219a85e509527a06363', 'de,etodsa', 0, '', '2025-12-07 13:22:51'),
('7a1cf7fa71ee45a9ba2d83971b687f31', '486426e9b9d54219a85e509527a06363', 'stop man', 0, '', NULL),
('7d6f40e626c54efaa32494bce5f739d7', '88a93bb5267e443eb0047f421a7a2f34', 'test', 0, 'post_2.jpg', NULL),
('8357c3630cb34a79b0953922d530fa16', '486426e9b9d54219a85e509527a06363', 'chill man', 0, '', NULL),
('84d9bf6c948b4943a6e7eb4ce4030295', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('87aa4b8052a84bc8989e417b38f44116', '486426e9b9d54219a85e509527a06363', 'hahah img', 0, '', '2025-12-07 11:50:07'),
('9217f5dbc9fe4178bd290a69d23db061', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('9320138cf0ee429b96a90f492c364207', '486426e9b9d54219a85e509527a06363', 'NICE ÅPOST', 0, '', NULL),
('93985b38ff484e4db29224a56df1b70e', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('96f78dd3aae445deab6891e947ac5e3b', '486426e9b9d54219a85e509527a06363', 'fuck ai but i love it', 0, '', '2025-12-07 12:16:51'),
('991ba7fa40af4d3da8b2d57981efbb64', '486426e9b9d54219a85e509527a06363', 'WHAT IS ESCAPÅE', 0, '', NULL),
('99fefea24ea5419da19ed1f8cf8e9499', '225a9fc15b8f409aa5c8ee7eafee516b', 'wow', 1, 'post_1.jpg', NULL),
('9bddfa16026f4802ba0cf3352701be13', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('9ef88a3383fd4f5a8472bab7b995899e', '486426e9b9d54219a85e509527a06363', 'hello i keep posting for the love', 0, '', '2025-12-07 11:50:04'),
('ad95e1d3f62f4d07b7bf9e3e6d4dd527', '225a9fc15b8f409aa5c8ee7eafee516b', 'And this just works!', 0, '', NULL),
('ae3a8c2319894a778dd1d86a96f040ab', '486426e9b9d54219a85e509527a06363', 'ghello', 0, '', '2025-12-04 14:13:37'),
('aeed8499d0d149dbb8135d8e098df6a9', '486426e9b9d54219a85e509527a06363', 'AFRAID', 0, '', NULL),
('b4b23963a6a4479e918e66f47baef200', '225a9fc15b8f409aa5c8ee7eafee516b', 'test1', 0, '', NULL),
('b8f59662ce5b4b58bf19a5fe0eda3122', '225a9fc15b8f409aa5c8ee7eafee516b', 'test2', 1, '', NULL),
('bcaa6df8880e411a9c25deaafae2314a', '225a9fc15b8f409aa5c8ee7eafee516b', 'test4', 0, '', NULL),
('bf3bbaf46d694e5288201f19894f1ef0', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('c36a2581789142809dfbe4c875022de7', '486426e9b9d54219a85e509527a06363', 'stop', 0, '', NULL),
('c7b70a674e1f484591e077d903bbf400', '486426e9b9d54219a85e509527a06363', 'sadsa', 0, '', '2025-12-04 14:17:40'),
('cf1516d0c461483b8eccead4a4f62191', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('dcc65f09151846248841d4b18af1a0e4', '486426e9b9d54219a85e509527a06363', 'tete', 0, '', '2025-12-04 14:20:27'),
('e3870d2c45bd47d897c133d79bd6097f', '486426e9b9d54219a85e509527a06363', 'ssdsa', 0, '', '2025-12-04 14:16:03'),
('e40967338e8c466985dbde4e3f9c712a', '225a9fc15b8f409aa5c8ee7eafee516b', 'Testing', 0, '', NULL),
('e553b00176624271a6a78aca4b281c4d', '486426e9b9d54219a85e509527a06363', 'delete new', 0, '', '2025-12-04 14:14:07'),
('ec51c7c1f03046c1bd5e42481f93d03c', '486426e9b9d54219a85e509527a06363', 'sadsd', 0, '', '2025-12-04 14:15:18'),
('efaf8b6f98be4a7b8cc7a75d0f83578c', '225a9fc15b8f409aa5c8ee7eafee516b', 'test', 0, '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trends`
--

CREATE TABLE `trends` (
  `trend_pk` char(32) NOT NULL,
  `trend_title` varchar(100) NOT NULL,
  `trend_message` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trends`
--

INSERT INTO `trends` (`trend_pk`, `trend_title`, `trend_message`) VALUES
('6543c995d1af4ebcbd5280a4afaa1e2c', 'Politics are rotten', 'Everyone talks and only a few try to do something'),
('8343c995d1af4ebcbd5280a6afaa1e2d', 'New rocket to the moon', 'A new rocket has been sent towards the moon, but id didn\'t make it');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_pk` char(32) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_username` varchar(20) NOT NULL,
  `user_first_name` varchar(20) NOT NULL,
  `user_last_name` varchar(20) NOT NULL DEFAULT '',
  `user_avatar_path` varchar(255) DEFAULT NULL,
  `user_verification_key` char(32) NOT NULL,
  `user_password_reset_key` char(32) NOT NULL DEFAULT '',
  `user_verified_at` bigint(20) UNSIGNED NOT NULL,
  `isadmin` tinyint(1) NOT NULL DEFAULT 0,
  `isblocked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_pk`, `user_email`, `user_password`, `user_username`, `user_first_name`, `user_last_name`, `user_avatar_path`, `user_verification_key`, `user_password_reset_key`, `user_verified_at`, `isadmin`, `isblocked`) VALUES
('21e66977ccb74fdbb6cbdb3e7e3a12cb', 'daniel@gmail.com', 'scrypt:32768:8:1$OSL1Z4fWygxh9s2t$c5404c596d389e4fc1fc36a2853ee5f662ab4903476210424a325c50fa7ac64729716f3156687d789c6d895b9876ef069ced40e0e84a7372ca758ffa3a692960', 'daniel', 'Daniel', '', NULL, 'c29fa5894f224964953801c925a7cac5', '', 0, 0, 0),
('225a9fc15b8f409aa5c8ee7eafee516b', 'a@aaa.com', 'scrypt:32768:8:1$wnse70hQwhCvR9tC$724c32a91b5f277201afbb141f9293a93168327df5c9124f482d3c32b8dff991c41629f477dfaee021965f9b15318a4257aad2e933101a4c998ef3c346fc84e4', 'santisss', 'Tester', '', NULL, '', '', 455656, 0, 0),
('486426e9b9d54219a85e509527a06363', 'philipjuhl554@gmail.com', 'scrypt:32768:8:1$GpKOG3y1sqWJZsDe$b0e7d05b02993e3cf6d3addd40fee7ff193fc93f84706e2b430527b5dbbe16c057ffeefae8f7896a853cebe25c7809c2cefc52db5ef306110c4edb8fa4a7ca1f', 'Mr magic', 'Philip', '', 'uploads/avatars/486426e9b9d54219a85e509527a06363.png', '', '', 1764846420, 0, 0),
('59ac8f8892bc45528a631d4415151f13', 'terese@gmail.com', 'scrypt:32768:8:1$Tq056RbRH27Mc9g3$84810a2576e4828498be40c7f51f33e59d19d136e0c5c12e31fb676f3141934c639e088530f9be4ce682cbdfd4eaec34e1220fa7121bf8779e7de0bff29115b9', 'Mily', 'Mille', '', NULL, '', '', 45665656, 0, 0),
('6b48c6095913402eb4841529830e5415', 'a@a.com', 'scrypt:32768:8:1$rRjuDGIwaA31YlPi$f73f9a059fb3757ba6724d9c94e2a192d8b8d59fcd18d7b11c57e508f1b9cfb94bb7c6fd4f8d632b777e31cd47aef9c95adcad2451786cbb7e7c073fe8cbaf3a', 'Fortnite', 'John', '', NULL, '', '', 45445, 0, 0),
('805a39cd8c854ee8a83555a308645bf5', 'fullflaskdemomail@gmail.com', 'scrypt:32768:8:1$VlBgiW1xFsZuKRML$a5f61d62ac3f45d42c58cf8362637e717793b8760f026b1b47b7bfec47037abbe13e1c20e8bdc66fc03cc153d0bcf6185e15cf25ad58eb9d344267882dd7e78c', 'santiago', 'Santiago', '', 'avatar_3.jpg', '', '', 565656, 0, 0),
('88a93bb5267e443eb0047f421a7a2f34', 'santi@gmail.com', 'scrypt:32768:8:1$PEIO0eliDPqnCCbw$acb791128831bc90030ac363e4b76db196689bd99c1ccde5c2c20a7d4fe909e07129f3f4fd4f086e347375edbb8229e9ba5dc126cc14f6107fb1fc2abf6498f8', 'gustav', 'Gustav', '', NULL, '', '', 54654564, 0, 0),
('d54dbfbf482744e59fc407f94529d55e', 'philipm@hotmail.dk', 'scrypt:32768:8:1$29fbGVDJSX9rAcoz$253d1cb3f0d269933f35fb939f174b78bea37cacbbfcd3801b6932cb11e2ba94cb7d6edce83e0b0112233f7e5a734dcbf61d9b1c74e15a249ed2b22368af8d56', 'Swaggers', 'Philip', '', 'uploads/avatars/d54dbfbf482744e59fc407f94529d55e.jpg', '', '', 1765107713, 0, 0),
('db54bf983ede476fa4ac4930d1267ca9', 'tilphilipjuhl@gmail.com', 'scrypt:32768:8:1$lURqGzEJQel0UnX6$63c76830ba66bcf84ba9eb969f962d5928fbde8493cf2fc4d31776c7ce12e43b16e33d67939d722f60a3c4262d531fc76c6c799d4cff6354ed314e1a33087f52', 'Macrackilde', 'Other than P', '', 'uploads/avatars/db54bf983ede476fa4ac4930d1267ca9.png', '', '', 1765107935, 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`comment_pk`),
  ADD UNIQUE KEY `comment_pk` (`comment_pk`),
  ADD KEY `comment_user_fk` (`comment_user_fk`),
  ADD KEY `comment_post_fk` (`comment_post_fk`);

--
-- Indexes for table `follows`
--
ALTER TABLE `follows`
  ADD PRIMARY KEY (`follow_pk`),
  ADD UNIQUE KEY `follow_pk` (`follow_pk`),
  ADD UNIQUE KEY `follow_follower_following` (`follow_follower_fk`,`follow_following_fk`),
  ADD KEY `follow_follower_fk` (`follow_follower_fk`),
  ADD KEY `follow_following_fk` (`follow_following_fk`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD UNIQUE KEY `like_user_fk` (`like_user_fk`,`like_post_fk`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_pk`),
  ADD UNIQUE KEY `post_pk` (`post_pk`);

--
-- Indexes for table `trends`
--
ALTER TABLE `trends`
  ADD UNIQUE KEY `trend_pk` (`trend_pk`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_pk`),
  ADD UNIQUE KEY `user_pk` (`user_pk`),
  ADD UNIQUE KEY `user_email` (`user_email`),
  ADD UNIQUE KEY `user_name` (`user_username`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`comment_user_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`comment_post_fk`) REFERENCES `posts` (`post_pk`) ON DELETE CASCADE;

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `fk_like_post` FOREIGN KEY (`like_post_fk`) REFERENCES `posts` (`post_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_like_user` FOREIGN KEY (`like_user_fk`) REFERENCES `users` (`user_pk`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
