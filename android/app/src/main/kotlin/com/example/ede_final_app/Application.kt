package com.example.ede_final_app

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class Application : FlutterApplication() {
    lateinit var flutterEngine : FlutterEngine

    override fun onCreate() {
        super.onCreate()
        
        // Instantiate a FlutterEngine
        flutterEngine = FlutterEngine(this)
        
        // Start executing Dart code
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        // Cache the FlutterEngine
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)
    }
} 