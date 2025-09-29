package com.example.braintoss
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


object NativeMethodChannel {
    private const val CHANNEL_NAME = "AppChannel"
    private lateinit var methodChannel: MethodChannel
    fun configureChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
    }

    fun passDataToFlutter(info: Map<String, String>) {
        methodChannel.invokeMethod("uploadFromCar", info)
    }
}