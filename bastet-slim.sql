-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  mer. 11 avr. 2018 à 14:16
-- Version du serveur :  10.1.30-MariaDB
-- Version de PHP :  7.2.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `bastet-slim`
--

-- --------------------------------------------------------

--
-- Structure de la table `profile`
--

CREATE TABLE `profile` (
  `id` int(11) NOT NULL,
  `user` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `promotion` varchar(4) NOT NULL,
  `date_naiss` date NOT NULL,
  `keywords` varchar(1000) NOT NULL,
  `picture` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `profile`
--

INSERT INTO `profile` (`id`, `user`, `nom`, `prenom`, `promotion`, `date_naiss`, `keywords`, `picture`) VALUES
(1, 1, 'YOL', 'Ludovic', '2016', '1993-10-01', 'developpement;gestion;projet', 'yol_ludovic.jpg'),
(2, 2, 'Receveur', 'Alexandre', '2017', '2017-04-07', 'achat;logistique;java;airbus', 'receveur_alexandre.jpg'),
(12, 6, 'Fleurot', 'Alexandre', '2018', '1995-10-10', 'stage;mipih;dev', ''),
(20, 3, 'Rouchy', 'Elise', '2017', '1991-05-20', 'mipih;dev;java', ''),
(56, 4, 'Roulenq', 'Vincent', '2016', '1993-06-06', 'mipih;dev;agile;scrum;master', ''),
(69, 0, 'De Lagoutine', 'Thomas', '2016', '1993-01-10', 'dev;infotel;java;big;data', ''),
(70, 7, 'Rawat', 'Eshane', '2018', '1990-10-10', 'design;dev;java;angular;scrum', ''),
(71, 8, 'Chaumeil', 'Anais', '2019', '1996-01-01', 'dev;java;python', '');

-- --------------------------------------------------------

--
-- Structure de la table `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `task` text NOT NULL,
  `status` int(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `tasks`
--

INSERT INTO `tasks` (`id`, `task`, `status`, `created_at`) VALUES
(1, 'test', 1, '2018-03-18 18:15:20');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` text NOT NULL,
  `role` varchar(50) NOT NULL,
  `api_key` varchar(32) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `role`, `api_key`, `status`, `created_at`) VALUES
(1, 'ludovic.yol@gmail.com', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ADMIN', 'c3b5172a4bc327edcdcb6d5b8b6857cf', 1, '2018-03-18 18:44:21'),
(2, 'alexandre.receveur@yahoo.fr', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ADMIN', 'c3b5172a4bc327edcdcb6d5b8b6857cf', 1, '2018-04-09 11:45:36'),
(3, 'elise.rouchy@gmail.com', '$2a$10$0d872355e74cbb2d3dbb1eAMIHBSe1a28r.JieNJLQycDTui4oTsW', 'ALUMNI', 'fd68547cfead9b4d490bd018aa38c5dd', 1, '2018-04-11 10:18:02'),
(4, 'vincent.roulenq@gmail.com', '$2a$10$318f7f563f28f7591951dO7P4wj0VBPxrtEKhv66OnPrdNZQcH3DW', 'ALUMNI', 'c20a1eaed111f41486219be6726f24eb', 1, '2018-04-11 10:18:19'),
(5, 'thomas.delagoutine@gmail.com', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ALUMNI', 'c20a1eaed111f41486219be6726f24ee', 0, '2018-04-11 11:54:26'),
(6, 'alexandre.fleurot@gmail.com', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ETUDIANT', 'c20a1eaed111f41486219be6726f24ef', 1, '2018-04-11 11:54:56'),
(7, 'eshane.rawat@gmail.com', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ETUDIANT', 'c20a1eaed111f41486219be6726f24eg', 0, '2018-04-11 11:55:15'),
(8, 'anais.chaumeil@gmail.com', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ETUDIANT', 'c20a1eaed111f41486219be6726f24eh', 2, '2018-04-11 11:56:47'),
(9, 'ecole@univ-jfc.fr', '$2a$10$22164a2d1e6b74d4602fduk0RbgaHOeC3zFIuqpCQEXQSCgKssZJO', 'ECOLE', 'c20a1eaed111f41486219be6726f24ei', 1, '2018-04-11 11:57:03');

-- --------------------------------------------------------

--
-- Structure de la table `user_tasks`
--

CREATE TABLE `user_tasks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `profile`
--
ALTER TABLE `profile`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `user_tasks`
--
ALTER TABLE `user_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `task_id` (`task_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `profile`
--
ALTER TABLE `profile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT pour la table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `user_tasks`
--
ALTER TABLE `user_tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `user_tasks`
--
ALTER TABLE `user_tasks`
  ADD CONSTRAINT `user_tasks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_tasks_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
