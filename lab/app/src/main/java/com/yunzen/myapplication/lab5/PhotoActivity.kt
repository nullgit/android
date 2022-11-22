package com.yunzen.myapplication.lab5

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.ImageView
import androidx.core.content.FileProvider
import com.yunzen.myapplication.R
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

class PhotoActivity : AppCompatActivity() {
    companion object {
        const val TAG = "PhotoActivity"
        const val REQUEST_IMAGE_CAPTURE = 1
        const val REQUEST_IMAGE_CAPTURE_TO_PATH = 2
        val sdf = SimpleDateFormat("yyyyMMdd_HHmmss")
    }

    lateinit var imageView : ImageView
    var curPhotoPath : String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_photo)

        imageView = findViewById(R.id.img1)

        val takePhotoBtn = findViewById<Button>(R.id.btn_take_a_photo)
        takePhotoBtn.setOnClickListener {
            startActivityForResult(Intent(MediaStore.ACTION_IMAGE_CAPTURE), REQUEST_IMAGE_CAPTURE)
        }

        val takePhotoToPathBtn = findViewById<Button>(R.id.btn_take_a_photo_to_path)
        takePhotoToPathBtn.setOnClickListener { dispatchTakePhotoIntent() }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d(TAG, "触发回调 $requestCode, $resultCode ?== $RESULT_OK")
        if (resultCode != RESULT_OK) {
            return
        }
        when (requestCode) {
            REQUEST_IMAGE_CAPTURE -> {
                val bitmap = data?.extras?.get("data") as Bitmap
                imageView.setImageBitmap(bitmap)
            }
            REQUEST_IMAGE_CAPTURE_TO_PATH -> {
                val options = BitmapFactory.Options()

                options.inJustDecodeBounds = false
                options.inSampleSize =
                    (options.outWidth / imageView.width).coerceAtMost(options.outHeight / imageView.height)
                options.inPurgeable = true

                Log.d(TAG, "图片加载自：${curPhotoPath}")
                val bitmap = BitmapFactory.decodeFile(curPhotoPath, options)
                imageView.setImageBitmap(bitmap)
            }
        }
    }

    private fun createFile() : File {
        val fileName = "JPEG_${sdf.format(Date())}"
        val dir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        val file = File.createTempFile(fileName, ".jpeg", dir)
        // 保存文件路径
        curPhotoPath = file.absolutePath
        return file
    }

    private fun dispatchTakePhotoIntent() {
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        try {
            val file = createFile()
            val uri =
                FileProvider.getUriForFile(this, "com.yunzen.myapplication.fileprovider", file)
            intent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
            startActivityForResult(intent, REQUEST_IMAGE_CAPTURE_TO_PATH)
        } catch (e : Exception) {
            // Log.d(TAG, e.)
            e.printStackTrace()
        }
    }
}