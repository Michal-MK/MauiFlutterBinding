package com.maui.binding

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat.startActivity
import androidx.core.view.doOnAttach
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentContainerView
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ReportFragment.Companion.reportFragment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class Size(val width: Float, val height: Float)

class Binding {
    private var callback: StringCallback? = null
    private var flutterView: View? = null

    private var sizeReportedMethodChannel: MethodChannel? = null
    private var lastReportedSize: MutableMap<String, Size> = mutableMapOf()

    fun async(activity: Activity, parameters: List<String>, callback: StringCallback) {
        this.callback = callback
        GlobalScope.launch {
            delay(1000)
            this@Binding.callback?.onResult("${parameters[0]} ${parameters[1]}")
        }
    }

    fun getFlutterView(activity: Activity, type: String? = null): View {
        if (flutterView != null) {
            return flutterView as View
        }
        val view = FragmentContainerView(activity)
            .apply { id = View.generateViewId() }

        val entrypoint = "main${if (type != null) "_$type" else ""}"
        println("~LOG~ Creating Flutter fragment with entrypoint: $entrypoint")

        val flutterFragment = FlutterFragment.withNewEngine()
            .dartEntrypoint(entrypoint)
            .renderMode(RenderMode.texture)
            .build<FlutterFragment>()

        (activity as AppCompatActivity).supportFragmentManager.beginTransaction()
            .add(view.id, flutterFragment)
            .commit()

        // Wait for fragment to be created and engine to be ready
        flutterFragment.lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onCreate(owner: LifecycleOwner) {
                println("~LOG~ Flutter fragment onCreate called")
                flutterFragment.flutterEngine?.let { engine ->
                    println("~LOG~ Flutter engine is available")
                    // This is crucial - without this, plugins won't work
                    GeneratedPluginRegistrant.registerWith(engine)
                    println("~LOG~ Plugins registered")

                    setupMethodChannel(engine)
                } ?: println("~LOG~ Flutter engine is null!")
                owner.lifecycle.removeObserver(this)
            }
        })

        flutterView = view
        return view
    }
    
    fun getLastReportedSize(viewType: String): Size? {
        return lastReportedSize[viewType]
    }

    private fun setupMethodChannel(engine: FlutterEngine) {
        println("~LOG~ Setting up method channel")
        sizeReportedMethodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, "size_reporter")

        // Set up method call handler to receive calls from Flutter
        sizeReportedMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "reportSize" -> {
                    val viewType = call.argument<String>("viewType")
                    val width = call.argument<Double>("width")?.toFloat()
                    val height = call.argument<Double>("height")?.toFloat()

                    val size = Size(width ?: -1f, height ?: -1f)

                    if (viewType != null) {
                        println("~LOG~ Received size from Flutter: $viewType - $size")
                        lastReportedSize[viewType] = size
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "ViewType and Size are required", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}