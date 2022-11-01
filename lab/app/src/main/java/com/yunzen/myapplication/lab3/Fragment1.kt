package com.yunzen.myapplication.lab3

import android.animation.Animator
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.Animation.AnimationListener
import android.view.animation.AnimationUtils
import androidx.core.content.edit
import androidx.fragment.app.Fragment
import com.airbnb.lottie.LottieAnimationView
import com.yunzen.myapplication.R


class Fragment1 : Fragment() {
    companion object {
        const val TAG = "Fragment1"
        val animationList = listOf(R.anim.translate, R.anim.alpha, R.anim.scale, R.anim.rotate)
    }

    var box: View? = null
    var loadingView :LottieAnimationView?=null
    var shalter :View? = null
    var counter = 0

    private val animationListener = object : DefaultAnimationListener() {
        override fun onAnimationEnd(animation: Animation?) {
            counter += 1
            loadAndStartAnimation()
        }
    }

    private val loadingAnimationListener = object : DefaultAnimatorListener() {
        override fun onAnimationEnd(animation: Animator?) {
            loadingView?.visibility = View.GONE

            box?.visibility = View.VISIBLE
            counter =
                activity?.getSharedPreferences("lab3", Context.MODE_PRIVATE)?.getInt("counter", 0)
                    ?: 0
            loadAndStartAnimation()

            shalter?.visibility = View.VISIBLE
            val fadeOutAnimation = AnimationUtils.loadAnimation(context, R.anim.fade_out)
            fadeOutAnimation.setAnimationListener(fadeOutAnimationListener)
            shalter?.startAnimation(fadeOutAnimation)
        }
    }

    private val fadeOutAnimationListener = object : DefaultAnimationListener() {
        override fun onAnimationEnd(animation: Animation?) {
            shalter?.visibility = View.GONE
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d(TAG, "onCreate")
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.d(TAG, "onCreateView")
        val view = inflater.inflate(R.layout.fragment_1, container, false)
        box = view.findViewById(R.id.box)
        return view
    }

    private fun loadAndStartAnimation() {
        val animation =
            AnimationUtils.loadAnimation(context, animationList[counter % animationList.size])
        animation.setAnimationListener(animationListener)
        box?.startAnimation(animation)
        Log.d(TAG, "counter1: $counter")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
        box?.visibility = View.GONE
        shalter = view?.findViewById(R.id.shelter1)
        shalter?.visibility = View.GONE

        loadingView = view?.findViewById(R.id.lottieView1)
        loadingView?.repeatCount = 0
        loadingView?.addAnimatorListener(loadingAnimationListener)
        loadingView?.visibility = View.VISIBLE
        loadingView?.playAnimation()
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
        activity?.getSharedPreferences("lab3", Context.MODE_PRIVATE)?.edit {
            putInt("counter", counter)
        }
    }

}
