package com.haxos.nat.application

import android.app.Application
import dagger.hilt.android.HiltAndroidApp
import javax.inject.Inject

@HiltAndroidApp
class App : Application() {

    @Inject
    lateinit var debugMetricsHelper: DebugMetricsHelper

    override fun onCreate() {
        super.onCreate()
        debugMetricsHelper.init(this)
    }
}
