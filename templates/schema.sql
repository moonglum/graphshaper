DROP TABLE IF EXISTS `edges`;
DROP TABLE IF EXISTS `vertices`;

CREATE TABLE `vertices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `vertex_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `edges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `edge_id` int(11) unsigned NOT NULL,
  `from_id` int(11) unsigned NOT NULL,
  `to_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `from_id` (`from_id`),
  KEY `to_id` (`to_id`),
  CONSTRAINT `edges_ibfk_2` FOREIGN KEY (`to_id`) REFERENCES `vertices` (`id`),
  CONSTRAINT `edges_ibfk_1` FOREIGN KEY (`from_id`) REFERENCES `vertices` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;