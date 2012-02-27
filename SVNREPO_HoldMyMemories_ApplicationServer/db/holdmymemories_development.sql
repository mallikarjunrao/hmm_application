-- phpMyAdmin SQL Dump
-- version 2.11.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 02, 2008 at 02:13 PM
-- Server version: 5.0.45
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `holdmymemories_development`
--

-- --------------------------------------------------------

--
-- Table structure for table `abuses`
--

CREATE TABLE IF NOT EXISTS `abuses` (
  `id` bigint(20) NOT NULL auto_increment,
  `v_abused_by` varchar(255) default NULL,
  `abused_user` bigint(20) default NULL,
  `e_status` enum('pending','approve','reject') default 'pending',
  `v_comment` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `advertisement_details`
--

CREATE TABLE IF NOT EXISTS `advertisement_details` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `advid` int(10) unsigned NOT NULL,
  `v_adtitle` varchar(50) default NULL,
  `v_adlink` varchar(50) default NULL,
  `v_adtag` varchar(50) default NULL,
  `v_filename` varchar(255) default NULL,
  `i_imgwidth` int(10) unsigned default NULL,
  `i_imgheight` int(10) unsigned default NULL,
  `i_imgx` int(10) unsigned default NULL,
  `i_imgy` int(10) unsigned default NULL,
  `content_type` varchar(255) default NULL,
  `data` blob NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `advertisement_FKIndex1` (`advid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `advertiser_details`
--

CREATE TABLE IF NOT EXISTS `advertiser_details` (
  `id` int(11) NOT NULL auto_increment,
  `v_firstname` varchar(255) NOT NULL,
  `v_lastname` varchar(255) NOT NULL,
  `v_username` varchar(255) NOT NULL,
  `v_password` varchar(255) NOT NULL,
  `v_company` varchar(255) NOT NULL,
  `v_address` varchar(25) NOT NULL,
  `v_city` varchar(255) NOT NULL,
  `v_state` varchar(255) NOT NULL,
  `v_country` varchar(255) NOT NULL,
  `v_zip` varchar(255) NOT NULL,
  `v_phone` varchar(255) NOT NULL,
  `v_email` varchar(255) NOT NULL,
  `e_gender` enum('Male','Female') NOT NULL,
  `d_created_at` datetime default NULL,
  `d_updated_at` datetime default NULL,
  `v_plan` varchar(255) NOT NULL,
  `e_status` enum('Active','Inactive') NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `chapter_comments`
--

CREATE TABLE IF NOT EXISTS `chapter_comments` (
  `id` bigint(20) NOT NULL auto_increment,
  `uid` bigint(20) default NULL,
  `tag_id` bigint(20) default NULL,
  `tag_jid` int(11) default '0',
  `v_name` varchar(255) default NULL,
  `v_e_mail` varchar(255) default NULL,
  `v_comment` text NOT NULL,
  `d_created_on` datetime NOT NULL,
  `e_approval` enum('approve','reject','pending') NOT NULL default 'pending',
  `reply` varchar(255) default NULL,
  `ctype` varchar(255) default 'chapter',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `chapter_journals`
--

CREATE TABLE IF NOT EXISTS `chapter_journals` (
  `id` bigint(20) NOT NULL auto_increment,
  `tag_id` bigint(20) default NULL,
  `v_tag_title` varchar(255) NOT NULL,
  `v_tag_journal` text NOT NULL,
  `d_created_at` datetime NOT NULL,
  `d_updated_at` datetime NOT NULL,
  `jtype` varchar(255) NOT NULL default 'chapter',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL auto_increment,
  `v_name` varchar(255) NOT NULL,
  `v_email` varchar(255) NOT NULL,
  `uid` int(11) default NULL,
  `jid` int(11) default NULL,
  `v_user_name` varchar(255) default NULL,
  `v_comment` text NOT NULL,
  `e_acc_verify` enum('Yes','No') NOT NULL,
  `e_aprove_comment` enum('pending','approve','reject') NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `exports`
--

CREATE TABLE IF NOT EXISTS `exports` (
  `id` int(11) NOT NULL auto_increment,
  `exported_from` int(11) NOT NULL,
  `exported_to` int(11) NOT NULL,
  `exported_id` varchar(256) NOT NULL,
  `export_type` enum('tags','subchapter','gallery','usercontent') NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

-- --------------------------------------------------------

--
-- Table structure for table `family_friends`
--

CREATE TABLE IF NOT EXISTS `family_friends` (
  `id` int(100) NOT NULL auto_increment,
  `uid` int(100) NOT NULL,
  `fid` int(100) NOT NULL,
  `fnf_category` bigint(20) default NULL,
  `status` enum('pending','accepted','rejected') NOT NULL default 'pending',
  `block_status` enum('block','unblock') NOT NULL default 'unblock',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=76 ;

-- --------------------------------------------------------

--
-- Table structure for table `faqs`
--

CREATE TABLE IF NOT EXISTS `faqs` (
  `id` bigint(20) NOT NULL auto_increment,
  `question` varchar(255) NOT NULL,
  `answer` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Table structure for table `fnf_groups`
--

CREATE TABLE IF NOT EXISTS `fnf_groups` (
  `id` int(11) NOT NULL auto_increment,
  `fnf_category` varchar(255) NOT NULL,
  `uid` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=130 ;

-- --------------------------------------------------------

--
-- Table structure for table `galleries`
--

CREATE TABLE IF NOT EXISTS `galleries` (
  `id` bigint(20) NOT NULL auto_increment,
  `v_gallery_name` varchar(255) default NULL,
  `e_gallery_type` enum('image','video','audio') default NULL,
  `d_gallery_date` datetime NOT NULL,
  `status` enum('active','inactive') default 'active',
  `e_gallery_acess` enum('private','public','semiprivate') default NULL,
  `v_gallery_image` varchar(255) default 'image.png',
  `subchapter_id` bigint(20) NOT NULL,
  `permissions` text NOT NULL,
  `v_gallery_tags` varchar(512) NOT NULL default 'Add Tags Here',
  `v_desc` varchar(512) NOT NULL default 'Enter Description Here',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2356 ;

-- --------------------------------------------------------

--
-- Table structure for table `gallery_comments`
--

CREATE TABLE IF NOT EXISTS `gallery_comments` (
  `id` bigint(20) NOT NULL auto_increment,
  `uid` bigint(20) NOT NULL,
  `gallery_id` bigint(20) NOT NULL,
  `gallery_jid` bigint(20) NOT NULL,
  `v_comment` text NOT NULL,
  `d_created_on` datetime NOT NULL,
  `e_approval` enum('pending','approve','reject') NOT NULL default 'pending',
  `ctype` varchar(250) NOT NULL default 'gallery',
  `reply` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `gallery_journals`
--

CREATE TABLE IF NOT EXISTS `gallery_journals` (
  `id` bigint(20) NOT NULL auto_increment,
  `uid` bigint(20) NOT NULL,
  `galerry_id` bigint(20) NOT NULL,
  `v_title` varchar(255) NOT NULL,
  `v_journal` text NOT NULL,
  `d_created_on` datetime NOT NULL,
  `d_updated_on` datetime NOT NULL,
  `jtype` varchar(255) NOT NULL default 'gallery',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

-- --------------------------------------------------------

--
-- Table structure for table `hmms`
--

CREATE TABLE IF NOT EXISTS `hmms` (
  `id` int(11) NOT NULL auto_increment,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `add1` varchar(255) NOT NULL,
  `add2` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `zip` int(11) NOT NULL,
  `e-mail` varchar(100) NOT NULL,
  `user_status` enum('blocked','unblocked') NOT NULL default 'unblocked',
  `ip_add` int(11) NOT NULL,
  `login_status` tinyint(1) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `hmm_users`
--

CREATE TABLE IF NOT EXISTS `hmm_users` (
  `id` int(11) NOT NULL auto_increment,
  `v_fname` varchar(255) NOT NULL,
  `v_lname` varchar(255) NOT NULL,
  `e_sex` varchar(10) NOT NULL,
  `v_user_name` varchar(255) NOT NULL,
  `v_password` varchar(255) NOT NULL,
  `v_add1` varchar(255) default NULL,
  `v_add2` varchar(255) default NULL,
  `v_city` varchar(100) default NULL,
  `v_state` varchar(100) default NULL,
  `v_country` varchar(100) NOT NULL,
  `v_zip` varchar(100) NOT NULL,
  `v_e_mail` varchar(100) NOT NULL,
  `e_user_status` enum('blocked','unblocked') NOT NULL default 'unblocked',
  `i_ip_add` int(11) default NULL,
  `i_login_status` int(11) default NULL,
  `d_created_date` datetime NOT NULL,
  `d_updated_date` datetime NOT NULL,
  `d_bdate` date NOT NULL,
  `v_myimage` varchar(100) default 'blank.jpg',
  `v_security_q` varchar(256) NOT NULL,
  `v_security_a` varchar(256) NOT NULL,
  `v_abt_me` longtext NOT NULL,
  `v_link1` varchar(256) NOT NULL,
  `v_link2` varchar(256) NOT NULL,
  `v_link3` varchar(256) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=58 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals`
--

CREATE TABLE IF NOT EXISTS `journals` (
  `id` int(11) NOT NULL auto_increment,
  `uid` bigint(20) default NULL,
  `chap_id` bigint(20) default NULL,
  `v_title` varchar(255) NOT NULL,
  `v_small_description` varchar(255) NOT NULL,
  `v_large_description` text NOT NULL,
  `d_create_date` datetime NOT NULL,
  `d_updated_date` datetime NOT NULL,
  `e_journal_access` enum('PUBLIC','PRIVATE','SEMIPRIVATE') NOT NULL,
  `d_reminder_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals_audios`
--

CREATE TABLE IF NOT EXISTS `journals_audios` (
  `id` int(11) NOT NULL auto_increment,
  `v_audio_filename` varchar(256) NOT NULL,
  `v_audio_comment` varchar(256) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals_comments`
--

CREATE TABLE IF NOT EXISTS `journals_comments` (
  `id` int(11) NOT NULL auto_increment,
  `v_title` varchar(256) NOT NULL,
  `v_comment` datetime NOT NULL,
  `d_added_date` datetime NOT NULL,
  `v_comment_by` varchar(256) NOT NULL,
  `v_email_id` varchar(256) NOT NULL,
  `e_friend_request` enum('YES','NO') NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals_paperworks`
--

CREATE TABLE IF NOT EXISTS `journals_paperworks` (
  `id` int(11) NOT NULL auto_increment,
  `v_paper_filename` varchar(256) NOT NULL,
  `v_comment` varchar(256) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals_photos`
--

CREATE TABLE IF NOT EXISTS `journals_photos` (
  `id` int(11) NOT NULL auto_increment,
  `user_content_id` bigint(20) NOT NULL,
  `v_title` varchar(255) default NULL,
  `v_image_comment` text,
  `Comment_from` text,
  `approved` enum('yes','no') default 'no',
  `date_added` datetime NOT NULL,
  `jtype` varchar(255) NOT NULL default 'photo',
  `updated_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=52 ;

-- --------------------------------------------------------

--
-- Table structure for table `journals_videos`
--

CREATE TABLE IF NOT EXISTS `journals_videos` (
  `id` int(11) NOT NULL auto_increment,
  `v_video_filename` varchar(256) NOT NULL,
  `v_comment` varchar(256) default NULL,
  `i_video_width` int(11) default NULL,
  `i_video_height` int(11) default NULL,
  `i_video_x` int(11) default NULL,
  `i_video_y` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `nonhmm_users`
--

CREATE TABLE IF NOT EXISTS `nonhmm_users` (
  `id` int(11) NOT NULL auto_increment,
  `uid` int(11) NOT NULL,
  `v_name` varchar(255) NOT NULL,
  `v_email` varchar(255) NOT NULL,
  `v_city` varchar(255) default NULL,
  `v_country` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `permalink` varchar(255) NOT NULL,
  `body` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `photo_comments`
--

CREATE TABLE IF NOT EXISTS `photo_comments` (
  `id` bigint(20) NOT NULL auto_increment,
  `uid` bigint(20) default NULL,
  `journal_id` bigint(20) default NULL,
  `v_title` varchar(255) default NULL,
  `v_name` varchar(255) default NULL,
  `v_uid` bigint(20) default NULL,
  `v_email` varchar(255) default NULL,
  `v_comment` text,
  `d_add_date` datetime NOT NULL,
  `e_approved` enum('approve','reject','pending') default 'pending',
  `e_access` enum('private','public') default 'private',
  `user_content_id` bigint(20) NOT NULL,
  `ctype` varchar(250) NOT NULL default 'moment',
  `reply` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

-- --------------------------------------------------------

--
-- Table structure for table `schema_info`
--

CREATE TABLE IF NOT EXISTS `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `shares`
--

CREATE TABLE IF NOT EXISTS `shares` (
  `id` bigint(20) NOT NULL auto_increment,
  `presenter_id` bigint(20) NOT NULL,
  `email_list` text NOT NULL,
  `xml_name` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL,
  `guest_name` varchar(255) default NULL,
  `Visited_date` datetime default NULL,
  `message` text,
  `password` varchar(255) default NULL,
  `unid` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=121 ;

-- --------------------------------------------------------

--
-- Table structure for table `share_comments`
--

CREATE TABLE IF NOT EXISTS `share_comments` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `comment` text,
  `uid` bigint(20) default NULL,
  `d_add_date` datetime default NULL,
  `share_id` bigint(20) NOT NULL,
  `e_approved` enum('approved','rejected','pending') NOT NULL default 'pending',
  `reply` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `share_memories`
--

CREATE TABLE IF NOT EXISTS `share_memories` (
  `id` bigint(20) NOT NULL,
  `presenter_id` bigint(20) NOT NULL,
  `email_list` text NOT NULL,
  `xml_name` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `expiry_date` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `slide_shows`
--

CREATE TABLE IF NOT EXISTS `slide_shows` (
  `id` int(11) NOT NULL,
  `img_name` varchar(255) NOT NULL,
  `desc` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `subchap_comments`
--

CREATE TABLE IF NOT EXISTS `subchap_comments` (
  `id` bigint(20) NOT NULL auto_increment,
  `uid` bigint(20) default NULL,
  `subchap_id` bigint(20) NOT NULL,
  `subchap_jid` bigint(20) default NULL,
  `v_comments` text NOT NULL,
  `d_created_on` datetime NOT NULL,
  `e_approval` enum('approve','reject','pending') NOT NULL default 'pending',
  `ctype` varchar(250) NOT NULL default 'sub_chapter',
  `reply` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `sub_chapters`
--

CREATE TABLE IF NOT EXISTS `sub_chapters` (
  `id` int(100) NOT NULL auto_increment,
  `uid` int(100) default NULL,
  `tagid` int(100) default NULL,
  `sub_chapname` varchar(100) default NULL,
  `status` enum('active','inactive') NOT NULL default 'active',
  `v_image` varchar(255) NOT NULL,
  `permissions` text NOT NULL,
  `e_access` enum('private','public','semiprivate') NOT NULL default 'private',
  `v_subchapter_tags` varchar(512) NOT NULL default 'Add Tags Here',
  `v_desc` varchar(512) NOT NULL default 'Enter Description Here',
  `d_created_on` datetime NOT NULL,
  `d_updated_on` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `sub_chap_journals`
--

CREATE TABLE IF NOT EXISTS `sub_chap_journals` (
  `id` bigint(20) NOT NULL auto_increment,
  `tag_id` bigint(20) default NULL,
  `sub_chap_id` bigint(20) NOT NULL,
  `journal_title` varchar(255) NOT NULL,
  `subchap_journal` text NOT NULL,
  `created_on` datetime NOT NULL,
  `updated_on` datetime NOT NULL,
  `jtype` varchar(255) NOT NULL default 'subchap',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Table structure for table `tags`
--

CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL auto_increment,
  `uid` int(11) default NULL,
  `sub_chapid` int(100) default NULL,
  `v_tagname` varchar(50) NOT NULL,
  `v_chapimage` varchar(100) default NULL,
  `default_tag` enum('yes','no') NOT NULL default 'yes',
  `e_access` enum('private','public','semiprivate') default NULL,
  `e_visible` enum('yes','no') NOT NULL,
  `d_createddate` datetime NOT NULL,
  `d_updateddate` datetime NOT NULL,
  `status` enum('active','inactive') NOT NULL default 'active',
  `permissions` text NOT NULL,
  `v_chapter_tags` varchar(512) NOT NULL default 'Add Tags Here',
  `v_desc` varchar(512) NOT NULL default 'Enter Description Here',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `tips`
--

CREATE TABLE IF NOT EXISTS `tips` (
  `id` bigint(20) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(64) default NULL,
  `email` varchar(128) default NULL,
  `hashed_password` varchar(64) default NULL,
  `enabled` enum('yes','no') default 'yes',
  `profile` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `acess_level` bigint(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_contents`
--

CREATE TABLE IF NOT EXISTS `user_contents` (
  `id` int(100) NOT NULL auto_increment,
  `gallery_id` bigint(20) NOT NULL,
  `v_tagname` varchar(100) NOT NULL,
  `tagid` int(100) NOT NULL,
  `sub_chapid` int(100) default NULL,
  `uid` int(100) default NULL,
  `e_filetype` enum('image','video','audio','swf') NOT NULL,
  `e_access` enum('private','public','semiprivate') default NULL,
  `e_visible` enum('yes','no') NOT NULL default 'no',
  `v_filename` varchar(100) NOT NULL,
  `v_desc` varchar(255) NOT NULL,
  `v_tagphoto` varchar(100) default NULL,
  `d_createddate` datetime NOT NULL,
  `d_momentdate` datetime default NULL,
  `status` enum('active','inactive') NOT NULL default 'active',
  `permissions` text NOT NULL,
  `views` bigint(20) NOT NULL default '0',
  `flag` bigint(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=188 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE IF NOT EXISTS `user_sessions` (
  `id` int(11) NOT NULL auto_increment,
  `i_ip_add` varchar(255) default NULL,
  `uid` int(11) default NULL,
  `v_user_name` varchar(255) NOT NULL,
  `d_date_time` datetime NOT NULL,
  `e_logged_in` enum('yes','no') NOT NULL default 'no',
  `e_logged_out` enum('yes','no') NOT NULL default 'no',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;
