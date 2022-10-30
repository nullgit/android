package com.yunzen.wct.entity

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import java.io.Serializable
import java.util.*

@TableName("chat")
data class ChatEntity(
    @TableId(value = "uid", type = IdType.AUTO)
    var id: Long? = null,
    var rid: Long? = null,
    var uid: Long? = null,
    var content: String? = null,
    var time: Date? = null,
) : Serializable {
    companion object {
        private const val serialVersionUID = 1L
    }
}
