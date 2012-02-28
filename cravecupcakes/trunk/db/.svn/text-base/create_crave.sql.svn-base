

DROP TABLE IF EXISTS `owners`;
CREATE TABLE `owners` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

INSERT INTO `owners` (`username`,`password`,`email`) VALUES 
 ('q','q','shawn_hill@bradv.com');



/****** sessions ******/

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `sessid` VARCHAR (255) NOT NULL,
  `data` text NOT NULL,
  `updated_at` datetime,
  `created_at` datetime,
		PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


/****** seo_stuff ******/

drop table IF EXISTS `seo_settings`;
CREATE TABLE `seo_settings` (
  `id` int(11) NOT NULL auto_increment,
  `path` varchar(255) NOT NULL,
  `page_title` varchar(255) NOT NULL,
  `meta_keywords` varchar(512) NOT NULL,
  `meta_description` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_seo_settings_on_path` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

/* use dyno pages instead ?????
DROP TABLE IF EXISTS `news_items`;
CREATE TABLE `news_items` (
  `id` int(11) NOT NULL auto_increment,
  `released_on` date default NULL,
  `title` varchar(255) NOT NULL,
  `image_file` varchar(255) default NULL,
  `alt_text` varchar(255) default NULL,
  `blurb` varchar(1000) default NULL,
  `slug` varchar(255) default NULL,
  `page_HTML` text NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;
*/

/****** subscribers ******/

DROP TABLE IF EXISTS `subscribers`;
CREATE TABLE `subscribers` (
  `id` int(11) NOT NULL auto_increment,
  `email_address` varchar(255) NOT NULL,
  `first_name` varchar(50) default NULL,
  `last_name` varchar(50) default NULL,
  `address1` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(2) NOT NULL,
		`zip` varchar(15) NOT NULL,
  `subscribed_on` date default NULL,
  PRIMARY KEY (`id`)
)  ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `faqs`;
CREATE TABLE `faqs` (
  `id` int(11) NOT NULL auto_increment,
  `position` integer,
  `question` varchar(512) NOT NULL,
  `answer` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `editable_texts`;
CREATE TABLE `editable_texts` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `html_body` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

--
-- Table structure for table `dyno_images`
--

DROP TABLE IF EXISTS `dyno_images`;
CREATE TABLE `dyno_images` (
  `id` int(11) NOT NULL auto_increment,
  `dyno_page_id` int(11) NOT NULL,
  `caption` varchar(255) NOT NULL,
  `image` varchar(255) default NULL,
  `thumb` varchar(255) default NULL,
  `position` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;



--
-- Table structure for table `dyno_pages`
--

DROP TABLE IF EXISTS `dyno_pages`;
CREATE TABLE `dyno_pages` (
  `id` int(11) NOT NULL auto_increment,
  `dyno_type_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `sub_title` varchar(255) default NULL,
  `slug` varchar(255) NOT NULL,
  `uri` varchar(255) NOT NULL,
  `summary` varchar(1000) default NULL,
  `page_on` date NOT NULL,
  `page_HTML` text NOT NULL,
  `is_active` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `index_dyno_pages_on_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


--
-- Table structure for table `dyno_types`
--

DROP TABLE IF EXISTS `dyno_types`;
CREATE TABLE `dyno_types` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `slug` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_dyno_types_on_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

--
-- Dumping data for table `dyno_types`
--

/*!40000 ALTER TABLE `dyno_types` DISABLE KEYS */;
INSERT INTO `dyno_types` (`id`,`title`,`slug`) VALUES 
 (1,'about','about'),
 (2,'news','news');
/*!40000 ALTER TABLE `dyno_types` ENABLE KEYS */;


DROP TABLE IF EXISTS `cupcakes`;
CREATE TABLE `cupcakes` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `description` text  NULL,
  `slug` varchar(255) NOT NULL,
  `image_file` varchar(255) NOT NULL,
  `is_breakfast` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `index_cupcakes_on_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `days`;
CREATE TABLE `days` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `abbreviation` varchar(4) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

INSERT INTO `days` (`title`,`abbreviation`) VALUES 
 ('Monday', 'mon'),
 ('Tuesday', 'tue'),
 ('Wednesday', 'wed'),
 ('Thursday', 'thur'),
 ('Friday', 'fri'),
 ('Saturday', 'sat'),
 ('Sunday', 'sun');

DROP TABLE IF EXISTS `cupcakes_days`;
CREATE TABLE `cupcakes_days` (
  `id` int(11) NOT NULL auto_increment,
  `cupcake_id` int(11) NOT NULL,
  `day_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS `prices`;
CREATE TABLE `prices` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(55) NOT NULL,
  `price` float  NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

INSERT INTO `prices` (`title`,`price`) VALUES 
 ('single', 3.25),
 ('breakfast', 2.50),
 ('dozen', 36.00),
 ('dozen in giftbox', 46.00);


DROP TABLE IF EXISTS `product_types`;
CREATE TABLE `product_types` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(55) NOT NULL,
  `position` int,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int(11) NOT NULL auto_increment,
  `product_type_id` int(11) NOT NULL,
  `title` varchar(55) NOT NULL,
  `price` float  NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;
