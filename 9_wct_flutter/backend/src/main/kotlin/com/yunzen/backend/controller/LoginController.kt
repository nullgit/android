package com.yunzen.backend.controller

import lombok.extern.slf4j.Slf4j
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

import com.yunzen.backend.service.TokenService;

@RestController
class LoginController {

//    @Autowired
//    private lateinit var tokenService: TokenService

    @GetMapping("/test")
    fun test(): String {
        val tokenService: TokenService
        println("~~~")
        return "hello, kotlin springboot application!"
    }

    @GetMapping("/token")
    fun token(): String {
//        return tokenService.token
        return TokenService().token
    }

}

