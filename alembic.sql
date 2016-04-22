use `registry`;
drop table if exists `alembic_version`;
CREATE TABLE `alembic_version` (
    `version_num` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
