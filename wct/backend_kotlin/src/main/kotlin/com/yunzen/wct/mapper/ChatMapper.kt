package com.yunzen.wct.mapper

import com.baomidou.mybatisplus.core.mapper.BaseMapper
import com.yunzen.wct.entity.ChatEntity
import org.apache.ibatis.annotations.Mapper

@Mapper
interface ChatMapper : BaseMapper<ChatEntity?>
