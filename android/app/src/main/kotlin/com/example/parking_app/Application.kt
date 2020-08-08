package com.example.parking_app

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
    }

    override fun registerWith(registry: PluginRegistry) {
        FlutterLocalNotificationPluginRegistrant.registerWith(registry)

    }
}