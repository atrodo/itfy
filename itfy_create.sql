--
-- `machine`
--

CREATE TABLE IF NOT EXISTS `machine` (
  `machine_id` varchar(36) NOT NULL,
  `name` varchar(32) NOT NULL,
  `phsy_mem` varchar(255) NOT NULL,
  `os` varchar(255) NOT NULL,
  `cpu` varchar(255) NOT NULL,
  `cpu_speed` varchar(255) NOT NULL,
  PRIMARY KEY (`machine_id`)
);

--
-- `bench_cmd`
--

CREATE TABLE IF NOT EXISTS `bench_cmd` (
  `bench_cmd_id` varchar(36) NOT NULL,
  `interp` varchar(32) NOT NULL,
  `cmd` varchar(32) NOT NULL,
  `args` varchar(255) NOT NULL,
  `count` int unsigned NOT NULL,
  PRIMARY KEY (`bench_cmd_id`)
);

--
-- `bench_result`
--

CREATE TABLE IF NOT EXISTS `bench_result` (
  `bench_result_id` varchar(36) NOT NULL,
  `machine_id` varchar(36) NOT NULL,
  `bench_cmd_id` varchar(36) NOT NULL,
  `max_time` float NOT NULL,
  `avg_time` float NOT NULL,
  `min_time` float NOT NULL,
  `total_time` float NOT NULL,
  `total_runs` int unsigned NOT NULL,
  PRIMARY KEY (`bench_result_id`)
);

--
-- `bench_result_json`
--

CREATE TABLE IF NOT EXISTS `bench_result_json` (
  `bench_result_id` varchar(36) NOT NULL,
  `json` text NOT NULL,
  PRIMARY KEY (`bench_result_id`)
);

