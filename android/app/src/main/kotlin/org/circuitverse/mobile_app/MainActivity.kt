package org.circuitverse.mobile_app

import android.media.MediaScannerConnection
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.mobile_app/media_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        scanFile(path, result)
                    } else {
                        runOnUiThread {
                            result.error("INVALID_ARGUMENT", "Path cannot be null", null)
                        }
                    }
                }
                else -> {
                    runOnUiThread { result.notImplemented() }
                }
            }
        }
    }

    private fun scanFile(path: String, result: MethodChannel.Result) {
        try {
            MediaScannerConnection.scanFile(
                this,
                arrayOf(path),
                null
            ) { _, uri ->
                runOnUiThread {
                    if (uri != null) {
                        result.success("File scanned successfully")
                    } else {
                        result.error("SCAN_FAILED", "Failed to scan file", null)
                    }
                }
            }
        } catch (e: Exception) {
            runOnUiThread {
                result.error("SCAN_ERROR", "Error scanning file: ${e.message}", null)
            }
        }
    }
}