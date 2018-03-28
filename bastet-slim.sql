-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  mer. 28 mars 2018 à 14:12
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
  `date_naiss` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
(2, 'test@gmail.com', '$2a$10$d16e8a628fa2322bd62feeotrb0t0xHWSZBWY/UqYVC9BppnzEG2C', 'MEMBER', '1828b5d4ca17608caea4b16edb800bbb', 0, '2018-03-28 11:26:28'),
(3, 'test2@gmail.com', '$2a$10$bf5418ae69317b6db9885uitgouaZME8fPge4bNVcPffw.Mx/wNTC', 'ETUDIANT', '423633e60f0ddd133152f3c424231866', 0, '2018-03-28 11:41:59'),
(4, 'test3@gmail.com', '$2a$10$c674c7d4c8759d5086835uXmwgOtcN.xc6hGr1TOyodu.vPE9x98u', 'ECOLE', '6f04abeb300498b7db74eeb81ce3e785', 0, '2018-03-28 11:50:26'),
(5, 'test4@gmail.com', '$2a$10$5e25e6347a5f7984d31ecuKvBcPNLCqWrPJ/VeF.QYzmTunKmhGeW', 'ECOLE', '2e1a2f8ecb118b51fcc4590ede0182db', 0, '2018-03-28 11:51:46'),
(6, 'test5@gmail.com', '$2a$10$7c9882a83cd62a7c233f6OrcXkf5MO3l1Q25GIpsTkZmIqN312nn.', 'ECOLE', '8606df991888028635df356e2fe1d5ea', 0, '2018-03-28 11:53:44'),
(7, 'test6@gmail.com', '$2a$10$7055a7a2a6d6685a7c921uPUDcrCkarB5lFDMYHB.wEm1WWMmXJwu', 'ECOLE', '5498c3da4e60b2f4edb88a4dc4456eee', 0, '2018-03-28 11:54:03');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
