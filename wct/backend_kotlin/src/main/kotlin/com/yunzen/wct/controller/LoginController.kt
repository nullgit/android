package com.yunzen.wct.controller

import com.yunzen.wct.common.Resp
import com.yunzen.wct.entity.UserEntity
import com.yunzen.wct.service.RoomService
import com.yunzen.wct.service.TokenService
import com.yunzen.wct.service.UserService
import mu.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/login")
class LoginController {
    private val logger = KotlinLogging.logger {}

    @Autowired
    private lateinit var tokenService: TokenService

    @Autowired
    private lateinit var userService: UserService

    @Autowired
    private lateinit var roomService: RoomService

    @GetMapping("/token")
    fun token(uid: String, rid: String): Resp<String> {
        return Resp(respData = tokenService.getToken(uid, rid))
    }

    @GetMapping("/createUser")
    fun createUser(): Resp<UserEntity> {
        return Resp(respData = userService.create())
    }

    @GetMapping("/joinRoom")
    fun joinRoom(uid: Long, rid: Long): Resp<Map<String, String?>> {
        val token = roomService.join(uid, rid)
        logger.info { "有人想要加入房间：uid[$uid] rid[$rid] token[$token]" }
        return Resp(respData = mapOf("token" to token, "roomName" to roomService.getById(rid).name))
    }

}
