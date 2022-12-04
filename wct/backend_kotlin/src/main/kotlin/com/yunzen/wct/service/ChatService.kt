package com.yunzen.wct.service

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl
import com.yunzen.wct.entity.ChatEntity
import com.yunzen.wct.mapper.ChatMapper
import org.apache.commons.lang3.compare.ComparableUtils.ge
import org.apache.commons.lang3.compare.ComparableUtils.le
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.redis.core.StringRedisTemplate
import org.springframework.stereotype.Service
import java.util.*

@Service("chatService")
class ChatService : ServiceImpl<ChatMapper, ChatEntity>() {

    companion object {
        const val TIME: String = "TIME"
        const val RID: String = "rid"
    }

    @Autowired
    private lateinit var redisTemplate: StringRedisTemplate

//    @Autowired
//    private lateinit var redisList: RedisList<ChatEntity>

    /**
     * 在直播间发送一条聊天消息
     */
    fun send(rid: Long, uid: Long, content: String) {
        val chatEntity = ChatEntity(null, rid, uid, content, Date())
        baseMapper.insert(chatEntity)
    }

    /**
     * 查询某个时间段的数据
     */
    fun list(rid: Long, from: Long, to: Long): List<ChatEntity?> {
        return baseMapper.selectList(QueryWrapper<ChatEntity>().eq(RID, rid).ge(TIME, Date(from)).le(TIME, Date(to)))
            // .last("limit 10"))
    }

}
