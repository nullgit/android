package com.yunzen.wct.service

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.yunzen.wct.entity.ChatEntity
import com.yunzen.wct.mapper.ChatMapper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Service
import java.util.*

@Service("chatService")
class ChatService : ServiceImpl<ChatMapper, ChatEntity>() {

    companion object {
        const val TIME: String = "TIME"
    }

    @Autowired
    private lateinit var redisTemplate: StringRedisTemplate

//    @Autowired
//    private lateinit var redisList: RedisList<ChatEntity>

    /**
     * 在直播间发送一条聊天消息
     */
    fun send(rid: Long, uid: Long, content: String): List<ChatEntity> {
        val chatEntity = ChatEntity(null, rid, uid, content, Date())
        baseMapper.insert(chatEntity)
        // 发送到其他在直播间中的人
        return mutableListOf()
    }

    /**
     * 查询某个时间以前的100条数据
     */
    fun list(rid: Long, timeStamp: Long): List<ChatEntity?> {
        return baseMapper.selectList(QueryWrapper<ChatEntity>().le(TIME, Date(timeStamp)).last("limit 10"))
    }

}
