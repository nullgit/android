CREATE DATABASE `wct`
    DEFAULT CHARACTER SET = 'utf8mb4';

USE `wct`;

CREATE TABLE `wct`.`user`  (
    `uid` bigint PRIMARY KEY AUTO_INCREMENT COMMENT '用户id',
    `name` varchar(128) NOT NULL COMMENT '用户昵称',
    `headImgPath` varchar(255) NULL COMMENT '用户头像地址'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 AUTO_INCREMENT = 1;

CREATE TABLE `wct`.`chat`  (
    `id` bigint PRIMARY KEY AUTO_INCREMENT COMMENT 'id',
    `rid` bigint COMMENT '房间id',
    `uid` bigint COMMENT '用户id',
    `content` varchar(1024) COMMENT '聊天内容（不超1024字符）',
    `time` datetime COMMENT '发送消息的时间'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 AUTO_INCREMENT = 1;

CREATE TABLE `wct`.`room`  (
    `rid` bigint PRIMARY KEY AUTO_INCREMENT COMMENT '房间id',
    `name` varchar(128) NOT NULL COMMENT '房间名'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 AUTO_INCREMENT = 1;
