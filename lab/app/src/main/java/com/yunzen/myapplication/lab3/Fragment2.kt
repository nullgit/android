package com.yunzen.myapplication.lab3

import android.animation.Animator
import android.animation.AnimatorInflater
import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.widget.TextView
import androidx.core.content.edit
import androidx.fragment.app.Fragment
import com.airbnb.lottie.LottieAnimationView
import com.yunzen.myapplication.R

class Fragment2 : Fragment() {

    companion object {
        const val TAG = "Fragment2"
        val animatorList = listOf(
            R.animator.object_translate,
            R.animator.object_alpha,
            R.animator.object_scale,
            R.animator.object_rotation
        )
    }

    var triangle: TextView? = null
    var loadingView : LottieAnimationView?=null
    var shalter :View? = null
    var counter = 0

    private val animatorListener = object : DefaultAnimatorListener() {
        override fun onAnimationEnd(animation: Animator?) {
            counter += 1
        }
    }

    private val loadingAnimationListener = object : DefaultAnimatorListener() {
        override fun onAnimationEnd(animation: Animator?) {
            loadingView?.visibility = View.GONE
            triangle?.visibility = View.VISIBLE

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
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate")
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.d(TAG, "onCreateView")
        val view = inflater.inflate(R.layout.fragment_2, container, false)
        triangle = view.findViewById(R.id.triangle)

        triangle?.setOnClickListener {
            loadAndStartAnimator()
        }

        return view
    }

    private fun loadAndStartAnimator() {
        val loadAnimator =
            AnimatorInflater.loadAnimator(context, animatorList[counter % animatorList.size])
        loadAnimator.setTarget(triangle)
        loadAnimator.start()
        loadAnimator.addListener(animatorListener)
        Log.d(TAG, "counter2: $counter")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
        triangle?.visibility = View.GONE
        shalter = view?.findViewById(R.id.shelter2)
        shalter?.visibility = View.GONE

        loadingView = view?.findViewById(R.id.lottieView2)
        loadingView?.repeatCount = 0
        loadingView?.addAnimatorListener(loadingAnimationListener)
        loadingView?.visibility = View.VISIBLE
        loadingView?.playAnimation()
        counter =
            activity?.getSharedPreferences("lab3", Context.MODE_PRIVATE)?.getInt("counter", 0) ?: 0
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
        activity?.getSharedPreferences("lab3", Context.MODE_PRIVATE)?.edit {
            putInt("counter", counter)
        }
    }

}
