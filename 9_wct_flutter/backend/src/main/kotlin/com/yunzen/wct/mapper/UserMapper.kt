package com.yunzen.wct.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.yunzen.wct.entity.UserEntity
import org.apache.ibatis.annotations.Mapper

@Mapper
interface UserMapper : BaseMapper<UserEntity?>