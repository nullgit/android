package com.yunzen.myapplication.lab4

import android.content.Context
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Log
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.yunzen.myapplication.R
import kotlin.math.roundToInt

class Lab4Activity : AppCompatActivity() {
    companion object {
        const val TAG = "Lab4"
        fun formatRemain(remain: Int): String {
            if (remain == 60) {
                return "01:00"
            }
            return "00:${if (remain < 10) "0" else ""}$remain"
        }
    }

    lateinit var text: TextView
    lateinit var btn1: Button
    lateinit var btn2: Button
    private var state: ClockState = ClockState.STOP
    var remain: Int = 60
    lateinit var timer: CountDownTimer
    lateinit var self: Context

    enum class ClockState {
        STOP,
        RUNNING,
        PAUSE,
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_lab4)

        text = findViewById(R.id.clock_text)
        btn1 = findViewById(R.id.clock_btn1)
        btn2 = findViewById(R.id.clock_btn2)
        self = this

        btn1.setOnClickListener {
            when (state) {
                ClockState.STOP -> {
                    timer = buildTimer(60_000)
                    state = ClockState.RUNNING
                    btn1.setText(R.string.pause)
                    timer.start()
                }
                ClockState.RUNNING -> {
                    timer.cancel()
                    state = ClockState.PAUSE
                    btn1.setText(R.string.resume)
                }
                ClockState.PAUSE -> {
                    timer = buildTimer(remain * 1000L)
                    state = ClockState.RUNNING
                    btn1.setText(R.string.pause)
                    timer.start()
                }
            }
        }
        btn2.setOnClickListener {
            timer.cancel()
            state = ClockState.STOP
            btn1.setText(R.string.start)
            text.setText(R.string._01_00)
        }
    }

    private fun buildTimer(duration: Long): CountDownTimer {
        return object : CountDownTimer(duration, 1_000) {
            override fun onTick(millisUntilFinished: Long) {
                Log.d(TAG, millisUntilFinished.toString())
                remain = (millisUntilFinished.toDouble() / 1_000).roundToInt()
                text.setText(formatRemain(remain))
            }

            override fun onFinish() {
                Log.d(TAG, "finish")
                Toast.makeText(self, "结束", Toast.LENGTH_SHORT).show()
                state = ClockState.STOP
                text.setText(R.string._00_00)
                btn1.setText(R.string.restart)
            }
        }
    }

}
