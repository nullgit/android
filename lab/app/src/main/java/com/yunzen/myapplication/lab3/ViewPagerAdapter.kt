package com.yunzen.myapplication.lab3

import android.util.Log
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter

class ViewPagerAdapter(fragment: Fragment) : FragmentStateAdapter(fragment) {
    companion object {
        const val TAG = "ViewPagerAdapter"
        val fragments = listOf({ Fragment1() }, { Fragment2() }, { Fragment3() })
        val tabTitles = listOf("视图动画(加载后淡出播放)", "属性动画(接tab1)", "lottie动画(循环)")
    }

    override fun getItemCount(): Int {
        return fragments.size
    }

    override fun createFragment(position: Int): Fragment {
        Log.d(TAG, "createFragment: $position")
        return fragments[position]()
    }

}
