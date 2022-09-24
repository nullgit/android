package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("我的tag", "我的msg");
//        TextView tv = findViewById(R.id.main);
//        tv.setText("你好世界~~~");
        setContentView(R.layout.activity_main);

        View btn = findViewById(R.id.btn);
        btn.setOnClickListener((v)->{
            Intent intent = new Intent();
            intent.setClass(MainActivity.this, MainActivity2.class);
            startActivity(intent);
        });
    }
}
