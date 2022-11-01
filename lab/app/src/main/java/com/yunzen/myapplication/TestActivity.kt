package com.yunzen.myapplication

class TestActivity {
}

fun Any.p() = run { println(this) }

fun main() {
    var i :Int? = null
    println(i ?: "2")
}