-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 18/10/2026 às 01:20
-- Versão do servidor: 10.11.10-MariaDB-log
-- Versão do PHP: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `cassinopix`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `affiliate_histories`
--

CREATE TABLE `affiliate_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `inviter` int(10) UNSIGNED NOT NULL,
  `commission` decimal(20,2) NOT NULL DEFAULT 0.00,
  `commission_type` varchar(191) DEFAULT NULL,
  `deposited` tinyint(4) DEFAULT 0,
  `deposited_amount` decimal(10,2) DEFAULT 0.00,
  `losses` bigint(20) DEFAULT 0,
  `losses_amount` decimal(10,2) DEFAULT 0.00,
  `commission_paid` decimal(10,2) DEFAULT 0.00,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `receita` decimal(10,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `affiliate_withdraws`
--

CREATE TABLE `affiliate_withdraws` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` varchar(191) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(20,2) NOT NULL DEFAULT 0.00,
  `proof` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `pix_key` varchar(191) DEFAULT NULL,
  `pix_type` varchar(191) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `bank_info` text DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `banners`
--

CREATE TABLE `banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `link` varchar(191) DEFAULT NULL,
  `image` varchar(191) NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'home',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `banners`
--

INSERT INTO `banners` (`id`, `link`, `image`, `type`, `description`, `created_at`, `updated_at`) VALUES
(8, NULL, '01JNANKYEEM27MVWCWHK9Q5HVV.png', 'home', NULL, '2024-07-01 02:55:17', '2026-10-01 21:54:19'),
(9, NULL, '01JNANN7EP0NNSGVNQN6FYG2WE.png', 'home', NULL, '2024-07-01 02:56:59', '2026-10-01 21:54:26'),
(10, NULL, '01JNANRAZSYV83YD5WF53GRAQ5.png', 'home', NULL, '2024-07-01 02:57:19', '2026-10-01 21:54:32'),
(12, '/', '01JQKP1FHNGST2PT35VQ1RVKYV.png', 'carousel', NULL, '2024-07-24 08:47:44', '2025-03-30 11:07:11'),
(16, '/', '01JNAP0R343RKW3A0EEMCCEQN1.jpg', 'carousel', NULL, '2024-09-23 19:13:28', '2025-03-02 02:42:14'),
(17, '/', '01JNAP18JB8Q78JB9NN7KYKCA6.jpg', 'carousel', NULL, '2025-03-02 02:42:31', '2025-03-02 02:42:31'),
(18, '/', '01JNAP1QXK77NK48ZMVFDZ2EVX.jpg', 'carousel', NULL, '2025-03-02 02:42:46', '2025-03-02 02:42:46'),
(19, '/', '01JNAP24CQ6YEY225XAEF71M1J.jpg', 'carousel', NULL, '2025-03-02 02:42:59', '2025-03-02 02:42:59');

-- --------------------------------------------------------

--
-- Estrutura para tabela `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `category_game`
--

CREATE TABLE `category_game` (
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

--
-- Despejando dados para a tabela `category_game`
--

INSERT INTO `category_game` (`category_id`, `game_id`) VALUES
(2, 165),
(2, 493),
(2, 655),
(2, 660),
(2, 672),
(3, 1093),
(3, 1099),
(3, 1107),
(3, 1108),
(3, 1109),
(3, 1110),
(3, 1115),
(3, 1117),
(3, 1121),
(3, 1124),
(3, 1127),
(3, 1128),
(1, 165),
(1, 493),
(1, 655),
(1, 660),
(1, 672),
(1, 1093),
(1, 1099),
(1, 1107),
(1, 1108),
(1, 1109),
(1, 1110),
(1, 1115),
(1, 1117),
(1, 1121),
(1, 1124),
(1, 1127),
(1, 1128),
(4, 1186);

-- --------------------------------------------------------

--
-- Estrutura para tabela `currencies`
--

CREATE TABLE `currencies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(20) NOT NULL,
  `code` varchar(3) NOT NULL,
  `symbol` varchar(5) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `currencies`
--

INSERT INTO `currencies` (`id`, `name`, `code`, `symbol`, `created_at`, `updated_at`) VALUES
(1, 'Leke', 'ALL', 'Lek', '2023-11-07 18:01:38', NULL),
(2, 'Dollars', 'USD', '$', '2023-11-07 18:01:38', NULL),
(3, 'Afghanis', 'AFN', '؋', '2023-11-07 18:01:38', NULL),
(4, 'Pesos', 'ARS', '$', '2023-11-07 18:01:38', NULL),
(5, 'Guilders', 'AWG', 'ƒ', '2023-11-07 18:01:38', NULL),
(6, 'Dollars', 'AUD', '$', '2023-11-07 18:01:38', NULL),
(7, 'New Manats', 'AZN', 'ман', '2023-11-07 18:01:38', NULL),
(8, 'Dollars', 'BSD', '$', '2023-11-07 18:01:38', NULL),
(9, 'Dollars', 'BBD', '$', '2023-11-07 18:01:38', NULL),
(10, 'Rubles', 'BYR', 'p.', '2023-11-07 18:01:38', NULL),
(11, 'Euro', 'EUR', '€', '2023-11-07 18:01:38', NULL),
(12, 'Dollars', 'BZD', 'BZ$', '2023-11-07 18:01:38', NULL),
(13, 'Dollars', 'BMD', '$', '2023-11-07 18:01:38', NULL),
(14, 'Bolivianos', 'BOB', '$b', '2023-11-07 18:01:38', NULL),
(15, 'Convertible Marka', 'BAM', 'KM', '2023-11-07 18:01:38', NULL),
(16, 'Pula', 'BWP', 'P', '2023-11-07 18:01:38', NULL),
(17, 'Leva', 'BGN', 'лв', '2023-11-07 18:01:38', NULL),
(18, 'Reais', 'BRL', 'R$', '2023-11-07 18:01:38', NULL),
(19, 'Pounds', 'GBP', '£', '2023-11-07 18:01:38', NULL),
(20, 'Dollars', 'BND', '$', '2023-11-07 18:01:38', NULL),
(21, 'Riels', 'KHR', '៛', '2023-11-07 18:01:38', NULL),
(22, 'Dollars', 'CAD', '$', '2023-11-07 18:01:38', NULL),
(23, 'Dollars', 'KYD', '$', '2023-11-07 18:01:38', NULL),
(24, 'Pesos', 'CLP', '$', '2023-11-07 18:01:38', NULL),
(25, 'Yuan Renminbi', 'CNY', '¥', '2023-11-07 18:01:38', NULL),
(26, 'Pesos', 'COP', '$', '2023-11-07 18:01:38', NULL),
(27, 'Colón', 'CRC', '₡', '2023-11-07 18:01:38', NULL),
(28, 'Kuna', 'HRK', 'kn', '2023-11-07 18:01:38', NULL),
(29, 'Pesos', 'CUP', '₱', '2023-11-07 18:01:38', NULL),
(30, 'Koruny', 'CZK', 'Kč', '2023-11-07 18:01:38', NULL),
(31, 'Kroner', 'DKK', 'kr', '2023-11-07 18:01:38', NULL),
(32, 'Pesos', 'DOP', 'RD$', '2023-11-07 18:01:38', NULL),
(33, 'Dollars', 'XCD', '$', '2023-11-07 18:01:38', NULL),
(34, 'Pounds', 'EGP', '£', '2023-11-07 18:01:38', NULL),
(35, 'Colones', 'SVC', '$', '2023-11-07 18:01:38', NULL),
(36, 'Pounds', 'FKP', '£', '2023-11-07 18:01:38', NULL),
(37, 'Dollars', 'FJD', '$', '2023-11-07 18:01:38', NULL),
(38, 'Cedis', 'GHC', '¢', '2023-11-07 18:01:38', NULL),
(39, 'Pounds', 'GIP', '£', '2023-11-07 18:01:38', NULL),
(40, 'Quetzales', 'GTQ', 'Q', '2023-11-07 18:01:38', NULL),
(41, 'Pounds', 'GGP', '£', '2023-11-07 18:01:38', NULL),
(42, 'Dollars', 'GYD', '$', '2023-11-07 18:01:38', NULL),
(43, 'Lempiras', 'HNL', 'L', '2023-11-07 18:01:38', NULL),
(44, 'Dollars', 'HKD', '$', '2023-11-07 18:01:38', NULL),
(45, 'Forint', 'HUF', 'Ft', '2023-11-07 18:01:38', NULL),
(46, 'Kronur', 'ISK', 'kr', '2023-11-07 18:01:38', NULL),
(47, 'Rupees', 'INR', 'Rp', '2023-11-07 18:01:38', NULL),
(48, 'Rupiahs', 'IDR', 'Rp', '2023-11-07 18:01:38', NULL),
(49, 'Rials', 'IRR', '﷼', '2023-11-07 18:01:38', NULL),
(50, 'Pounds', 'IMP', '£', '2023-11-07 18:01:38', NULL),
(51, 'New Shekels', 'ILS', '₪', '2023-11-07 18:01:38', NULL),
(52, 'Dollars', 'JMD', 'J$', '2023-11-07 18:01:38', NULL),
(53, 'Yen', 'JPY', '¥', '2023-11-07 18:01:38', NULL),
(54, 'Pounds', 'JEP', '£', '2023-11-07 18:01:38', NULL),
(55, 'Tenge', 'KZT', 'лв', '2023-11-07 18:01:38', NULL),
(56, 'Won', 'KPW', '₩', '2023-11-07 18:01:38', NULL),
(57, 'Won', 'KRW', '₩', '2023-11-07 18:01:38', NULL),
(58, 'Soms', 'KGS', 'лв', '2023-11-07 18:01:38', NULL),
(59, 'Kips', 'LAK', '₭', '2023-11-07 18:01:38', NULL),
(60, 'Lati', 'LVL', 'Ls', '2023-11-07 18:01:38', NULL),
(61, 'Pounds', 'LBP', '£', '2023-11-07 18:01:38', NULL),
(62, 'Dollars', 'LRD', '$', '2023-11-07 18:01:38', NULL),
(63, 'Switzerland Francs', 'CHF', 'CHF', '2023-11-07 18:01:38', NULL),
(64, 'Litai', 'LTL', 'Lt', '2023-11-07 18:01:38', NULL),
(65, 'Denars', 'MKD', 'ден', '2023-11-07 18:01:38', NULL),
(66, 'Ringgits', 'MYR', 'RM', '2023-11-07 18:01:38', NULL),
(67, 'Rupees', 'MUR', '₨', '2023-11-07 18:01:38', NULL),
(68, 'Pesos', 'MXN', '$', '2023-11-07 18:01:38', NULL),
(69, 'Tugriks', 'MNT', '₮', '2023-11-07 18:01:38', NULL),
(70, 'Meticais', 'MZN', 'MT', '2023-11-07 18:01:38', NULL),
(71, 'Dollars', 'NAD', '$', '2023-11-07 18:01:38', NULL),
(72, 'Rupees', 'NPR', '₨', '2023-11-07 18:01:38', NULL),
(73, 'Guilders', 'ANG', 'ƒ', '2023-11-07 18:01:38', NULL),
(74, 'Dollars', 'NZD', '$', '2023-11-07 18:01:38', NULL),
(75, 'Cordobas', 'NIO', 'C$', '2023-11-07 18:01:38', NULL),
(76, 'Nairas', 'NGN', '₦', '2023-11-07 18:01:38', NULL),
(77, 'Krone', 'NOK', 'kr', '2023-11-07 18:01:38', NULL),
(78, 'Rials', 'OMR', '﷼', '2023-11-07 18:01:38', NULL),
(79, 'Rupees', 'PKR', '₨', '2023-11-07 18:01:38', NULL),
(80, 'Balboa', 'PAB', 'B/.', '2023-11-07 18:01:38', NULL),
(81, 'Guarani', 'PYG', 'Gs', '2023-11-07 18:01:38', NULL),
(82, 'Nuevos Soles', 'PEN', 'S/.', '2023-11-07 18:01:38', NULL),
(83, 'Pesos', 'PHP', 'Php', '2023-11-07 18:01:38', NULL),
(84, 'Zlotych', 'PLN', 'zł', '2023-11-07 18:01:38', NULL),
(85, 'Rials', 'QAR', '﷼', '2023-11-07 18:01:38', NULL),
(86, 'New Lei', 'RON', 'lei', '2023-11-07 18:01:38', NULL),
(87, 'Rubles', 'RUB', 'руб', '2023-11-07 18:01:38', NULL),
(88, 'Pounds', 'SHP', '£', '2023-11-07 18:01:38', NULL),
(89, 'Riyals', 'SAR', '﷼', '2023-11-07 18:01:38', NULL),
(90, 'Dinars', 'RSD', 'Дин.', '2023-11-07 18:01:38', NULL),
(91, 'Rupees', 'SCR', '₨', '2023-11-07 18:01:38', NULL),
(92, 'Dollars', 'SGD', '$', '2023-11-07 18:01:38', NULL),
(93, 'Dollars', 'SBD', '$', '2023-11-07 18:01:38', NULL),
(94, 'Shillings', 'SOS', 'S', '2023-11-07 18:01:38', NULL),
(95, 'Rand', 'ZAR', 'R', '2023-11-07 18:01:38', NULL),
(96, 'Rupees', 'LKR', '₨', '2023-11-07 18:01:38', NULL),
(97, 'Kronor', 'SEK', 'kr', '2023-11-07 18:01:38', NULL),
(98, 'Dollars', 'SRD', '$', '2023-11-07 18:01:38', NULL),
(99, 'Pounds', 'SYP', '£', '2023-11-07 18:01:38', NULL),
(100, 'New Dollars', 'TWD', 'NT$', '2023-11-07 18:01:38', NULL),
(101, 'Baht', 'THB', '฿', '2023-11-07 18:01:38', NULL),
(102, 'Dollars', 'TTD', 'TT$', '2023-11-07 18:01:38', NULL),
(103, 'Lira', 'TRY', '₺', '2023-11-07 18:01:38', NULL),
(104, 'Liras', 'TRL', '£', '2023-11-07 18:01:38', NULL),
(105, 'Dollars', 'TVD', '$', '2023-11-07 18:01:38', NULL),
(106, 'Hryvnia', 'UAH', '₴', '2023-11-07 18:01:38', NULL),
(107, 'Pesos', 'UYU', '$U', '2023-11-07 18:01:38', NULL),
(108, 'Sums', 'UZS', 'лв', '2023-11-07 18:01:38', NULL),
(109, 'Bolivares Fuertes', 'VEF', 'Bs', '2023-11-07 18:01:38', NULL),
(110, 'Dong', 'VND', '₫', '2023-11-07 18:01:38', NULL),
(111, 'Rials', 'YER', '﷼', '2023-11-07 18:01:38', NULL),
(112, 'Zimbabwe Dollars', 'ZWD', 'Z$', '2023-11-07 18:01:38', NULL),
(113, 'Rupees', 'INR', '₹', '2023-11-07 18:01:38', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `currency_alloweds`
--

CREATE TABLE `currency_alloweds` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `currency_id` bigint(20) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `custom_layouts`
--

CREATE TABLE `custom_layouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `font_family_default` varchar(191) DEFAULT NULL,
  `primary_color` varchar(20) NOT NULL DEFAULT '#0073D2',
  `primary_opacity_color` varchar(20) DEFAULT NULL,
  `secundary_color` varchar(20) NOT NULL DEFAULT '#084375',
  `gray_dark_color` varchar(20) NOT NULL DEFAULT '#3b3b3b',
  `gray_light_color` varchar(20) NOT NULL DEFAULT '#c9c9c9',
  `gray_medium_color` varchar(20) NOT NULL DEFAULT '#676767',
  `gray_over_color` varchar(20) NOT NULL DEFAULT '#1A1C20',
  `title_color` varchar(20) NOT NULL DEFAULT '#ffffff',
  `text_color` varchar(20) NOT NULL DEFAULT '#98A7B5',
  `sub_text_color` varchar(20) NOT NULL DEFAULT '#656E78',
  `placeholder_color` varchar(20) NOT NULL DEFAULT '#4D565E',
  `background_color` varchar(20) NOT NULL DEFAULT '#24262B',
  `background_base` varchar(20) DEFAULT '#ECEFF1',
  `background_base_dark` varchar(20) DEFAULT '#24262B',
  `carousel_banners` varchar(20) DEFAULT '#1E2024',
  `carousel_banners_dark` varchar(20) DEFAULT '#1E2024',
  `sidebar_color` varchar(20) DEFAULT NULL,
  `sidebar_color_dark` varchar(20) DEFAULT NULL,
  `navtop_color` varchar(20) DEFAULT NULL,
  `navtop_color_dark` varchar(20) DEFAULT NULL,
  `side_menu` varchar(20) DEFAULT NULL,
  `side_menu_dark` varchar(20) DEFAULT NULL,
  `input_primary` varchar(20) DEFAULT NULL,
  `input_primary_dark` varchar(20) DEFAULT NULL,
  `footer_color` varchar(20) DEFAULT NULL,
  `footer_color_dark` varchar(20) DEFAULT NULL,
  `card_color` varchar(20) DEFAULT NULL,
  `card_color_dark` varchar(20) DEFAULT NULL,
  `border_radius` varchar(20) NOT NULL DEFAULT '.25rem',
  `custom_css` text DEFAULT NULL,
  `custom_js` text DEFAULT NULL,
  `custom_header` longtext DEFAULT NULL,
  `custom_body` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `instagram` varchar(191) DEFAULT NULL,
  `facebook` varchar(191) DEFAULT NULL,
  `telegram` varchar(191) DEFAULT NULL,
  `twitter` varchar(191) DEFAULT NULL,
  `whastapp` varchar(191) DEFAULT NULL,
  `youtube` varchar(191) DEFAULT NULL,
  `linkcassino` varchar(191) DEFAULT NULL,
  `texto_deposito` varchar(191) DEFAULT NULL,
  `texto_header` varchar(191) DEFAULT NULL,
  `texto_bonus` varchar(191) DEFAULT NULL,
  `cc_topo_botao` varchar(20) DEFAULT NULL,
  `barra_logo` varchar(20) DEFAULT NULL,
  `icone_presente` varchar(20) DEFAULT NULL,
  `menu_lateral` varchar(20) DEFAULT NULL,
  `cor_fundo` varchar(20) DEFAULT NULL,
  `fundo_icone` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `custom_layouts`
--

INSERT INTO `custom_layouts` (`id`, `font_family_default`, `primary_color`, `primary_opacity_color`, `secundary_color`, `gray_dark_color`, `gray_light_color`, `gray_medium_color`, `gray_over_color`, `title_color`, `text_color`, `sub_text_color`, `placeholder_color`, `background_color`, `background_base`, `background_base_dark`, `carousel_banners`, `carousel_banners_dark`, `sidebar_color`, `sidebar_color_dark`, `navtop_color`, `navtop_color_dark`, `side_menu`, `side_menu_dark`, `input_primary`, `input_primary_dark`, `footer_color`, `footer_color_dark`, `card_color`, `card_color_dark`, `border_radius`, `custom_css`, `custom_js`, `custom_header`, `custom_body`, `created_at`, `updated_at`, `instagram`, `facebook`, `telegram`, `twitter`, `whastapp`, `youtube`, `linkcassino`, `texto_deposito`, `texto_header`, `texto_bonus`, `cc_topo_botao`, `barra_logo`, `icone_presente`, `menu_lateral`, `cor_fundo`, `fundo_icone`) VALUES
(1, '\'Roboto Condensed\', sans-serif', '#1da639', '#03ad4022', '#0db849', '#3b3b3b', '#c9c9c9', '#676767', '#191A1E', '#ffffff', '#98A7B5', '#656E78', '#4D565E', '#24262B', '#e8e8e8', '#24262B', '#bdbdbd', '#1E2024', '#ffffff', '#191A1E', '#d8d8de', '#24262B', '#828282', '#000000', '#dedede', '#1E2024', '#919191', '#1E2024', '#ababab', '#1E2024', '.25rem', '.screen-button{\ndisplay: none !important;\n}', '', '', '', '2024-01-01 14:36:03', '2025-06-10 23:27:35', 'https://www.instagram.com/', '', 'https://t.me/', '', 'https://chat.whatsapp.com/', '', 'fortuna777.online', '', '💥 Indique um amigo e ganhe R$ 10,00 de saldo REAL para cada amigo que convidar', 'Ganhe R$ 10,00 grátis', '#007fff', '#00004f', '#007fff', '#020d2b', '#020d2b', '#04274a');

-- --------------------------------------------------------

--
-- Estrutura para tabela `debug`
--

CREATE TABLE `debug` (
  `text` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `deposits`
--

CREATE TABLE `deposits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `payment_id` varchar(191) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(20,2) NOT NULL DEFAULT 0.00,
  `type` varchar(191) NOT NULL,
  `proof` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `currency` varchar(50) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `deposit_bonus_log`
--

CREATE TABLE `deposit_bonus_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(20) NOT NULL,
  `transaction_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `deposit_bonus_log`
--

INSERT INTO `deposit_bonus_log` (`id`, `user_id`, `type`, `transaction_id`, `amount`, `created_at`, `updated_at`) VALUES
(1, 1, 'roulette', 10, 20.00, '2026-10-01 23:28:18', '2026-10-01 23:28:18'),
(2, 1, 'freespin', 10, 20.00, '2026-10-01 23:28:18', '2026-10-01 23:28:18');

-- --------------------------------------------------------

--
-- Estrutura para tabela `digito_pay_payments`
--

CREATE TABLE `digito_pay_payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` varchar(191) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_id` bigint(20) UNSIGNED NOT NULL,
  `pix_key` varchar(191) NOT NULL,
  `pix_type` varchar(191) NOT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `observation` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `freespin_config`
--

CREATE TABLE `freespin_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `game_id` bigint(20) UNSIGNED DEFAULT NULL,
  `game_code` varchar(100) DEFAULT NULL,
  `game_name` varchar(191) DEFAULT NULL,
  `rounds` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `bet` decimal(10,2) DEFAULT NULL,
  `min_deposit` decimal(12,2) NOT NULL DEFAULT 20.00,
  `max_times` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `expire_days` int(10) UNSIGNED NOT NULL DEFAULT 7,
  `win_rollover` decimal(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `freespin_config`
--

INSERT INTO `freespin_config` (`id`, `active`, `game_id`, `game_code`, `game_name`, `rounds`, `bet`, `min_deposit`, `max_times`, `expire_days`, `win_rollover`, `created_at`, `updated_at`) VALUES
(1, 1, 1198, 'mg-mines', 'Mines', 25, 0.50, 20.00, 1, 7, 1.00, '2026-10-02 02:18:00', '2026-10-01 23:23:17');

-- --------------------------------------------------------

--
-- Estrutura para tabela `free_spins`
--

CREATE TABLE `free_spins` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED DEFAULT NULL,
  `game_code` varchar(100) NOT NULL,
  `game_name` varchar(191) DEFAULT NULL,
  `rounds` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `rounds_played` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `bet` decimal(10,2) DEFAULT NULL,
  `total_win` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` varchar(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, active, completed, expired, cancelled, failed',
  `origin` varchar(30) NOT NULL DEFAULT 'deposit',
  `transaction_id` bigint(20) UNSIGNED DEFAULT NULL,
  `external_id` bigint(20) UNSIGNED DEFAULT NULL,
  `error` varchar(255) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `games`
--

CREATE TABLE `games` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` int(10) UNSIGNED NOT NULL,
  `game_name` varchar(191) NOT NULL,
  `game_id` varchar(191) NOT NULL,
  `game_type` varchar(191) DEFAULT NULL,
  `cover` varchar(191) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT '1',
  `technology` varchar(191) DEFAULT 'html5',
  `distribution` varchar(191) NOT NULL DEFAULT 'proftgames',
  `views` bigint(20) NOT NULL DEFAULT 0,
  `is_featured` tinyint(4) DEFAULT 0,
  `show_home` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `game_code` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `games`
--

INSERT INTO `games` (`id`, `provider_id`, `game_name`, `game_id`, `game_type`, `cover`, `cover_url`, `status`, `technology`, `distribution`, `views`, `is_featured`, `show_home`, `created_at`, `updated_at`, `game_code`) VALUES
(1, 1, 'Dice', 'mg-dice', 'minigames', 'ProftGames/ORIGINAIS_mg-dice.png', 'https://proftgames.com/uploads/games/game-67-489ff14afcd0.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-dice'),
(2, 1, 'Plinko', 'mg-plinko', 'minigames', 'ProftGames/ORIGINAIS_mg-plinko.png', 'https://proftgames.com/uploads/games/game-68-95a67ab75c9c.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-plinko'),
(3, 1, 'Keno', 'mg-keno', 'minigames', 'ProftGames/ORIGINAIS_mg-keno.png', 'https://proftgames.com/uploads/games/game-69-e539c04e6403.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-keno'),
(4, 1, 'Double', 'mg-double', 'minigames', 'ProftGames/ORIGINAIS_mg-double.png', 'https://proftgames.com/uploads/games/game-70-25673124f249.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-double'),
(5, 1, 'Cara ou Coroa', 'mg-coinflip', 'minigames', 'ProftGames/ORIGINAIS_mg-coinflip.png', 'https://proftgames.com/uploads/games/game-71-fda593889e16.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-coinflip'),
(6, 1, 'Crash', 'mg-crash', 'minigames', 'ProftGames/ORIGINAIS_mg-crash.png', 'https://proftgames.com/uploads/games/game-72-49981b68b61a.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-crash'),
(7, 1, 'Mines', 'mg-mines', 'minigames', 'ProftGames/ORIGINAIS_mg-mines.png', 'https://proftgames.com/uploads/games/game-73-ac5b71670901.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-mines'),
(8, 1, 'Tower', 'mg-tower', 'minigames', 'ProftGames/ORIGINAIS_mg-tower.png', 'https://proftgames.com/uploads/games/game-74-a22faaa09c36.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-tower'),
(9, 1, 'Stairs', 'mg-stairs', 'minigames', 'ProftGames/ORIGINAIS_mg-stairs.png', 'https://proftgames.com/uploads/games/game-75-75cad787f1d0.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-stairs'),
(10, 1, 'HiLo', 'mg-hilo', 'minigames', 'ProftGames/ORIGINAIS_mg-hilo.png', 'https://proftgames.com/uploads/games/game-76-bc6352609e92.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-hilo'),
(11, 1, 'Blackjack', 'mg-blackjack', 'minigames', 'ProftGames/ORIGINAIS_mg-blackjack.png', 'https://proftgames.com/uploads/games/game-77-1c77f4840e71.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-blackjack'),
(12, 1, 'Roleta', 'mg-roulette', 'minigames', 'ProftGames/ORIGINAIS_mg-roulette.png', 'https://proftgames.com/uploads/games/game-78-0b24ae4e72ce.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mg-roulette'),
(13, 2, 'Fortune Tiger', 'fortune-tiger', 'slots', 'ProftGames/PGSOFT_fortune-tiger.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2000126/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fortune-tiger'),
(14, 2, 'Fortune Ox', 'fortune-ox', 'slots', 'ProftGames/PGSOFT_fortune-ox.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2000098/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fortune-ox'),
(15, 2, 'Fortune Dragon', 'fortune-dragon', 'slots', 'ProftGames/PGSOFT_fortune-dragon.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2001027/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fortune-dragon'),
(16, 2, 'Fortune Rabbit', 'fortune-rabbit', 'slots', 'ProftGames/PGSOFT_fortune-rabbit.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2001007/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fortune-rabbit'),
(17, 2, 'Fortune Mouse', 'fortune-mouse', 'slots', 'ProftGames/PGSOFT_fortune-mouse.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2000068/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fortune-mouse'),
(18, 2, 'Bikini Paradise', 'bikini-paradise', 'slots', 'ProftGames/PGSOFT_bikini-paradise.avif', 'https://rf3xd798.xxon9zpi.com/game_pictures/g/EA/200/3/2000069/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'bikini-paradise'),
(19, 2, 'Jungle Delight', 'jungle-delight', 'slots', 'ProftGames/PGSOFT_jungle-delight.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2000040/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'jungle-delight'),
(20, 2, 'Ganesha Gold', 'ganesha-gold', 'slots', 'ProftGames/PGSOFT_ganesha-gold.avif', 'https://gfd8fd.sexisasr.com/game_pictures/g/EA/200/3/2000042/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'ganesha-gold'),
(21, 2, 'Double Fortune', 'double-fortune', 'slots', 'ProftGames/PGSOFT_double-fortune.avif', 'https://rf3xd798.xxon9zpi.com/game_pictures/g/EA/200/3/2000048/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'double-fortune'),
(22, 2, 'Dragon Tiger Luck', 'dragon-tiger-luck', 'slots', 'ProftGames/PGSOFT_dragon-tiger-luck.avif', 'https://rf3xd798.xxon9zpi.com/game_pictures/g/EA/200/3/2000063/default.avif?web_v=v7.5.57', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'dragon-tiger-luck'),
(23, 3, 'Big Bass Keeping it Reel', 'vs10bbkir', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10bbkir.png', 'https://debc8304dd40g.cloudfront.net/games/-a9fab833604d793f9a956e4d0ee7e231.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10bbkir'),
(24, 3, 'Cash Elevator', 'vs10cowgold', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10cowgold.webp', 'https://admin-prod.b6zcdn.com/optimized_images/portrait/pragmaticexternal/CashElevator1.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10cowgold'),
(25, 3, 'Return of the Dead', 'vs10returndead', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10returndead.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs10returndead.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10returndead'),
(26, 3, 'Vampires vs Wolves', 'vs10vampwolf', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10vampwolf.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs10vampwolf.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10vampwolf'),
(27, 3, 'Bigger Bass Bonanza', 'vs12bbb', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs12bbb.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/cd26ec849b14552177152d5f00b9b1d8-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs12bbb'),
(28, 3, 'Bigger Bass Blizzard Christmas Catch', 'vs12bbbxmas', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs12bbbxmas.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/34f415b9e5266bfe4e063b4256002bca-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs12bbbxmas'),
(29, 3, 'Wild Beach Party', 'vs20bchprty', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20bchprty.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20bchprty.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20bchprty'),
(30, 3, 'Bonanza Gold', 'vs20bonzgold', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20bonzgold.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20bonzgold.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20bonzgold'),
(31, 3, 'Candy Village', 'vs20candvil', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20candvil.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20candvil.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20candvil'),
(32, 3, 'Day of Dead', 'vs20daydead', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20daydead.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/-7dbe8ff21bf216c573b49baa1346a03e.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20daydead'),
(33, 3, 'Ancient Egypt', 'vs20egypt', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20egypt.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs10egypt.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20egypt'),
(34, 3, 'Sweet Bonanza', 'vs20fruitsw', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20fruitsw.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/c77fa594da0490f2c298f9a9f518266b-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20fruitsw'),
(35, 3, 'Gates of Olympus', 'vs20olympgate', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20olympgate.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/29d8559e14cc09c33509d4e455e4ada8-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20olympgate'),
(36, 3, 'Pirate Gold', 'vs20pbonanza', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20pbonanza.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs40pirate.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20pbonanza'),
(37, 3, 'Sweet Bonanza Xmas', 'vs20sbxmas', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20sbxmas.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/3300ed7bb1b8eba3e062603e754d5bb6-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20sbxmas'),
(38, 3, 'Santa', 'vs20schristmas', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20schristmas.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/3c819fb16648eac882a5c4352d1447ff-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20schristmas'),
(39, 3, 'Sugar Rush', 'vs20sugarrush', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20sugarrush.png', 'https://debc8304dd40g.cloudfront.net/games/-a26165d30b16d9b777c3beac3161a930.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20sugarrush'),
(40, 3, 'Sugar Rush Xmas', 'vs20sugarrushx', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20sugarrushx.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/-170d6e516315928c94934583a2d5fd10.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20sugarrushx'),
(41, 3, 'The Tweety House', 'vs20tweethouse', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20tweethouse.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20tweethouse.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20tweethouse'),
(42, 3, 'Wild Booster', 'vs20wildboost', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20wildboost.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20wildboost.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20wildboost'),
(43, 3, 'Wild Pixies', 'vs20wildpix', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20wildpix.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs20wildpix.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20wildpix'),
(44, 3, 'Chilli Heat', 'vs25chilli', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs25chilli.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/cdb3392788ac0e69d0cb79c669b1aa6d-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs25chilli'),
(45, 3, 'Gladiator', 'vs25gladiator', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs25gladiator.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs25gladiator.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs25gladiator'),
(46, 3, 'Pyramid King', 'vs25pyramid', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs25pyramid.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs25pyramid.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs25pyramid'),
(47, 3, 'Tiger Warrior', 'vs25tigerwar', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs25tigerwar.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs25tigerwar.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs25tigerwar'),
(48, 3, 'Wolf Gold', 'vs25wolfgold', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs25wolfgold.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/dc317c2859c0c49f5291b149f01ae88c-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs25wolfgold'),
(49, 3, 'Pirate Gold Deluxe', 'vs40pirate', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs40pirate.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs40pirgold.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs40pirate'),
(50, 3, 'Rise of Samurai 3', 'vs40samurai3', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs40samurai3.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs40samurai3.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs40samurai3'),
(51, 3, 'Spartan King', 'vs40spartaking', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs40spartaking.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs40spartaking.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs40spartaking'),
(52, 3, 'Wild West Gold', 'vs40wildwest', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs40wildwest.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/791af58954dc2e7d38a8416d43c24920-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs40wildwest'),
(53, 3, 'Safari King', 'vs50safariking', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs50safariking.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs50safariking.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs50safariking'),
(54, 3, 'Star Rush', 'vs5strh', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs5strh.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs5strh.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs5strh'),
(55, 3, 'Super 7s', 'vs5super7', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs5super7.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/685d5348b619981c39f4cfb6f0585262-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs5super7'),
(56, 3, 'Big Bass Bonanza', 'vs10bbbonanza', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10bbbonanza.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/722aeceb69dd18fb02b3f0dca848901a-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10bbbonanza'),
(57, 3, 'Big Bass Bonanza Christmas', 'vs10bxmasbnza', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10bxmasbnza.webp', 'https://imagensfivers.com/Games/Pragmatic-Play/PP_vs10bbsplxmas.webp', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10bxmasbnza'),
(58, 3, 'Big Bass Splash', 'vs10txbigbass', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs10txbigbass.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/a457ca4ef837b2934d0fad976a3d3b1f-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs10txbigbass'),
(59, 3, 'The Dog House', 'vs20doghouse', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20doghouse.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/db54a9c78dbc7cad2d133cb8f8317f5c-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20doghouse'),
(60, 3, 'Starlight Princess', 'vs20starlight', 'slots', 'ProftGames/PRAGMATIC_PLAY_vs20starlight.png', 'https://d3fwl9ttzumvxe.cloudfront.net/games/39396381625dae24c039cd74de958b4b-n.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'vs20starlight'),
(61, 4, 'Subway Surfers', 'subway', 'skill', 'ProftGames/GAMES_RETRO_subway.png', 'https://proftgames.com/uploads/games/game-49-b0982ee68559.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'subway'),
(62, 4, 'Candy Match 3', 'candy', 'skill', 'ProftGames/GAMES_RETRO_candy.png', 'https://proftgames.com/uploads/games/game-53-cb4ef6d26879.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'candy'),
(63, 4, 'Dino Run', 'dino', 'skill', 'ProftGames/GAMES_RETRO_dino.png', 'https://proftgames.com/uploads/games/game-54-b7eb78b13b04.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'dino'),
(64, 4, 'Flappy Dragon', 'dragoncash', 'skill', 'ProftGames/GAMES_RETRO_dragoncash.png', 'https://proftgames.com/uploads/games/game-55-554552abaa5e.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'dragoncash'),
(65, 4, 'Flappy Money', 'flappy', 'skill', 'ProftGames/GAMES_RETRO_flappy.png', 'https://proftgames.com/uploads/games/game-56-c28324f14e9e.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'flappy'),
(66, 4, 'Flappy Copter', 'flappycopter', 'skill', 'ProftGames/GAMES_RETRO_flappycopter.png', 'https://proftgames.com/uploads/games/game-57-9cdb5ae8857b.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'flappycopter'),
(67, 4, 'Fruit Slice', 'fruit', 'skill', 'ProftGames/GAMES_RETRO_fruit.png', 'https://proftgames.com/uploads/games/game-58-d7eb5672a7af.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'fruit'),
(68, 4, 'Rock Music Game', 'guitarhero', 'skill', 'ProftGames/GAMES_RETRO_guitarhero.png', 'https://proftgames.com/uploads/games/game-59-d4027db03e57.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'guitarhero'),
(69, 4, 'Jetpack Heroes', 'jetpack', 'skill', 'ProftGames/GAMES_RETRO_jetpack.png', 'https://proftgames.com/uploads/games/game-60-67ec6aa9829d.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'jetpack'),
(70, 4, 'T-Rex Runner', 'jurassiccash', 'skill', 'ProftGames/GAMES_RETRO_jurassiccash.png', 'https://proftgames.com/uploads/games/game-61-4d9f1d0d9366.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'jurassiccash'),
(71, 4, 'Mario Cash', 'mario', 'skill', 'ProftGames/GAMES_RETRO_mario.jpg', 'https://proftgames.com/uploads/games/game-62-bb12e71a9436.jpg', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'mario'),
(72, 4, 'Super RoboMax', 'megaman', 'skill', 'ProftGames/GAMES_RETRO_megaman.png', 'https://proftgames.com/uploads/games/game-63-593c57ba9d22.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'megaman'),
(73, 4, 'Sonic Dash Run', 'sonic', 'skill', 'ProftGames/GAMES_RETRO_sonic.png', 'https://proftgames.com/uploads/games/game-64-ac7b6bdcb5d7.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'sonic'),
(74, 4, 'Temple Runner', 'tample', 'skill', 'ProftGames/GAMES_RETRO_tample.png', 'https://proftgames.com/uploads/games/game-65-11792526e313.png', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'tample'),
(75, 4, 'Angry Birds', 'angry', 'skill', 'ProftGames/GAMES_RETRO_angry.jpg', 'https://proftgames.com/uploads/games/game-66-9341b16b8916.jpg', '1', 'html5', 'proftgames', 0, 0, 1, '2026-10-17 17:08:01', '2026-10-17 17:08:01', 'angry');

-- --------------------------------------------------------

--
-- Estrutura para tabela `games_keys`
--

CREATE TABLE `games_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `proftgames_code` varchar(191) DEFAULT NULL,
  `proftgames_token` varchar(191) DEFAULT NULL,
  `proftgames_secret` varchar(191) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `games_keys`
--

INSERT INTO `games_keys` (`id`, `updated_at`, `proftgames_code`, `proftgames_token`, `proftgames_secret`) VALUES
(1, '2026-10-01 23:37:45', 'Aqui', 'Aqui', 'Aqui');

-- --------------------------------------------------------

--
-- Estrutura para tabela `game_favorites`
--

CREATE TABLE `game_favorites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `game_likes`
--

CREATE TABLE `game_likes` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

--
-- Despejando dados para a tabela `game_likes`
--

INSERT INTO `game_likes` (`user_id`, `game_id`, `created_at`, `updated_at`) VALUES
(1, 1192, '2026-10-01 21:41:00', '2026-10-01 21:41:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `game_reviews`
--

CREATE TABLE `game_reviews` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `game_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `description` varchar(191) NOT NULL,
  `rating` int(11) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gateways`
--

CREATE TABLE `gateways` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `suitpay_uri` varchar(191) DEFAULT NULL,
  `suitpay_cliente_id` varchar(191) DEFAULT NULL,
  `suitpay_cliente_secret` varchar(191) DEFAULT NULL,
  `stripe_production` tinyint(4) DEFAULT 0,
  `stripe_public_key` varchar(255) DEFAULT NULL,
  `stripe_secret_key` varchar(255) DEFAULT NULL,
  `stripe_webhook_key` varchar(255) DEFAULT NULL,
  `bspay_uri` varchar(255) DEFAULT NULL,
  `bspay_cliente_id` varchar(255) DEFAULT NULL,
  `bspay_cliente_secret` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `public_key` varchar(191) DEFAULT NULL,
  `private_key` varchar(191) DEFAULT NULL,
  `mp_client_id` varchar(191) DEFAULT NULL,
  `mp_client_secret` varchar(191) DEFAULT NULL,
  `mp_public_key` varchar(191) DEFAULT NULL,
  `mp_access_token` varchar(191) DEFAULT NULL,
  `digitopay_uri` varchar(191) DEFAULT NULL,
  `digitopay_cliente_id` varchar(191) DEFAULT NULL,
  `digitopay_cliente_secret` varchar(191) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `gateways`
--

INSERT INTO `gateways` (`id`, `suitpay_uri`, `suitpay_cliente_id`, `suitpay_cliente_secret`, `stripe_production`, `stripe_public_key`, `stripe_secret_key`, `stripe_webhook_key`, `bspay_uri`, `bspay_cliente_id`, `bspay_cliente_secret`, `created_at`, `updated_at`, `public_key`, `private_key`, `mp_client_id`, `mp_client_secret`, `mp_public_key`, `mp_access_token`, `digitopay_uri`, `digitopay_cliente_id`, `digitopay_cliente_secret`) VALUES
(1, 'https://api.ecompag.com/v2/', 'Aqui', 'Aqui', 0, NULL, NULL, NULL, NULL, NULL, NULL, '2023-11-30 21:05:51', '2026-10-01 23:38:29', NULL, NULL, NULL, NULL, NULL, NULL, 'https://si5n56mrnjzvt5gr2f536ildr40sqzke.lambda-url.sa-east-1.on.aws/', 'fba5b19f-5d9b-420c-a0d2-8c0f605390c5', 'fde0478c-2d27-4c0d-9a56-e6cb81d25e7b');

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggds_spin_config`
--

CREATE TABLE `ggds_spin_config` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `prizes` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

--
-- Despejando dados para a tabela `ggds_spin_config`
--

INSERT INTO `ggds_spin_config` (`id`, `prizes`, `created_at`, `updated_at`) VALUES
(1, '[{\"currency\":\"BRL\",\"value\":5},{\"currency\":\"BRL\",\"value\":10},{\"currency\":\"BRL\",\"value\":25},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":40},{\"currency\":\"BRL\",\"value\":50},{\"currency\":\"BRL\",\"value\":90},{\"currency\":\"BRL\",\"value\":100},{\"currency\":\"BRL\",\"value\":140},{\"currency\":\"BRL\",\"value\":15},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":500},{\"currency\":\"BRL\",\"value\":1000},{\"currency\":\"BRL\",\"value\":1500},{\"currency\":\"BRL\",\"value\":2000},{\"currency\":\"BRL\",\"value\":2500}]', '2024-01-11 20:52:59', '2024-01-14 17:07:12');

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggds_spin_runs`
--

CREATE TABLE `ggds_spin_runs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `nonce` varchar(255) NOT NULL,
  `possibilities` text NOT NULL,
  `prize` varchar(191) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

--
-- Despejando dados para a tabela `ggds_spin_runs`
--

INSERT INTO `ggds_spin_runs` (`id`, `key`, `nonce`, `possibilities`, `prize`, `created_at`, `updated_at`) VALUES
(1, 'bccec5b62ab37e996470f8bb36ff83ea127a73f17f31cba275453f5ed7b24c34', '592f4304-4837-4a81-8f27-6c3ac412c7dc', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":2000}', '2024-01-12 15:49:28', '2024-01-12 15:49:28'),
(2, '93f0c422ecb15337d358cca690529c9db7d9b7a52acc0727092b938ade4e1c9b', 'eff5d8c3-475b-4994-a49d-778cf06aebf4', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":25}', '2024-01-12 15:51:01', '2024-01-12 15:51:01'),
(3, 'c7f0b2cc871954aa3a03f680969f029034d111e5550ee0769389fefe3fd6f9fd', '203098ef-3347-4938-813e-91be82891cbc', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":105}', '2024-01-12 15:51:34', '2024-01-12 15:51:34'),
(4, '5b4059c88237be6a78ff1fb35e427fd1e4e1a30184ced8d3e4ed9044a0939663', '65cf85de-3dee-48f4-a1d3-d26a8f89ba16', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":2000}', '2024-01-12 16:56:56', '2024-01-12 16:56:56'),
(5, '0901814bf6598c5c7e1072abcc8fa16290dff49b3c2aa44a9346cee34444f98f', '79519214-2125-4ed5-a672-45973c8af5eb', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":2500}', '2024-01-12 16:57:47', '2024-01-12 16:57:47'),
(6, '7b5642d63b3081907a3b7489794ba74f3052fe490095e7354d98570f6c4e5a6c', 'e5b728db-07e3-4531-910b-7c85f1555973', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":9.79}', '2024-01-12 18:51:25', '2024-01-12 18:51:25'),
(7, '001f8f60f30e431a9f28d39a4db43e0b3e03d0379816fe04ff5007aca5d0a14e', '4ab2acba-57f3-46f4-9dc6-c32e993fb995', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":1500}', '2024-01-12 19:13:25', '2024-01-12 19:13:25'),
(8, '8a801a13e786df312b4d3a2a023b5472cfca776b2b9524af3c12fac4e00bb935', 'e050a5ad-ab8a-4922-95cc-6fae7f62be99', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":2500}', '2024-01-12 19:40:12', '2024-01-12 19:40:12'),
(9, '3432d11c1efd935afcf84fba6c3466c3c98aee06c63163368a18b7d07749ea66', 'de330a3f-b3d0-41ef-94ae-2cee7686f341', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":15}', '2024-01-12 20:01:33', '2024-01-12 20:01:33'),
(10, 'cf741c182225f003f16fb815517a3d94d9cde7e16d767766864c7536ae51e101', 'ec3a409c-159f-4723-848c-7a45fe838c65', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":105}', '2024-01-12 20:26:04', '2024-01-12 20:26:04'),
(11, 'f7a528bd425441c09093c146b4456acc0391b2aaf6af26ed7282dd8b153411df', 'b9e39a17-328e-4730-979f-bd37714552f1', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":5.02}', '2024-01-13 01:02:21', '2024-01-13 01:02:21'),
(12, '7ec6e7dea1750162832a02bbcb986e3a77e4ea3ece5110b0c8c746e9ab586d27', '876d2835-b5c5-4c2f-997d-007fa566d356', '[{\"currency\":\"brl\",\"value\":5.02},{\"currency\":\"brl\",\"value\":9.79},{\"currency\":\"brl\",\"value\":25},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":40},{\"currency\":\"brl\",\"value\":50},{\"currency\":\"brl\",\"value\":90},{\"currency\":\"brl\",\"value\":105},{\"currency\":\"brl\",\"value\":140},{\"currency\":\"brl\",\"value\":15},{\"currency\":\"brl\",\"value\":30},{\"currency\":\"brl\",\"value\":500},{\"currency\":\"brl\",\"value\":980},{\"currency\":\"brl\",\"value\":1500},{\"currency\":\"brl\",\"value\":2000},{\"currency\":\"brl\",\"value\":2500}]', '{\"currency\":\"brl\",\"value\":980}', '2024-01-13 13:40:26', '2024-01-13 13:40:26'),
(13, '7980558afa73f95c09d898c3f40a488de06097822831729b21659e6e330d6f92', '19962ee0-52f1-45dd-b858-4003deb2eb43', '[{\"currency\":\"BRL\",\"value\":5},{\"currency\":\"BRL\",\"value\":10},{\"currency\":\"BRL\",\"value\":25},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":40},{\"currency\":\"BRL\",\"value\":50},{\"currency\":\"BRL\",\"value\":90},{\"currency\":\"BRL\",\"value\":100},{\"currency\":\"BRL\",\"value\":140},{\"currency\":\"BRL\",\"value\":15},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":500},{\"currency\":\"BRL\",\"value\":1000},{\"currency\":\"BRL\",\"value\":1500},{\"currency\":\"BRL\",\"value\":2000},{\"currency\":\"BRL\",\"value\":2500}]', '{\"currency\":\"BRL\",\"value\":30}', '2024-01-15 19:28:00', '2024-01-15 19:28:00'),
(14, '22ed3bf22aed02418eb2c527739d06f54cc57e907cd5defb7c6eadf5f55de6ec', 'd096bafd-cb29-4701-93e2-a52b55d65ad3', '[{\"currency\":\"BRL\",\"value\":5},{\"currency\":\"BRL\",\"value\":10},{\"currency\":\"BRL\",\"value\":25},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":40},{\"currency\":\"BRL\",\"value\":50},{\"currency\":\"BRL\",\"value\":90},{\"currency\":\"BRL\",\"value\":100},{\"currency\":\"BRL\",\"value\":140},{\"currency\":\"BRL\",\"value\":15},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":500},{\"currency\":\"BRL\",\"value\":1000},{\"currency\":\"BRL\",\"value\":1500},{\"currency\":\"BRL\",\"value\":2000},{\"currency\":\"BRL\",\"value\":2500}]', '{\"currency\":\"BRL\",\"value\":5}', '2024-06-26 11:09:37', '2024-06-26 11:09:37'),
(15, 'd2d6c288802d56d28fd1752054eb7577ca93c8d2787d1c948c6ee05dec324e7b', '6d496009-e71a-416a-8fb4-5da813029fc2', '[{\"currency\":\"BRL\",\"value\":5},{\"currency\":\"BRL\",\"value\":10},{\"currency\":\"BRL\",\"value\":25},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":40},{\"currency\":\"BRL\",\"value\":50},{\"currency\":\"BRL\",\"value\":90},{\"currency\":\"BRL\",\"value\":100},{\"currency\":\"BRL\",\"value\":140},{\"currency\":\"BRL\",\"value\":15},{\"currency\":\"BRL\",\"value\":30},{\"currency\":\"BRL\",\"value\":500},{\"currency\":\"BRL\",\"value\":1000},{\"currency\":\"BRL\",\"value\":1500},{\"currency\":\"BRL\",\"value\":2000},{\"currency\":\"BRL\",\"value\":2500}]', '{\"currency\":\"BRL\",\"value\":2000}', '2024-06-26 11:09:52', '2024-06-26 11:09:52');

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggr_games`
--

CREATE TABLE `ggr_games` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `provider` varchar(191) NOT NULL,
  `game` varchar(191) NOT NULL,
  `balance_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_win` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(50) DEFAULT NULL,
  `aggregator` varchar(255) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggr_games_drakon`
--

CREATE TABLE `ggr_games_drakon` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `provider` varchar(191) NOT NULL,
  `game` varchar(191) NOT NULL,
  `balance_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_win` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(50) NOT NULL DEFAULT 'BRL',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggr_games_world_slots`
--

CREATE TABLE `ggr_games_world_slots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `provider` varchar(191) NOT NULL,
  `game` varchar(191) NOT NULL,
  `balance_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_win` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(50) NOT NULL DEFAULT 'BRL',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `likes`
--

CREATE TABLE `likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `liked_user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0000_00_00_000000_create_websockets_statistics_entries_table', 1),
(2, '2014_10_12_000000_create_users_table', 1),
(3, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(4, '2019_08_19_000000_create_failed_jobs_table', 1),
(5, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(15, '2023_10_30_034921_create_settings_table', 6),
(7, '2023_11_03_205251_create_sport_categories_table', 1),
(8, '2023_11_03_205252_create_sports_table', 1),
(10, '2023_11_04_001342_create_sport_events_table', 2),
(11, '2023_11_04_213841_add_fields_to_users_table', 3),
(12, '2023_11_07_202919_create_currencies_table', 4),
(13, '2023_11_07_210310_create_wallets_table', 5),
(16, '2023_11_07_214236_create_withdrawals_table', 7),
(17, '2023_11_07_214240_create_deposits_table', 7),
(18, '2023_11_07_214244_create_orders_table', 7),
(19, '2023_11_07_214708_create_suit_pay_payments_table', 7),
(20, '2023_11_07_215204_create_notifications_table', 8),
(21, '2023_11_07_202919_create_currency_alloweds_table', 9),
(22, '2023_11_11_205824_create_casino_categories_table', 9),
(23, '2023_11_11_205834_create_casino_providers_table', 9),
(24, '2023_11_11_205938_create_casino_games_slotgrators_table', 9),
(25, '2023_11_11_210018_create_casino_games_kscinuses_table', 9),
(26, '2023_11_12_225424_create_transactions_table', 10),
(27, '2023_11_12_225431_create_affiliate_histories_table', 10),
(28, '2023_11_12_234643_add_field_to_wallet_table', 11),
(29, '2023_11_14_203632_create_likes_table', 12),
(30, '2023_09_27_214903_create_wallet_changes_table', 13),
(31, '2023_11_16_155140_create_permission_tables', 14),
(32, '2023_11_17_012533_add_language_to_users_table', 15),
(33, '2023_11_22_171616_create_football_leagues_table', 16),
(34, '2023_11_22_175530_create_football_venues_table', 17),
(35, '2023_11_22_175547_create_football_teams_table', 17),
(36, '2023_11_23_143637_create_football_events_table', 18),
(38, '2023_11_29_134520_create_sport_bets_table', 19),
(39, '2023_11_29_135451_create_sport_bets_odds_table', 19),
(40, '2023_11_30_195548_create_gateways_table', 20),
(41, '2023_11_30_195557_create_games_keys_table', 20),
(42, '2023_11_30_195609_create_setting_mails_table', 20),
(43, '2023_10_08_111755_add_fields_to_game_exclusives_table', 20),
(44, '2023_10_07_183921_create_game_exclusives_table', 21),
(45, '2023_10_11_144956_create_system_wallets_table', 22),
(46, '2023_12_18_172721_create_banners_table', 23),
(47, '2023_12_20_135908_create_casino_games_salsas_table', 24),
(48, '2023_12_23_224032_create_fivers_providers_table', 25),
(49, '2023_12_23_224105_create_fivers_games_table', 25),
(50, '2023_12_31_121453_create_custom_layouts_table', 26),
(51, '2024_01_01_193712_create_g_g_r_games_fivers_table', 27),
(52, '2024_01_14_155144_create_missions_table', 28),
(53, '2024_01_14_155150_create_mission_users_table', 28),
(54, '2024_01_19_120728_create_ka_gamings_table', 29),
(55, '2024_01_19_170650_create_categories_table', 30),
(56, '2024_01_19_170657_create_providers_table', 30),
(57, '2024_01_19_170658_create_games_table', 31),
(58, '2023_10_07_183920_create_categories_table', 32),
(59, '2023_10_07_183921_create_providers_table', 33),
(60, '2023_10_07_183922_create_games_table', 34),
(61, '2024_01_20_144529_create_category_games_table', 35),
(62, '2024_01_20_182155_add_vibra_to_games_keys_table', 36),
(63, '2024_01_21_173742_create_game_favorites_table', 37),
(64, '2024_01_21_173752_create_game_likes_table', 37),
(65, '2024_01_21_173803_create_game_reviews_table', 37),
(66, '2024_01_11_231932_create_vibra_casino_games_table', 38),
(69, '2024_01_28_194456_add_vip_to_wallet_table', 40),
(68, '2024_01_28_194645_create_vips_table', 39),
(70, '2024_01_28_231843_create_vip_users_table', 41),
(71, '2024_01_29_102939_add_paid_to_limits_table', 41),
(72, '2024_01_10_001705_create_sub_affiliates_table', 42),
(73, '2024_01_30_120547_create_affiliate_withdraws_table', 43),
(74, '2024_02_09_233936_add_worldslot_to_games_keys_table', 44),
(75, '2024_02_10_191215_add_disable_spin_to_settings_table', 45),
(76, '2024_02_17_210822_add_games2_to_games_keys_table', 46),
(78, '2024_02_20_004853_add_sub_to_settings_table', 47),
(79, '2024_02_24_121146_add_header_to_custom_layouts_table', 48),
(80, '2024_02_26_144235_create_ggr_games_world_slots_table', 49),
(81, '2024_03_01_172613_add_evergame_to_games_keys_table', 50),
(82, '2024_03_03_201700_add_venixkey_to_games_keys_table', 51),
(83, '2024_03_08_201557_add_play_gaming_to_games_keys_table', 52),
(84, '2024_03_21_154342_add_headerbody_to_custom_layouts_table', 53),
(85, '2024_03_21_154342_add_headerbody_to_custom_layouts_table', 54),
(86, '2024_03_21_223739_add_sharkpay_to_gateways_table', 55),
(87, '2024_03_21_230017_add_reference_to_transactions_table', 56),
(88, '2024_03_24_125025_add_rollver_protection_to_settings_table', 57),
(89, '2024_03_24_134101_add_accept_bonus_to_transactions_table', 58),
(90, '2024_03_24_172243_add_receita_to_affiliate_histories_table', 59),
(91, '2024_03_26_161932_add_baseline_column_to_settings_table', 60),
(92, '2024_03_26_234226_add_playigaming_column_to_games_key_table', 61),
(93, '2024_03_25_231103_add_mercado_pago_column_to_gateways_table', 62),
(94, '2024_03_30_215051_add_social_to_custom_layouts_table', 63),
(95, '2024_03_30_225900_create_digito_pay_payments_table', 64),
(96, '2024_03_30_225929_add_digitopay_to_gateways_table', 64),
(97, '2024_03_31_124211_add_digitopay_to_settings_table', 65);

-- --------------------------------------------------------

--
-- Estrutura para tabela `missions`
--

CREATE TABLE `missions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `challenge_name` varchar(191) NOT NULL,
  `challenge_description` text NOT NULL,
  `challenge_rules` text NOT NULL,
  `challenge_type` varchar(20) NOT NULL DEFAULT 'game',
  `challenge_link` varchar(191) DEFAULT NULL,
  `challenge_start_date` datetime NOT NULL,
  `challenge_end_date` datetime NOT NULL,
  `challenge_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
  `challenge_total` bigint(20) NOT NULL DEFAULT 1,
  `challenge_currency` varchar(5) NOT NULL,
  `challenge_provider` varchar(50) DEFAULT NULL,
  `challenge_gameid` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `mission_users`
--

CREATE TABLE `mission_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `mission_id` int(10) UNSIGNED NOT NULL,
  `rounds` bigint(20) DEFAULT 0,
  `rewards` decimal(10,2) DEFAULT 0.00,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Estrutura para tabela `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

--
-- Despejando dados para a tabela `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 34),
(2, 'App\\Models\\User', 38),
(2, 'App\\Models\\User', 39),
(2, 'App\\Models\\User', 40),
(2, 'App\\Models\\User', 46),
(2, 'App\\Models\\User', 49),
(2, 'App\\Models\\User', 52),
(2, 'App\\Models\\User', 61),
(2, 'App\\Models\\User', 68),
(2, 'App\\Models\\User', 70),
(2, 'App\\Models\\User', 73),
(2, 'App\\Models\\User', 74),
(2, 'App\\Models\\User', 78),
(2, 'App\\Models\\User', 91),
(2, 'App\\Models\\User', 95),
(2, 'App\\Models\\User', 102),
(2, 'App\\Models\\User', 107),
(2, 'App\\Models\\User', 115),
(2, 'App\\Models\\User', 116),
(2, 'App\\Models\\User', 121),
(2, 'App\\Models\\User', 122),
(2, 'App\\Models\\User', 123),
(2, 'App\\Models\\User', 125),
(2, 'App\\Models\\User', 126),
(2, 'App\\Models\\User', 127),
(2, 'App\\Models\\User', 133),
(2, 'App\\Models\\User', 134),
(2, 'App\\Models\\User', 135),
(2, 'App\\Models\\User', 140),
(2, 'App\\Models\\User', 145),
(2, 'App\\Models\\User', 149),
(2, 'App\\Models\\User', 151),
(2, 'App\\Models\\User', 156),
(2, 'App\\Models\\User', 173),
(2, 'App\\Models\\User', 176),
(2, 'App\\Models\\User', 180),
(2, 'App\\Models\\User', 188),
(2, 'App\\Models\\User', 190),
(2, 'App\\Models\\User', 191),
(2, 'App\\Models\\User', 194),
(2, 'App\\Models\\User', 197),
(2, 'App\\Models\\User', 208),
(2, 'App\\Models\\User', 213),
(2, 'App\\Models\\User', 216),
(2, 'App\\Models\\User', 220),
(2, 'App\\Models\\User', 225),
(2, 'App\\Models\\User', 226),
(2, 'App\\Models\\User', 233),
(2, 'App\\Models\\User', 237),
(2, 'App\\Models\\User', 239),
(2, 'App\\Models\\User', 243),
(2, 'App\\Models\\User', 256),
(2, 'App\\Models\\User', 269),
(2, 'App\\Models\\User', 278),
(2, 'App\\Models\\User', 283),
(2, 'App\\Models\\User', 285),
(2, 'App\\Models\\User', 292),
(2, 'App\\Models\\User', 295),
(2, 'App\\Models\\User', 299),
(2, 'App\\Models\\User', 301),
(2, 'App\\Models\\User', 310),
(2, 'App\\Models\\User', 312),
(2, 'App\\Models\\User', 314),
(2, 'App\\Models\\User', 327),
(2, 'App\\Models\\User', 328),
(2, 'App\\Models\\User', 329),
(2, 'App\\Models\\User', 333),
(2, 'App\\Models\\User', 335),
(2, 'App\\Models\\User', 336),
(2, 'App\\Models\\User', 337),
(2, 'App\\Models\\User', 339),
(2, 'App\\Models\\User', 342),
(2, 'App\\Models\\User', 352),
(2, 'App\\Models\\User', 354),
(2, 'App\\Models\\User', 363),
(2, 'App\\Models\\User', 369),
(2, 'App\\Models\\User', 376);

-- --------------------------------------------------------

--
-- Estrutura para tabela `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(191) NOT NULL,
  `notifiable_type` varchar(191) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `session_id` varchar(191) DEFAULT NULL,
  `transaction_id` varchar(191) DEFAULT NULL,
  `game` varchar(191) NOT NULL,
  `game_uuid` varchar(191) NOT NULL,
  `type` varchar(50) NOT NULL,
  `type_money` varchar(50) NOT NULL,
  `amount` decimal(20,2) NOT NULL DEFAULT 0.00,
  `providers` varchar(191) NOT NULL,
  `refunded` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `round_id` varchar(255) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

--
-- Despejando dados para a tabela `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'games-exclusive-edit', 'web', '2023-10-12 16:23:45', '2023-10-12 18:12:28'),
(2, 'games-exclusive-view', 'web', '2023-10-12 16:23:56', '2023-10-12 18:11:25'),
(3, 'games-exclusive-create', 'web', '2023-10-12 16:25:06', '2023-10-12 18:11:10'),
(4, 'admin-view', 'web', '2023-10-12 17:56:35', '2023-10-12 17:56:35'),
(5, 'admin-create', 'web', '2023-10-12 18:56:02', '2023-10-12 18:56:02'),
(6, 'admin-edit', 'web', '2023-10-12 18:56:27', '2023-10-12 18:56:27'),
(7, 'admin-delete', 'web', '2023-10-12 18:56:55', '2023-10-12 18:56:55'),
(8, 'category-view', 'web', '2023-10-12 19:01:31', '2023-10-12 19:01:31'),
(9, 'category-create', 'web', '2023-10-12 19:01:46', '2023-10-12 19:01:46'),
(10, 'category-edit', 'web', '2023-10-12 19:01:59', '2023-10-12 19:01:59'),
(11, 'category-delete', 'web', '2023-10-12 19:02:09', '2023-10-12 19:02:09'),
(12, 'game-view', 'web', '2023-10-12 19:02:27', '2023-10-12 19:02:27'),
(13, 'game-create', 'web', '2023-10-12 19:02:36', '2023-10-12 19:02:36'),
(14, 'game-edit', 'web', '2023-10-12 19:02:44', '2023-10-12 19:02:44'),
(15, 'game-delete', 'web', '2023-10-12 19:02:54', '2023-10-12 19:02:54'),
(16, 'wallet-view', 'web', '2023-10-12 19:05:49', '2023-10-12 19:05:49'),
(17, 'wallet-create', 'web', '2023-10-12 19:06:01', '2023-10-12 19:06:01'),
(18, 'wallet-edit', 'web', '2023-10-12 19:06:11', '2023-10-12 19:06:11'),
(19, 'wallet-delete', 'web', '2023-10-12 19:06:18', '2023-10-12 19:06:18'),
(20, 'deposit-view', 'web', '2023-10-12 19:06:44', '2023-10-12 19:06:44'),
(21, 'deposit-create', 'web', '2023-10-12 19:06:56', '2023-10-12 19:06:56'),
(22, 'deposit-edit', 'web', '2023-10-12 19:07:05', '2023-10-12 19:07:05'),
(23, 'deposit-update', 'web', '2023-10-12 19:08:00', '2023-10-12 19:08:00'),
(24, 'deposit-delete', 'web', '2023-10-12 19:08:11', '2023-10-12 19:08:11'),
(25, 'withdrawal-view', 'web', '2023-10-12 19:09:31', '2023-10-12 19:09:31'),
(26, 'withdrawal-create', 'web', '2023-10-12 19:09:40', '2023-10-12 19:09:40'),
(27, 'withdrawal-edit', 'web', '2023-10-12 19:09:51', '2023-10-12 19:09:51'),
(28, 'withdrawal-update', 'web', '2023-10-12 19:10:00', '2023-10-12 19:10:00'),
(29, 'withdrawal-delete', 'web', '2023-10-12 19:10:09', '2023-10-12 19:10:09'),
(30, 'order-view', 'web', '2023-10-12 19:12:36', '2023-10-12 19:12:36'),
(31, 'order-create', 'web', '2023-10-12 19:12:47', '2023-10-12 19:12:47'),
(32, 'order-edit', 'web', '2023-10-12 19:12:56', '2023-10-12 19:12:56'),
(33, 'order-update', 'web', '2023-10-12 19:13:06', '2023-10-12 19:13:06'),
(34, 'order-delete', 'web', '2023-10-12 19:13:19', '2023-10-12 19:13:19'),
(35, 'admin-menu-view', 'web', '2023-10-12 20:26:06', '2023-10-12 20:26:06'),
(36, 'setting-view', 'web', '2023-10-12 21:25:46', '2023-10-12 21:25:46'),
(37, 'setting-create', 'web', '2023-10-12 21:25:57', '2023-10-12 21:25:57'),
(38, 'setting-edit', 'web', '2023-10-12 21:26:06', '2023-10-12 21:26:06'),
(39, 'setting-update', 'web', '2023-10-12 21:26:19', '2023-10-12 21:26:19'),
(40, 'setting-delete', 'web', '2023-10-12 21:26:33', '2023-10-12 21:26:33');

-- --------------------------------------------------------

--
-- Estrutura para tabela `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `providers`
--

CREATE TABLE `providers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `rtp` bigint(20) DEFAULT 90,
  `views` bigint(20) DEFAULT 1,
  `distribution` varchar(50) DEFAULT 'proftgames',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `providers`
--

INSERT INTO `providers` (`id`, `cover`, `code`, `name`, `status`, `rtp`, `views`, `distribution`, `created_at`, `updated_at`) VALUES
(1, NULL, 'ORIGINAIS', 'ORIGINAIS', 1, 90, 1, 'proftgames', '2026-10-17 17:08:01', '2026-10-17 17:08:01'),
(2, NULL, 'PGSOFT', 'PGSOFT', 1, 90, 1, 'proftgames', '2026-10-17 17:08:01', '2026-10-17 17:08:01'),
(3, NULL, 'PRAGMATIC PLAY', 'PRAGMATIC PLAY', 1, 90, 1, 'proftgames', '2026-10-17 17:08:01', '2026-10-17 17:08:01'),
(4, NULL, 'GAMES RETRO', 'GAMES RETRO', 1, 90, 1, 'proftgames', '2026-10-17 17:08:01', '2026-10-17 17:08:01');

-- --------------------------------------------------------

--
-- Estrutura para tabela `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

--
-- Despejando dados para a tabela `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'web', '2023-10-12 16:20:41', '2023-10-12 16:20:41'),
(2, 'afiliado', 'web', '2023-10-12 16:21:08', '2023-10-12 16:21:08');

-- --------------------------------------------------------

--
-- Estrutura para tabela `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Estrutura para tabela `roulette_config`
--

CREATE TABLE `roulette_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `signup_spins` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `deposit_spins` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `deposit_min` decimal(12,2) NOT NULL DEFAULT 0.00,
  `deposit_max_times` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `spins_expire_days` int(10) UNSIGNED NOT NULL DEFAULT 7,
  `prize_rollover` decimal(8,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `roulette_config`
--

INSERT INTO `roulette_config` (`id`, `active`, `signup_spins`, `deposit_spins`, `deposit_min`, `deposit_max_times`, `spins_expire_days`, `prize_rollover`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 20.00, 0, 7, 1.00, '2026-10-02 02:02:05', '2026-10-01 23:23:59');

-- --------------------------------------------------------

--
-- Estrutura para tabela `roulette_history`
--

CREATE TABLE `roulette_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `prize_id` int(10) UNSIGNED DEFAULT NULL,
  `prize_name` varchar(60) NOT NULL,
  `prize_value` decimal(12,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `roulette_prizes`
--

CREATE TABLE `roulette_prizes` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(60) NOT NULL,
  `value` decimal(12,2) NOT NULL DEFAULT 0.00,
  `probability` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `roulette_prizes`
--

INSERT INTO `roulette_prizes` (`id`, `name`, `value`, `probability`, `status`, `created_at`, `updated_at`) VALUES
(1, 'R$ 1,00', 1.00, 60, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(2, 'R$ 2,00', 2.00, 15, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(3, 'R$ 5,00', 5.00, 10, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(4, 'R$ 10,00', 10.00, 5, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(5, 'R$ 20,00', 20.00, 3, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(6, 'R$ 50,00', 50.00, 2, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(7, 'R$ 100,00', 100.00, 1, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05'),
(8, 'Perdeu', 0.00, 4, 1, '2026-10-02 02:02:05', '2026-10-02 02:02:05');

-- --------------------------------------------------------

--
-- Estrutura para tabela `roulette_spins`
--

CREATE TABLE `roulette_spins` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `spins_available` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `reason` varchar(60) DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `software_name` varchar(255) DEFAULT NULL,
  `software_description` varchar(255) DEFAULT NULL,
  `software_favicon` varchar(255) DEFAULT NULL,
  `software_logo_white` varchar(255) DEFAULT NULL,
  `software_logo_black` varchar(255) DEFAULT NULL,
  `software_background` varchar(255) DEFAULT NULL,
  `currency_code` varchar(191) NOT NULL DEFAULT 'BRL',
  `decimal_format` varchar(20) NOT NULL DEFAULT 'dot',
  `currency_position` varchar(20) NOT NULL DEFAULT 'left',
  `revshare_percentage` bigint(20) DEFAULT 20,
  `ngr_percent` bigint(20) DEFAULT 20,
  `soccer_percentage` bigint(20) DEFAULT 30,
  `prefix` varchar(191) NOT NULL DEFAULT 'R$',
  `storage` varchar(191) NOT NULL DEFAULT 'local',
  `initial_bonus` bigint(20) DEFAULT 0,
  `min_deposit` decimal(10,2) DEFAULT 20.00,
  `max_deposit` decimal(10,2) DEFAULT 0.00,
  `min_withdrawal` decimal(10,2) DEFAULT 20.00,
  `max_withdrawal` decimal(10,2) DEFAULT 0.00,
  `rollover` bigint(20) DEFAULT 10,
  `rollover_deposit` bigint(20) DEFAULT 1,
  `suitpay_is_enable` tinyint(4) DEFAULT 1,
  `stripe_is_enable` tinyint(4) DEFAULT 1,
  `bspay_is_enable` tinyint(4) DEFAULT 0,
  `sharkpay_is_enable` tinyint(4) DEFAULT 1,
  `turn_on_football` tinyint(4) DEFAULT 1,
  `revshare_reverse` tinyint(1) DEFAULT 1,
  `bonus_vip` bigint(20) DEFAULT 100,
  `activate_vip_bonus` tinyint(1) DEFAULT 1,
  `updated_at` timestamp NULL DEFAULT NULL,
  `maintenance_mode` tinyint(4) DEFAULT 0,
  `withdrawal_limit` bigint(20) DEFAULT NULL,
  `withdrawal_period` varchar(30) DEFAULT NULL,
  `disable_spin` tinyint(1) NOT NULL DEFAULT 0,
  `perc_sub_lv1` bigint(20) NOT NULL DEFAULT 4,
  `perc_sub_lv2` bigint(20) NOT NULL DEFAULT 2,
  `perc_sub_lv3` bigint(20) NOT NULL DEFAULT 3,
  `disable_rollover` tinyint(4) DEFAULT 0,
  `rollover_protection` bigint(20) NOT NULL DEFAULT 1,
  `cpa_baseline` decimal(10,2) DEFAULT NULL,
  `cpa_value` decimal(10,2) DEFAULT NULL,
  `mercadopago_is_enable` tinyint(4) DEFAULT 0,
  `digitopay_is_enable` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `settings`
--

INSERT INTO `settings` (`id`, `software_name`, `software_description`, `software_favicon`, `software_logo_white`, `software_logo_black`, `software_background`, `currency_code`, `decimal_format`, `currency_position`, `revshare_percentage`, `ngr_percent`, `soccer_percentage`, `prefix`, `storage`, `initial_bonus`, `min_deposit`, `max_deposit`, `min_withdrawal`, `max_withdrawal`, `rollover`, `rollover_deposit`, `suitpay_is_enable`, `stripe_is_enable`, `bspay_is_enable`, `sharkpay_is_enable`, `turn_on_football`, `revshare_reverse`, `bonus_vip`, `activate_vip_bonus`, `updated_at`, `maintenance_mode`, `withdrawal_limit`, `withdrawal_period`, `disable_spin`, `perc_sub_lv1`, `perc_sub_lv2`, `perc_sub_lv3`, `disable_rollover`, `rollover_protection`, `cpa_baseline`, `cpa_value`, `mercadopago_is_enable`, `digitopay_is_enable`) VALUES
(1, 'Cassinopix', '- Plataforma de Apostas | Slots e Cassino Online |Autorizada.', 'uploads/03Wu02ZKmbMdS8S1KV2cpGI3ZgWDMWCgqqgtwcfY.png', 'uploads/uHHtYswechbkvT1TrmGhheFZM985cYIN5Qr1Nqg8.png', 'uploads/TyVzvl1J4snM0DJhi0AbWkFr1WXkEWZlarZARI9d.png', '[]', 'BRL', 'dot', 'left', 30, 27, 30, 'R$', 'local', 10, 2.00, 10000.00, 20.00, 200.00, 10, 2, 1, 0, 0, 0, 0, 0, 0, 0, '2025-08-21 17:22:39', 0, 10, 'daily', 1, 30, 15, 10, 0, 10, 25.00, 10.00, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `setting_mails`
--

CREATE TABLE `setting_mails` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `software_smtp_type` varchar(30) DEFAULT NULL,
  `software_smtp_mail_host` varchar(100) DEFAULT NULL,
  `software_smtp_mail_port` varchar(30) DEFAULT NULL,
  `software_smtp_mail_username` varchar(191) DEFAULT NULL,
  `software_smtp_mail_password` varchar(100) DEFAULT NULL,
  `software_smtp_mail_encryption` varchar(30) DEFAULT NULL,
  `software_smtp_mail_from_address` varchar(191) DEFAULT NULL,
  `software_smtp_mail_from_name` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `setting_mails`
--

INSERT INTO `setting_mails` (`id`, `software_smtp_type`, `software_smtp_mail_host`, `software_smtp_mail_port`, `software_smtp_mail_username`, `software_smtp_mail_password`, `software_smtp_mail_encryption`, `software_smtp_mail_from_address`, `software_smtp_mail_from_name`, `created_at`, `updated_at`) VALUES
(1, 'smtp', 'smtp.hostinger.com', '465', 'suporte@brbet7k.bet', 'Resident4557#', NULL, 'suporte@brbet7k.bet', 'BET7K', '2025-02-22 17:08:31', '2025-02-22 17:10:43');

-- --------------------------------------------------------

--
-- Estrutura para tabela `sub_affiliates`
--

CREATE TABLE `sub_affiliates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `affiliate_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `status` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `suit_pay_payments`
--

CREATE TABLE `suit_pay_payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` varchar(191) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `withdrawal_id` bigint(20) UNSIGNED NOT NULL,
  `pix_key` varchar(191) DEFAULT NULL,
  `pix_type` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `observation` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `suit_pay_payments`
--

INSERT INTO `suit_pay_payments` (`id`, `payment_id`, `user_id`, `withdrawal_id`, `pix_key`, `pix_type`, `amount`, `observation`, `status`, `created_at`, `updated_at`) VALUES
(1, 'a1c9e9ed-8f68-42b4-9fd3-a5a586dedb59', 3, 1, '82991134322', 'phoneNumber', 20.00, 'Saque direto', 1, '2024-07-04 12:20:52', '2024-07-04 12:20:54'),
(2, 'da768a27-1ca3-40a0-b654-4bc943fe7ba9', 19, 2, '12170108408', 'document', 25.00, 'Saque direto', 1, '2024-07-11 15:51:31', '2024-07-11 15:51:33'),
(3, NULL, 1, 3, '081.039.861-35', 'document', 47.00, 'Saque direto', 0, '2024-07-24 06:15:01', '2024-07-24 06:15:01'),
(4, NULL, 363, 18, '11261678940', 'document', 40.00, 'Saque direto', 0, '2025-02-28 00:05:38', '2025-02-28 00:05:38'),
(5, NULL, 363, 18, '11261678940', 'document', 40.00, 'Saque direto', 0, '2025-02-28 00:05:43', '2025-02-28 00:05:43'),
(6, NULL, 363, 18, '11261678940', 'document', 40.00, 'Saque direto', 0, '2025-02-28 00:07:08', '2025-02-28 00:07:08'),
(7, NULL, 363, 18, '11261678940', 'document', 40.00, 'Saque direto', 0, '2025-02-28 00:07:12', '2025-02-28 00:07:12'),
(8, NULL, 363, 18, '11261678940', 'document', 40.00, 'Saque direto', 0, '2025-03-02 02:40:57', '2025-03-02 02:40:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `system_wallets`
--

CREATE TABLE `system_wallets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `label` char(32) NOT NULL,
  `balance` decimal(27,12) NOT NULL DEFAULT 0.000000000000,
  `balance_min` decimal(27,12) NOT NULL DEFAULT 10000.100000000000,
  `pay_upto_percentage` decimal(4,2) NOT NULL DEFAULT 45.00,
  `mode` enum('balance_min','percentage') NOT NULL DEFAULT 'percentage',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

--
-- Despejando dados para a tabela `system_wallets`
--

INSERT INTO `system_wallets` (`id`, `label`, `balance`, `balance_min`, `pay_upto_percentage`, `mode`, `created_at`, `updated_at`) VALUES
(1, 'system', 261.800000000000, 10000.100000000000, 45.00, 'percentage', '2023-10-11 16:11:15', '2023-10-16 18:42:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `payment_id` varchar(100) NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `payment_method` varchar(191) DEFAULT NULL,
  `price` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(20) NOT NULL DEFAULT 'usd',
  `status` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `reference` varchar(191) DEFAULT NULL,
  `accept_bonus` tinyint(1) NOT NULL DEFAULT 1,
  `idUnico` varchar(191) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `oauth_id` varchar(191) DEFAULT NULL,
  `oauth_type` varchar(191) DEFAULT NULL,
  `avatar` varchar(191) DEFAULT NULL,
  `last_name` varchar(191) DEFAULT NULL,
  `cpf` varchar(20) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `logged_in` tinyint(4) NOT NULL DEFAULT 0,
  `banned` tinyint(4) NOT NULL DEFAULT 0,
  `inviter` int(11) DEFAULT NULL,
  `inviter_code` varchar(25) DEFAULT NULL,
  `affiliate_revenue_share` bigint(20) NOT NULL DEFAULT 2,
  `affiliate_revenue_share_fake` bigint(20) DEFAULT NULL,
  `affiliate_cpa` decimal(20,2) NOT NULL DEFAULT 10.00,
  `affiliate_baseline` decimal(20,2) NOT NULL DEFAULT 40.00,
  `is_demo_agent` tinyint(4) NOT NULL DEFAULT 0,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `language` varchar(191) NOT NULL DEFAULT 'pt_BR',
  `role_id` int(11) DEFAULT 3,
  `pix_name` varchar(191) DEFAULT NULL,
  `pix_key` varchar(191) DEFAULT NULL,
  `pix_type` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `oauth_id`, `oauth_type`, `avatar`, `last_name`, `cpf`, `phone`, `logged_in`, `banned`, `inviter`, `inviter_code`, `affiliate_revenue_share`, `affiliate_revenue_share_fake`, `affiliate_cpa`, `affiliate_baseline`, `is_demo_agent`, `status`, `language`, `role_id`, `pix_name`, `pix_key`, `pix_type`) VALUES
(1, 'Não apagar administrador', 'admin@eu.com', NULL, '$2y$10$P9CjBdyfD7M8MYLNMfeDeel2fkxM8yxRkgHUcdz4qMtQSmoQ2X/km', 'jL8yQ60YxMSDWkal8YD1C1OgoCVI1YxOgcMhKqoEXMQzSavEZqvCny2fWcTf', '2025-03-30 10:57:46', '2026-10-01 23:27:46', NULL, NULL, NULL, NULL, '925.385.540-12', '45999057184', 0, 0, NULL, 'VLX97LC2UO', 0, 0, 10.00, 40.00, 0, 'active', 'pt_BR', 3, 'Seu nome', 'Sua chave pix', 'document');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vips`
--

CREATE TABLE `vips` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `bet_symbol` varchar(255) NOT NULL,
  `bet_level` bigint(20) NOT NULL DEFAULT 1,
  `bet_required` bigint(20) DEFAULT NULL,
  `bet_period` varchar(191) DEFAULT NULL,
  `bet_bonus` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `vip_users`
--

CREATE TABLE `vip_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `vip_id` int(10) UNSIGNED NOT NULL,
  `level` bigint(20) NOT NULL,
  `points` bigint(20) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=FIXED;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wallets`
--

CREATE TABLE `wallets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `currency` varchar(20) NOT NULL,
  `symbol` varchar(5) NOT NULL,
  `balance` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_bonus_rollover` decimal(10,2) DEFAULT 0.00,
  `balance_deposit_rollover` decimal(10,2) DEFAULT 0.00,
  `balance_withdrawal` decimal(10,2) DEFAULT 0.00,
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.05,
  `balance_cryptocurrency` decimal(20,8) NOT NULL DEFAULT 0.00000000,
  `balance_demo` decimal(20,8) DEFAULT 1000.00000000,
  `refer_rewards` decimal(20,2) NOT NULL DEFAULT 0.00,
  `hide_balance` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `total_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `total_won` bigint(20) NOT NULL DEFAULT 0,
  `total_lose` bigint(20) NOT NULL DEFAULT 0,
  `last_won` bigint(20) NOT NULL DEFAULT 0,
  `last_lose` bigint(20) NOT NULL DEFAULT 0,
  `vip_level` bigint(20) DEFAULT 0,
  `vip_points` bigint(20) DEFAULT 0,
  `rollover_total` decimal(20,2) NOT NULL DEFAULT 0.00
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Despejando dados para a tabela `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `currency`, `symbol`, `balance`, `balance_bonus_rollover`, `balance_deposit_rollover`, `balance_withdrawal`, `balance_bonus`, `balance_cryptocurrency`, `balance_demo`, `refer_rewards`, `hide_balance`, `active`, `created_at`, `updated_at`, `total_bet`, `total_won`, `total_lose`, `last_won`, `last_lose`, `vip_level`, `vip_points`, `rollover_total`) VALUES
(1, 1, 'BRL', 'R$', 1000.00, 0.00, 0.00, 0.00, 0.00, 0.00000000, 0.00000000, 0.00, 0, 1, '2025-03-30 10:57:46', '2026-10-01 23:39:31', 0.00, 0, 0, 0, 0, 0, 0, 43.38);

-- --------------------------------------------------------

--
-- Estrutura para tabela `wallet_changes`
--

CREATE TABLE `wallet_changes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `change` varchar(50) DEFAULT NULL,
  `value_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
  `value_total` decimal(20,2) NOT NULL DEFAULT 0.00,
  `value_roi` decimal(20,2) NOT NULL DEFAULT 0.00,
  `value_entry` decimal(20,2) NOT NULL DEFAULT 0.00,
  `refer_rewards` decimal(20,2) NOT NULL DEFAULT 0.00,
  `game` varchar(191) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `websockets_statistics_entries`
--

CREATE TABLE `websockets_statistics_entries` (
  `id` int(10) UNSIGNED NOT NULL,
  `app_id` varchar(191) NOT NULL,
  `peak_connection_count` int(11) NOT NULL,
  `websocket_message_count` int(11) NOT NULL,
  `api_message_count` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estrutura para tabela `withdrawals`
--

CREATE TABLE `withdrawals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(20,2) NOT NULL DEFAULT 0.00,
  `type` varchar(191) DEFAULT NULL,
  `proof` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `pix_key` varchar(191) DEFAULT NULL,
  `pix_type` varchar(191) DEFAULT NULL,
  `bank_info` text DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `symbol` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `affiliate_histories`
--
ALTER TABLE `affiliate_histories`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `affiliate_histories_user_id_index` (`user_id`) USING BTREE,
  ADD KEY `affiliate_histories_inviter_index` (`inviter`) USING BTREE;

--
-- Índices de tabela `affiliate_withdraws`
--
ALTER TABLE `affiliate_withdraws`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `affiliate_withdraws_user_id_foreign` (`user_id`) USING BTREE;

--
-- Índices de tabela `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `casino_categories_slug_unique` (`slug`) USING BTREE;

--
-- Índices de tabela `category_game`
--
ALTER TABLE `category_game`
  ADD KEY `category_games_category_id_foreign` (`category_id`) USING BTREE,
  ADD KEY `category_games_game_id_foreign` (`game_id`) USING BTREE;

--
-- Índices de tabela `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `currency_alloweds`
--
ALTER TABLE `currency_alloweds`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `currency_alloweds_currency_id_foreign` (`currency_id`) USING BTREE;

--
-- Índices de tabela `custom_layouts`
--
ALTER TABLE `custom_layouts`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `deposits`
--
ALTER TABLE `deposits`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `deposits_user_id_foreign` (`user_id`) USING BTREE;

--
-- Índices de tabela `deposit_bonus_log`
--
ALTER TABLE `deposit_bonus_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `deposit_bonus_unique` (`type`,`transaction_id`),
  ADD KEY `deposit_bonus_user` (`user_id`,`type`);

--
-- Índices de tabela `digito_pay_payments`
--
ALTER TABLE `digito_pay_payments`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `digito_pay_payments_user_id_foreign` (`user_id`) USING BTREE,
  ADD KEY `digito_pay_payments_withdrawal_id_foreign` (`withdrawal_id`) USING BTREE;

--
-- Índices de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`) USING BTREE;

--
-- Índices de tabela `freespin_config`
--
ALTER TABLE `freespin_config`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `free_spins`
--
ALTER TABLE `free_spins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `free_spins_user` (`user_id`,`status`),
  ADD KEY `free_spins_external` (`external_id`);

--
-- Índices de tabela `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `games_provider_id_index` (`provider_id`),
  ADD KEY `games_game_code_index` (`game_id`);

--
-- Índices de tabela `games_keys`
--
ALTER TABLE `games_keys`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `game_favorites`
--
ALTER TABLE `game_favorites`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `game_favorites_user_id_game_id_unique` (`user_id`,`game_id`) USING BTREE,
  ADD KEY `game_favorites_game_id_foreign` (`game_id`) USING BTREE;

--
-- Índices de tabela `game_likes`
--
ALTER TABLE `game_likes`
  ADD UNIQUE KEY `game_likes_user_id_game_id_unique` (`user_id`,`game_id`) USING BTREE,
  ADD KEY `game_likes_game_id_foreign` (`game_id`) USING BTREE;

--
-- Índices de tabela `game_reviews`
--
ALTER TABLE `game_reviews`
  ADD UNIQUE KEY `game_reviews_user_id_game_id_unique` (`user_id`,`game_id`) USING BTREE,
  ADD KEY `game_reviews_game_id_foreign` (`game_id`) USING BTREE;

--
-- Índices de tabela `gateways`
--
ALTER TABLE `gateways`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `ggds_spin_config`
--
ALTER TABLE `ggds_spin_config`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `ggds_spin_runs`
--
ALTER TABLE `ggds_spin_runs`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `ggr_games`
--
ALTER TABLE `ggr_games`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `ggr_games_fivers_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `ggr_games_drakon`
--
ALTER TABLE `ggr_games_drakon`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `ggr_games_drakon_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `ggr_games_world_slots`
--
ALTER TABLE `ggr_games_world_slots`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `ggr_games_world_slots_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `likes_user_id_foreign` (`user_id`) USING BTREE,
  ADD KEY `likes_liked_user_id_foreign` (`liked_user_id`) USING BTREE;

--
-- Índices de tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `missions`
--
ALTER TABLE `missions`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `mission_users`
--
ALTER TABLE `mission_users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `mission_users_user_id_index` (`user_id`) USING BTREE,
  ADD KEY `mission_users_mission_id_index` (`mission_id`) USING BTREE;

--
-- Índices de tabela `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`) USING BTREE,
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE;

--
-- Índices de tabela `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`) USING BTREE,
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`) USING BTREE;

--
-- Índices de tabela `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`) USING BTREE;

--
-- Índices de tabela `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `orders_user_id_foreign` (`user_id`) USING BTREE,
  ADD KEY `orders_transaction_id_index` (`transaction_id`);

--
-- Índices de tabela `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`) USING BTREE;

--
-- Índices de tabela `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`) USING BTREE;

--
-- Índices de tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`) USING BTREE,
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`) USING BTREE;

--
-- Índices de tabela `providers`
--
ALTER TABLE `providers`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`) USING BTREE;

--
-- Índices de tabela `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`) USING BTREE,
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`) USING BTREE;

--
-- Índices de tabela `roulette_config`
--
ALTER TABLE `roulette_config`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `roulette_history`
--
ALTER TABLE `roulette_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roulette_history_user` (`user_id`,`created_at`);

--
-- Índices de tabela `roulette_prizes`
--
ALTER TABLE `roulette_prizes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `roulette_spins`
--
ALTER TABLE `roulette_spins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roulette_spins_user` (`user_id`,`expires_at`);

--
-- Índices de tabela `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `setting_mails`
--
ALTER TABLE `setting_mails`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `sub_affiliates`
--
ALTER TABLE `sub_affiliates`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `sub_affiliates_affiliate_id_index` (`affiliate_id`) USING BTREE,
  ADD KEY `sub_affiliates_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `suit_pay_payments`
--
ALTER TABLE `suit_pay_payments`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `suit_pay_payments_user_id_foreign` (`user_id`) USING BTREE,
  ADD KEY `suit_pay_payments_withdrawal_id_foreign` (`withdrawal_id`) USING BTREE;

--
-- Índices de tabela `system_wallets`
--
ALTER TABLE `system_wallets`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `transactions_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `users_email_unique` (`email`) USING BTREE;

--
-- Índices de tabela `vips`
--
ALTER TABLE `vips`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `vip_users`
--
ALTER TABLE `vip_users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `vip_users_user_id_index` (`user_id`) USING BTREE,
  ADD KEY `vip_users_vip_id_index` (`vip_id`) USING BTREE;

--
-- Índices de tabela `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `wallets_user_id_index` (`user_id`) USING BTREE;

--
-- Índices de tabela `wallet_changes`
--
ALTER TABLE `wallet_changes`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `wallet_changes_user_id_foreign` (`user_id`) USING BTREE;

--
-- Índices de tabela `websockets_statistics_entries`
--
ALTER TABLE `websockets_statistics_entries`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Índices de tabela `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `withdrawals_user_id_foreign` (`user_id`) USING BTREE;

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `affiliate_histories`
--
ALTER TABLE `affiliate_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `affiliate_withdraws`
--
ALTER TABLE `affiliate_withdraws`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `banners`
--
ALTER TABLE `banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de tabela `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de tabela `currency_alloweds`
--
ALTER TABLE `currency_alloweds`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `custom_layouts`
--
ALTER TABLE `custom_layouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `deposits`
--
ALTER TABLE `deposits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `deposit_bonus_log`
--
ALTER TABLE `deposit_bonus_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `digito_pay_payments`
--
ALTER TABLE `digito_pay_payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `freespin_config`
--
ALTER TABLE `freespin_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `free_spins`
--
ALTER TABLE `free_spins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT de tabela `games_keys`
--
ALTER TABLE `games_keys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `game_favorites`
--
ALTER TABLE `game_favorites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `gateways`
--
ALTER TABLE `gateways`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `ggds_spin_config`
--
ALTER TABLE `ggds_spin_config`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `ggds_spin_runs`
--
ALTER TABLE `ggds_spin_runs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de tabela `ggr_games`
--
ALTER TABLE `ggr_games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ggr_games_drakon`
--
ALTER TABLE `ggr_games_drakon`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ggr_games_world_slots`
--
ALTER TABLE `ggr_games_world_slots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT de tabela `missions`
--
ALTER TABLE `missions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `mission_users`
--
ALTER TABLE `mission_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de tabela `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `providers`
--
ALTER TABLE `providers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `roulette_config`
--
ALTER TABLE `roulette_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `roulette_history`
--
ALTER TABLE `roulette_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `roulette_prizes`
--
ALTER TABLE `roulette_prizes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de tabela `roulette_spins`
--
ALTER TABLE `roulette_spins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `setting_mails`
--
ALTER TABLE `setting_mails`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `sub_affiliates`
--
ALTER TABLE `sub_affiliates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suit_pay_payments`
--
ALTER TABLE `suit_pay_payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `system_wallets`
--
ALTER TABLE `system_wallets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `vips`
--
ALTER TABLE `vips`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `vip_users`
--
ALTER TABLE `vip_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `wallet_changes`
--
ALTER TABLE `wallet_changes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `websockets_statistics_entries`
--
ALTER TABLE `websockets_statistics_entries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
