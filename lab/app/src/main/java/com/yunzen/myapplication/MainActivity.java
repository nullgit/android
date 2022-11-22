package com.yunzen.myapplication;

import java.util.Date;
import java.util.stream.IntStream;

import com.yunzen.myapplication.lab1.Lab1Activity;
import com.yunzen.myapplication.lab2.Lab2Activity;
import com.yunzen.myapplication.lab3.Lab3Activity;
import com.yunzen.myapplication.lab4.Lab4Activity;
import com.yunzen.myapplication.lab5.Lab5Activity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        View[] labViews = new View[] { findViewById(R.id.lab1), findViewById(R.id.lab2), findViewById(R.id.lab3), findViewById(R.id.lab4),
                                       findViewById(R.id.lab5) //, findViewById(R.id.lab6), findViewById(R.id.lab7),
        };
        Class[] labActivities = new Class[] { Lab1Activity.class, Lab2Activity.class, Lab3Activity.class, Lab4Activity.class,
                                              Lab5Activity.class };

        IntStream.range(0, labViews.length).forEach(i -> labViews[i].setOnClickListener((view) -> {
            Log.i("click", new Date() + "点击了按钮，跳转到Lab1页面");
            startActivity(new Intent(MainActivity.this, labActivities[i]));
        }));

    }
}
