package com.haxos.nat.application

import android.content.Context
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Helper class that initializes a set of debugging tools
 * for the debug build type and register crash manager for release type.
 * ## Debug type tools:
 * - AndroidDevMetrics
 * - Stetho
 * - StrictMode
 * - Timber
 *
 * ## Release type tools:
 * - CrashManager
 */
@Singleton
class DebugMetricsHelper @Inject constructor() {

    internal fun init(@Suppress("UNUSED_PARAMETER") context: Context) = Unit
}
