package com.yunzen.wct.controller

import com.yunzen.wct.common.Resp
import com.yunzen.wct.param.ChatParam
import com.yunzen.wct.service.ChatService
import com.yunzen.wct.vo.ChatVO
import mu.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/chat")
class ChatController {
    private val logger = KotlinLogging.logger {}

    @Autowired
    private lateinit var charService: ChatService

    @PostMapping("/send")
    fun sendChat(@RequestBody vo: ChatParam): Resp<Void?> {
        logger.info { "房间${vo.rid} 用户${vo.uid} 发送了：${vo.content}" }
        charService.send(vo.rid, vo.uid, vo.content)
        return Resp(respData = null)
    }

    @GetMapping("/list")
    fun listChat(rid: Long, from: Long?, to: Long?): Resp<List<ChatVO>> {
        logger.info { "获取最新$rid 聊天消息 from $from to $to" }
        val list = charService.list(rid, from ?: 0L, to ?: (Date().time + 1000L))
        return Resp(respData = list.map {
            ChatVO(id = it?.id, rid = it?.rid, uid = it?.uid, content = it?.content, time = it?.time?.time)
        })
    }

}
