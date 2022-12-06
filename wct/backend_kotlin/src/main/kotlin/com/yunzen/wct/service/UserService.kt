package com.yunzen.wct.service

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.yunzen.wct.entity.UserEntity
import com.yunzen.wct.mapper.UserMapper
import org.apache.commons.lang3.RandomStringUtils
import org.springframework.stereotype.Service


@Service("userService")
class UserService : ServiceImpl<UserMapper, UserEntity>() {
    fun create(): UserEntity {
        val userEntity = UserEntity(name = "球迷" + RandomStringUtils.randomAlphabetic(6))
        baseMapper.insert(userEntity)
        return userEntity
    }

    fun rename(uid: Long, name: String) {
        baseMapper.updateById(UserEntity(uid = uid, name = name))
    }

}
