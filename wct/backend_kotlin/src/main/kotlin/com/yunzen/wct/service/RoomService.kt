package com.yunzen.wct.service

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.yunzen.wct.entity.RoomEntity
import com.yunzen.wct.mapper.RoomMapper
import org.apache.commons.lang3.RandomStringUtils
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

    @Autowired
    private lateinit var tokenService: TokenService

    /**
     * 进入房间
     */
    fun join(uid: Long, rid: Long): String {
        var roomEntity = baseMapper.selectById(rid)
        if (roomEntity == null) {
            roomEntity = RoomEntity(rid = rid, name = "房间${RandomStringUtils.randomAlphabetic(6)}")
            baseMapper.insert(roomEntity)
        }
        return tokenService.getToken(rid.toString(), uid.toString())
    }


}
