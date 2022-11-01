package com.yunzen.wct.service

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.yunzen.wct.entity.RoomEntity
import com.yunzen.wct.mapper.RoomMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Service

@Service("roomService")
class RoomService : ServiceImpl<RoomMapper, RoomEntity>() {

    companion object {
        const val TIME: String = "TIME"
    }

    @Autowired
    private lateinit var redisTemplate: StringRedisTemplate

    /**
     * 创建一个直播间
     */
    fun create(name: String): Long? {
        val roomEntity = RoomEntity(name = name)
        baseMapper.insert(roomEntity)
        return roomEntity.rid
    }

}
