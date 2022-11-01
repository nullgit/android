package com.yunzen.wct.controller

import com.yunzen.wct.common.Resp
import com.yunzen.wct.entity.ChatEntity
import com.yunzen.wct.service.ChatService
import com.yunzen.wct.vo.ChatVo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*

@RestController
@RequestMapping("/chat")
class ChatController {

    @Autowired
    private lateinit var charService: ChatService

    @PostMapping("/send")
    fun send(@RequestBody vo: ChatVo): Resp<List<ChatEntity>> {
        return Resp(respData = charService.send(vo.rid, vo.uid, vo.content));
    }

    @GetMapping("/list")
    fun list(rid: Long, timeStamp: Long?): Resp<List<ChatEntity?>> {
        return Resp(respData = charService.list(rid, timeStamp?.let { timeStamp } ?: Date().time))
    }

}