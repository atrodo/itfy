--
-- `machine`
--

CREATE TABLE IF NOT EXISTS `machine` (
  `machine_id` varchar(36) NOT NULL,
  `name` varchar(32) NOT NULL UNIQUE,
  `phys_mem` varchar(255) NOT NULL,
  `os` varchar(255) NOT NULL,
  `cpu` varchar(255) NOT NULL,
  `cpu_speed` varchar(255) NOT NULL,
  PRIMARY KEY (`machine_id`)
);

--
-- `project`
--

CREATE TABLE IF NOT EXISTS `project` (
  `project_id` varchar(36) NOT NULL,
  `name` varchar(32) NOT NULL UNIQUE,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`project_id`)
);

--
-- `bench_cmd`
--

CREATE TABLE IF NOT EXISTS `bench_cmd` (
  `bench_cmd_id` varchar(36) NOT NULL,
  `project_id` varchar(36) NOT NULL,
  `name` varchar(32) NOT NULL,
  `desc` varchar(255),
  `cmd` varchar(255) NOT NULL,
  `count` int unsigned NOT NULL,
  `shown` boolean default false NOT NULL,
  UNIQUE (`project_id`, `name`),
  PRIMARY KEY (`bench_cmd_id`)
);

--
-- `bench_branch`
--

CREATE TABLE IF NOT EXISTS `bench_branch` (
  `bench_branch_id` varchar(36) NOT NULL,
  `project_id` varchar(36) NOT NULL,
  `name` varchar(32) NOT NULL,
  UNIQUE (`project_id`, `name`),
  PRIMARY KEY (`bench_branch_id`)
);

--
-- `bench_branch_rev`
--

CREATE TABLE IF NOT EXISTS `bench_branch_rev` (
  `bench_branch_rev_id` varchar(36) NOT NULL,
  `bench_branch_id` varchar(36) NOT NULL,
  `revision` varchar(40) NOT NULL,
  `revision_aka` varchar(40) NOT NULL,
  `revision_date` datetime NOT NULL,
  `revision_stamp` int unsigned NOT NULL,
  UNIQUE (`bench_branch_id`, `revision`),
  PRIMARY KEY (`bench_branch_rev_id`)
);

--
-- `bench_run`
--

CREATE TABLE IF NOT EXISTS `bench_run` (
  `bench_run_id` varchar(36) NOT NULL,
  `machine_id` varchar(36) NOT NULL,
  `bench_branch_rev_id` varchar(36) NOT NULL,
  `submit_stamp` int unsigned NOT NULL,
  PRIMARY KEY (`bench_run_id`)
);

--
-- `bench_result`
--

CREATE TABLE IF NOT EXISTS `bench_result` (
  `bench_result_id` varchar(36) NOT NULL,
  `bench_run_id` varchar(36) NOT NULL,
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

