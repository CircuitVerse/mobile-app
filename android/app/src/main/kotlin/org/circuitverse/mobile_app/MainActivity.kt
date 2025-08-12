package org.circuitverse.mobile_app

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Legacy media scanner
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.mobile_app/media_scanner")
            .setMethodCallHandler { call, result ->
                if (call.method == "scanFile") {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(this, arrayOf(path), null) { _, uri ->
                            if (uri != null) result.success("File scanned successfully")
                            else result.error("SCAN_FAILED", "Failed to scan file", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Path cannot be null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }

        // MediaStore for Android 10+
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.mobile_app/media_store")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getApiLevel" -> result.success(Build.VERSION.SDK_INT)
                    "saveToPictures" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val filename = call.argument<String>("filename")
                        val mimeType = call.argument<String>("mimeType")
                        
                        if (bytes != null && filename != null && mimeType != null) {
                            saveToPictures(bytes, filename, mimeType, result)
                        } else {
                            result.error("INVALID_ARGUMENT", "Missing required arguments", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun saveToPictures(bytes: ByteArray, filename: String, mimeType: String, result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val contentValues = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, filename)
                    put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                    put(MediaStore.MediaColumns.RELATIVE_PATH, "${Environment.DIRECTORY_PICTURES}/CircuitVerse")
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                }

                val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
                uri?.let {
                    val out = contentResolver.openOutputStream(it)
                    if (out == null) {
                        runOnUiThread { result.error("SAVE_ERROR", "OutputStream is null", null) }
                        return
                    }
                    out.use { stream -> stream.write(bytes) }
                    // Mark as not pending
                    val finalizeValues = ContentValues().apply {
                        put(MediaStore.MediaColumns.IS_PENDING, 0)
                    }
                    contentResolver.update(it, finalizeValues, null, null)
                    runOnUiThread { result.success(true) }
                } ?: runOnUiThread { result.error("MEDIASTORE_ERROR", "Failed to create MediaStore entry", null) }
            } else {
                runOnUiThread { result.error("API_VERSION_ERROR", "MediaStore method requires Android 10+", null) }
            }
        } catch (e: Exception) {
            runOnUiThread { result.error("SAVE_ERROR", "Failed to save: ${e.message}", null) }
        }
    }
}