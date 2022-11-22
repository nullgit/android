package com.bytedance.mediademo;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Toast;
import android.widget.VideoView;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SystemRecordActivity extends AppCompatActivity {

    private static final String TAG = "SystemRecordActivity";
    private static final int REQUEST_VIDEO_CAPTURE = 1;
    private static final int PERMISSION_REQUEST_CAMERA_CODE = 1003;

    private SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");

    private VideoView videoView;
    private String curPath;

    public static void startUI(Context context) {
        Intent intent = new Intent(context, SystemRecordActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_system_record);
        videoView = findViewById(R.id.videoview);
    }

    private File createFile() throws IOException {
        String fileName = "VIDEO_" + sdf.format(new Date());
        File dir = getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File file = File.createTempFile(fileName, ".mp4", dir);
        // 保存文件路径
        curPath = file.getAbsolutePath();
        return file;
    }

    public void record(View view) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            // 无权限
            String[] permissions = new String[]{Manifest.permission.CAMERA};
            ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CAMERA_CODE);
        } else {
            // 有权限
            Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
            if (intent.resolveActivity(getPackageManager()) == null) {
                Log.e(TAG, "record intent 创建失败");
                return;
            }
            try {
                File file = createFile();
                Uri uri = FileProvider.getUriForFile(this, "com.bytedance.mediademo.fileprovider", file);
                intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
                startActivityForResult(intent, REQUEST_VIDEO_CAPTURE);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d(TAG, "触发回调" + requestCode + (resultCode == RESULT_OK));
        if (resultCode != RESULT_OK) {
            return;
        }
        switch (requestCode) {
            case REQUEST_VIDEO_CAPTURE:
                Uri uri = data.getData();
                videoView.setVideoURI(uri);
                videoView.start();
                break;
            default: break;
        }
    }

}
