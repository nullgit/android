package com.yunzen.myapplication.lab2;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.yunzen.myapplication.R;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

public class Lab2Activity extends AppCompatActivity {

    private RVAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lab2);

        RecyclerView recyclerView = findViewById(R.id.rv);
        // 线性布局
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        // 设置分割线
        recyclerView.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.VERTICAL));
        // 数据
        List<String> dataList = Stream.iterate(0, i -> i + 1).limit(100).map(i -> "这是item" + i).collect(Collectors.toList());
        // 设置回调
        ActivityResultLauncher<Intent> register = registerForActivityResult(new ActivityResultContracts.StartActivityForResult(),
            result -> {
                Log.d("result", result.toString());
                Intent intent = result.getData();
                if (intent != null) {
                    int position = intent.getIntExtra("position", -1);
                    String change = intent.getStringExtra("change");
                    adapter.notifyItem(position, change);
                }
            });
        // 设置适配器
        adapter = new RVAdapter(dataList, register);
        recyclerView.setAdapter(adapter);
    }

}
