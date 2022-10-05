package com.yunzen.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.View;

import java.util.Arrays;
import java.util.Date;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View[] labViews = new View[] { findViewById(R.id.lab1), findViewById(R.id.lab2),
//                findViewById(R.id.lab3), findViewById(R.id.lab4),
//                                       findViewById(R.id.lab5), findViewById(R.id.lab6), findViewById(R.id.lab7),
//                                       findViewById(R.id.lab8),
        };
        Class[] labActivities = new Class[] {
                Lab1Activity.class,
                Lab2Activity.class,
        };

        for (int i=0;i<labViews.length;++i) {
            final int j = i;
            labViews[i].setOnClickListener((view) -> {
                Log.i("click", new Date() + "点击了按钮，跳转到Lab1页面");
                startActivity(new Intent(MainActivity.this, labActivities[j]));
            });
        }

    }
}
