package com.haxos.nat.feature.main

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import timber.log.Timber
import javax.inject.Inject

@HiltViewModel
class MainActivityViewModel @Inject constructor() : ViewModel() {
    // TODO : Example
    fun test() {
        Timber.d("TODO : remove sample dagger setup $this")
    }
}
