package com.yunzen.wct.controller

import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*

fun Any.p() = run { println(this) }

@RestController
@RequestMapping("/test")
class TestController {

    @RequestMapping("/1")
    fun test(): String {
        println("~~~")
        return "hello, kotlin springboot application!"
    }

}

fun main(args: Array<String>) {
    var obj : String? = "1"
    obj = null;
    (obj ?: "123").p()
}
