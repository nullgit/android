package com.yunzen.wct.entity

import com.baomidou.mybatisplus.annotation.IdType
import com.baomidou.mybatisplus.annotation.TableId
import com.baomidou.mybatisplus.annotation.TableName
import java.io.Serializable

@TableName("user")
data class UserEntity(
    @TableId(value = "uid", type = IdType.AUTO)
    var uid: Long? = null,
    var name: String? = null,
    var headImgPath: String? = null,
) : Serializable {
    companion object {
        private const val serialVersionUID = 1L
    }
}