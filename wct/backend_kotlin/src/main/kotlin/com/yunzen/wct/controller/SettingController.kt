package com.yunzen.wct.controller

import com.yunzen.wct.common.Resp
import com.yunzen.wct.service.ChatService
import com.yunzen.wct.service.UserService
import mu.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/setting")
class SettingController {
    private val logger = KotlinLogging.logger {}

    @Autowired
    private lateinit var charService: ChatService

    @Autowired
    private lateinit var userService: UserService

    @PostMapping("/user/rename")
    fun renameUser(uid: Long, name: String): Resp<Void?> {
        logger.info { "用户$uid 改名为$name" }
        userService.rename(uid, name)
        return Resp(respData = null)
    }

    // @PostMapping("/user/headImage")
    // fun uploadHeadImage(uid: Long, name: String): Resp<Void?> {
    //     return Resp(respData = null)
    // }

    // @GetMapping("/room/rename")
    // fun renameRoom(rid: Long, timeStamp: Long?): Resp<List<ChatEntity?>> {
    //     return Resp(respData = charService.list(rid, timeStamp?.let { timeStamp } ?: Date().time))
    // }

}
