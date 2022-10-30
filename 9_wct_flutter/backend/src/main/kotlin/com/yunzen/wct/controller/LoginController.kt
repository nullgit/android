package com.yunzen.wct.controller

import com.yunzen.wct.common.Resp
import com.yunzen.wct.service.RoomService
import com.yunzen.wct.service.TokenService
import com.yunzen.wct.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/login")
class LoginController {

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

    @GetMapping("/create/user")
    fun createUser(): Resp<Long?> {
        return Resp(respData = userService.create())
    }

    @GetMapping("/create/room")
    fun createRoom(name: String): Resp<Long?> {
        return Resp(respData = roomService.create(name));
    }

}
