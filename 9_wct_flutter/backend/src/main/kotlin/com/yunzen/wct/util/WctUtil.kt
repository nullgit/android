package com.yunzen.wct.util

import org.apache.commons.lang3.RandomStringUtils
import org.apache.commons.lang3.time.DateUtils
import org.springframework.util.StringUtils
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import java.security.SecureRandom
import java.util.*
import java.util.concurrent.ThreadLocalRandom
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

//fun Long.toDate() = run {  }

object WctUtil {
    val RANDOM: ThreadLocalRandom = ThreadLocalRandom.current()

    fun randomString(num: Int):String {
        RandomStringUtils.random(6)
        return ""
    }
}

object Utils2 {
    const val HMAC_SHA256_LENGTH: Long = 32
    const val VERSION_LENGTH = 3
    const val APP_ID_LENGTH = 24
    @Throws(InvalidKeyException::class, NoSuchAlgorithmException::class)
    fun hmacSign(keyString: String, msg: ByteArray?): ByteArray {
        val keySpec = SecretKeySpec(keyString.toByteArray(), "HmacSHA256")
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(keySpec)
        return mac.doFinal(msg)
    }

    fun base64Encode(data: ByteArray?): String {
        val encodedBytes = Base64.getEncoder().encode(data)
        return String(encodedBytes)
    }

    fun base64Decode(data: String): ByteArray {
        return Base64.getDecoder().decode(data.toByteArray())
    }

    val timestamp: Int
        get() = (Date().time / 1000).toInt()

    fun randomInt(): Int {
        return SecureRandom().nextInt()
    }
}