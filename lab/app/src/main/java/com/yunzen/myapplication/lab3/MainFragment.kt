package com.yunzen.myapplication.lab3

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import com.yunzen.myapplication.R

class MainFragment : Fragment() {
    companion object {
        const val TAG = "MainFragment"
    }
    var adapter: ViewPagerAdapter? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.d(TAG, "onCreateView")
        val view = inflater.inflate(R.layout.fragment_main, container, false)

        val viewPager2 = view.findViewById<ViewPager2>(R.id.view_pager2)
        adapter = ViewPagerAdapter(this)
        viewPager2.adapter = adapter

        val tabLayout = view.findViewById<TabLayout>(R.id.tab_layout)
        val tabLayoutMediator =
            TabLayoutMediator(tabLayout, viewPager2, true, false) { tab, position ->
                tab.text = ViewPagerAdapter.tabTitles[position]
            }
        tabLayoutMediator.attach()

        return view
    }

}