-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Generation Time: Dec 08, 2025 at 11:58 AM
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
('7731d1ea1df04c83a1a83b41a4222749', '2', 'd36e2f561683442ebe4a60caf8bc1231', 'i think you are very funny fellow admin', '2025-12-08 11:41:14', NULL),
('c0235d4a15384b0b9cd9c36d541a3ea0', '2', 'bea01e4bf21a48db90f05586c3171dca', 'i saw it and i love it keep them coming !', '2025-12-08 11:41:26', NULL);

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
('11698244de5947bf8a53069a5c93c597', '2', '1', '2025-12-08 11:42:22', NULL),
('1fcb1e9a849747a9bbdf375b3d182122', 'db54bf983ede476fa4ac4930d1267ca9', '1', '2025-12-08 11:43:55', NULL),
('5bb24acc14c5406ebf51ed617965c8ee', 'db54bf983ede476fa4ac4930d1267ca9', '3', '2025-12-08 11:43:57', NULL);

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
('2', '977a23c32e5b4fb084e0bc53c3b140ed', '2025-12-08 11:41:04', NULL),
('2', 'bea01e4bf21a48db90f05586c3171dca', '2025-12-08 11:41:17', NULL),
('2', 'd36e2f561683442ebe4a60caf8bc1231', '2025-12-08 11:41:06', NULL),
('db54bf983ede476fa4ac4930d1267ca9', '977a23c32e5b4fb084e0bc53c3b140ed', '2025-12-08 11:02:06', NULL),
('db54bf983ede476fa4ac4930d1267ca9', 'b44a33d9537948c7b2408b0fa7a66168', '2025-12-08 11:44:59', NULL),
('db54bf983ede476fa4ac4930d1267ca9', 'bea01e4bf21a48db90f05586c3171dca', '2025-12-08 11:02:06', NULL),
('db54bf983ede476fa4ac4930d1267ca9', 'd36e2f561683442ebe4a60caf8bc1231', '2025-12-08 11:02:05', NULL);

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
('2126589cc85a4dd79177fdbc984bde0f', 'db54bf983ede476fa4ac4930d1267ca9', 'i would like my own post', 0, '', '2025-12-08 10:59:20'),
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
('5a4f663798ef4694ac13dfe2c61d8e88', 'db54bf983ede476fa4ac4930d1267ca9', 'i love posting', 0, '', '2025-12-08 10:59:22'),
('5b147eb4f0064bd9be7f18e6be2b3347', '225a9fc15b8f409aa5c8ee7eafee516b', 'First great test', 1, '', NULL),
('616c38c6e9e14406a92439e2d81490fc', '225a9fc15b8f409aa5c8ee7eafee516b', 'A browser', 0, '', NULL),
('63ed90b8cafc47fa9a3253fa1ecfeb04', '225a9fc15b8f409aa5c8ee7eafee516b', 'this', 1, '', NULL),
('69d3ed14f15047139b6cd8bd8180c104', '59ac8f8892bc45528a631d4415151f13', 'This is Daniel\'s post', 1, '', NULL),
('6b7bc6fd2b57486db21325030f63fd90', '6b48c6095913402eb4841529830e5415', 'erere', 1, '', NULL),
('6bae1e557dc841298bb88750a7926bc7', 'db54bf983ede476fa4ac4930d1267ca9', 'hahah', 0, '', '2025-12-08 10:59:23'),
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
('977a23c32e5b4fb084e0bc53c3b140ed', 'db54bf983ede476fa4ac4930d1267ca9', 'This post is postet by an admin please like', 0, '', NULL),
('991ba7fa40af4d3da8b2d57981efbb64', '486426e9b9d54219a85e509527a06363', 'WHAT IS ESCAPÅE', 0, '', NULL),
('99fefea24ea5419da19ed1f8cf8e9499', '225a9fc15b8f409aa5c8ee7eafee516b', 'wow', 1, 'post_1.jpg', NULL),
('9bddfa16026f4802ba0cf3352701be13', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('9ef88a3383fd4f5a8472bab7b995899e', '486426e9b9d54219a85e509527a06363', 'hello i keep posting for the love', 0, '', '2025-12-07 11:50:04'),
('ad95e1d3f62f4d07b7bf9e3e6d4dd527', '225a9fc15b8f409aa5c8ee7eafee516b', 'And this just works!', 0, '', NULL),
('ae3a8c2319894a778dd1d86a96f040ab', '486426e9b9d54219a85e509527a06363', 'ghello', 0, '', '2025-12-04 14:13:37'),
('aeed8499d0d149dbb8135d8e098df6a9', '486426e9b9d54219a85e509527a06363', 'AFRAID', 0, '', NULL),
('b44a33d9537948c7b2408b0fa7a66168', '2', 'Welcome to X the app! look around create / like posts and check out the news!', 0, '', NULL),
('b4b23963a6a4479e918e66f47baef200', '225a9fc15b8f409aa5c8ee7eafee516b', 'test1', 0, '', NULL),
('b8f59662ce5b4b58bf19a5fe0eda3122', '225a9fc15b8f409aa5c8ee7eafee516b', 'test2', 1, '', NULL),
('bcaa6df8880e411a9c25deaafae2314a', '225a9fc15b8f409aa5c8ee7eafee516b', 'test4', 0, '', NULL),
('bea01e4bf21a48db90f05586c3171dca', 'db54bf983ede476fa4ac4930d1267ca9', 'is anyone seeing my post or am i alone...', 0, '', NULL),
('bf3bbaf46d694e5288201f19894f1ef0', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('c36a2581789142809dfbe4c875022de7', '486426e9b9d54219a85e509527a06363', 'stop', 0, '', NULL),
('c7b70a674e1f484591e077d903bbf400', '486426e9b9d54219a85e509527a06363', 'sadsa', 0, '', '2025-12-04 14:17:40'),
('cf1516d0c461483b8eccead4a4f62191', '486426e9b9d54219a85e509527a06363', 'create a lot of posts to edit !', 0, '', NULL),
('d36e2f561683442ebe4a60caf8bc1231', 'db54bf983ede476fa4ac4930d1267ca9', 'well i think im funny', 0, '', NULL),
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
('1', 'No one in town to see Pennywise', 'The famous dancing clown in town but no one is watching his famous Griddy'),
('2', 'BIG APPLE ANNOUNCE MENT', 'new phones!!!!'),
('3', 'The Big apple changes name', 'the new name is uuuuh eeeh, its uuumh...the new name is uuuuh eeeh, its '),
('4', '', '');

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
('1', 'anotherrandomemail@gmail.com', 'scrypt:32768:8:1$lURqGzEJQel0UnX6$63c76830ba66bcf84ba9eb969f962d5928fbde8493cf2fc4d31776c7ce12e43b16e33d67939d722f60a3c4262d531fc76c6c799d4cff6354ed314e1a33087f52', 'DennisDope', 'Dennis', 'Le dope', 'avatar_1.jpg', '', '', 1, 0, 0),
('2', 'a@a.com', 'scrypt:32768:8:1$lURqGzEJQel0UnX6$63c76830ba66bcf84ba9eb969f962d5928fbde8493cf2fc4d31776c7ce12e43b16e33d67939d722f60a3c4262d531fc76c6c799d4cff6354ed314e1a33087f52', 'admin', 'admin nr 1', 'adminman', 'avatar_3.jpg', '', '', 1, 1, 0),
('3', 'b@b.com', 'scrypt:32768:8:1$lURqGzEJQel0UnX6$63c76830ba66bcf84ba9eb969f962d5928fbde8493cf2fc4d31776c7ce12e43b16e33d67939d722f60a3c4262d531fc76c6c799d4cff6354ed314e1a33087f52', 'Bernats', 'Bernard', 'La tounge', NULL, '', '', 1, 0, 0),
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
