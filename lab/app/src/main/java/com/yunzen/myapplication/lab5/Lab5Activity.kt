package com.yunzen.myapplication.lab5

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.yunzen.myapplication.R
import com.yunzen.myapplication.lab1.Lab1Activity
import com.yunzen.myapplication.lab2.Lab2Activity
import com.yunzen.myapplication.lab3.Lab3Activity
import com.yunzen.myapplication.lab4.Lab4Activity
import java.util.*
import java.util.stream.IntStream
import kotlin.reflect.KClass

class Lab5Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lab5)

        val buttons = listOf<View>(
            findViewById(R.id.photo_btn),
            findViewById(R.id.video_btn),
            findViewById(R.id.camera_btn),
        )
        val activities = arrayOf<Class<*>>(
            PhotoActivity::class.java,
            VideoActivity::class.java,
            CameraActivity::class.java,
        )

        IntStream.range(0, buttons.size).forEach { i: Int ->
            buttons[i].setOnClickListener {
                startActivity(Intent(this, activities[i]))
            }
        }
    }
}
