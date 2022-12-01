package com.yunzen.wct.entity

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import java.io.Serializable

@TableName("room")
data class RoomEntity(
    @TableId(value = "rid", type = IdType.AUTO)
    var rid: Long? = null,
    var name: String? = null,
) : Serializable {
    companion object {
        private const val serialVersionUID = 1L
    }
}
