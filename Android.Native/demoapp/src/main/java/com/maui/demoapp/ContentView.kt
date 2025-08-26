package com.maui.demoapp

import android.app.Activity
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.Button
import androidx.compose.material.Tab
import androidx.compose.material.TabRow
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import com.maui.binding.Binding
import com.maui.binding.StringCallback
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue // only if using var
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.graphics.Color
import com.maui.binding.SizeChangeCallback
val binding = Binding()

@Composable
fun ContentView() {
    var tabIndex by remember { mutableStateOf(0) }

    val tabs = listOf("Flutter", "Test")

    Column(modifier = Modifier.fillMaxWidth()) {
        TabRow(selectedTabIndex = tabIndex) {
            tabs.forEachIndexed { index, title ->
                Tab(text = { Text(title) },
                    selected = tabIndex == index,
                    onClick = { tabIndex = index }
                )
            }
        }
        when (tabIndex) {
            0 -> FlutterView()
            1 -> TestView()
        }
    }
}

@Composable
fun TestView() {
    val context = LocalContext.current as Activity
    var result by remember { mutableStateOf<String?>(null) }

    Column(Modifier.fillMaxSize(), verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
        result?.let {
            Text(it)
        } ?: run {
            Button(onClick = {
                result = "Loading ..."
                Binding().async(context, listOf("Hello", "world!"), StringCallbackImpl {
                    result = it
                })
            }) {
                Text("Async")
            }
        }
    }
}

class StringCallbackImpl(val callback: (String?) -> Unit) : StringCallback {
    override fun onResult(result: String) {
        callback(result)
    }
}

@Composable
fun FlutterView() {
    val activity = LocalContext.current as AppCompatActivity
    val scrollState = rememberScrollState()
    
    // State to track Flutter content size
    var flutterContentHeight by remember { mutableStateOf(400.dp) }
    
    // Size change callback
    DisposableEffect(Unit) {
        val callback = object : SizeChangeCallback {
            override fun onSizeChanged(viewType: String, width: Float, height: Float) {
                if (viewType == "component_two" && height > 0) {
                    flutterContentHeight = height.dp
                    println("~LOG~ Flutter content height updated to: ${height}dp")
                }
            }
        }
        
        binding.setSizeChangeCallback(callback)
        
        onDispose {
            binding.setSizeChangeCallback(null)
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(scrollState)
    ) {
        // Top colored box
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(300.dp)
                .background(Color.Red)
                .padding(16.dp)
        ) {
            Text(
                text = "Top Box - Scroll down to see Flutter content",
                color = Color.White,
                modifier = Modifier.align(Alignment.Center)
            )
        }
        
        // Another colored box
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(200.dp)
                .background(Color.Blue)
                .padding(16.dp)
        ) {
            Text(
                text = "Blue Box - Flutter view is below",
                color = Color.White,
                modifier = Modifier.align(Alignment.Center)
            )
        }
        
        // Flutter view with dynamic height
        AndroidView(
            modifier = Modifier
                .fillMaxWidth()
                .height(flutterContentHeight), // Use dynamic height from size reporter
            factory = {
                // Creates view
                binding.getFlutterView(activity, "component_two", 500f, 400f)
            },
            update = { view ->
                // View's been inflated or state read in this block has been updated
                // Add logic here if necessary

                // As selectedItem is read here, AndroidView will recompose
                // whenever the state changes
                // Example of Compose -> View communication
            }
        )
        
        // Bottom colored boxes to enable scrolling
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(350.dp)
                .background(Color.Green)
                .padding(16.dp)
        ) {
            Text(
                text = "Green Box - Below Flutter content",
                color = Color.White,
                modifier = Modifier.align(Alignment.Center)
            )
        }
        
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(300.dp)
                .background(Color.Magenta)
                .padding(16.dp)
        ) {
            Text(
                text = "Bottom Box - End of scrollable content",
                color = Color.White,
                modifier = Modifier.align(Alignment.Center)
            )
        }
    }
}