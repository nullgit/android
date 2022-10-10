package com.yunzen.myapplication.lab2;

import com.yunzen.myapplication.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class ContentActivity extends AppCompatActivity implements View.OnClickListener {

    private EditText evInput;

    @SuppressLint("DefaultLocale")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_content);

        TextView tvTitle = findViewById(R.id.tv_title);
        tvTitle.setText(String.format("这是从item %d进入的", getIntent().getIntExtra("position", -1)));

        evInput = findViewById(R.id.ev_input);

        View btn_finish = findViewById(R.id.btn_finish);
        btn_finish.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        fillResult();
        finish();
    }

    private void fillResult() {
        Intent intent = new Intent();
        intent.putExtra("change", evInput.getText().toString());
        intent.putExtra("position", getIntent().getIntExtra("position", -1));
        setResult(Activity.RESULT_OK, intent);
    }

    @Override
    public void onBackPressed() {
        fillResult();
        super.onBackPressed();
    }
}
