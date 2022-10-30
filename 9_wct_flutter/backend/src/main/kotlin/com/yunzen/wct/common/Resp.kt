package com.yunzen.wct.common

data class Resp<T>(
    val code: Int = 0,
    val msg: String = "",
    val respData: T,
) {

}