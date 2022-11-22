package com.yunzen.myapplication.lab5

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.VideoView
import com.yunzen.myapplication.R
import java.text.SimpleDateFormat
import java.util.*

class VideoActivity : AppCompatActivity() {
    companion object {
        const val TAG = "VideoActivity"
        const val REQUEST_VIDEO_CAPTURE = 1
        val sdf = SimpleDateFormat("yyyyMMdd_HHmmss")
    }

    lateinit var videoView : VideoView
    var curPhotoPath : String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video)

        videoView = findViewById(R.id.video1)

        val takePhotoBtn = findViewById<Button>(R.id.btn_record_a_video)
        takePhotoBtn.setOnClickListener {
            startActivityForResult(Intent(MediaStore.ACTION_VIDEO_CAPTURE), REQUEST_VIDEO_CAPTURE)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d(TAG, "触发回调 $requestCode, $resultCode ?== $RESULT_OK")
        if (resultCode != RESULT_OK) {
            return
        }
        when (requestCode) {
            REQUEST_VIDEO_CAPTURE -> {
                val videoURI = data?.data
                videoView.setVideoURI(videoURI)
                videoView.start()
            }
        }
    }
}