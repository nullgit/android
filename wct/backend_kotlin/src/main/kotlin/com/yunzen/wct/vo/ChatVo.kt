package com.yunzen.wct.vo

import com.baomidou.mybatisplus.annotation.TableName

@TableName("user")
data class ChatVo(
    val rid: Long,
    val uid: Long,
    val content: String,
) {}