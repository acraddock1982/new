package com.example.budgetwise

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.budgetwise.ui.theme.BudgetWiseTheme

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull
import com.trafi.qr_bar_scanner.QrBarScannerPlugin
import java.util.ArrayList

class MainActivity: FlutterActivity() {
    private var budget = 0.0
    private val scannedItems = ArrayList<String>()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Set up method channel for barcode scanning
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, QrBarScannerPlugin.CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "onCodeScanned") {
                    val scannedItem = call.arguments as String
                    handleScannedItem(scannedItem)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun handleScannedItem(scannedItem: String) {
        runOnUiThread {
            scannedItems.add(scannedItem)
            // Send the updated scanned items list to Dart side if needed
        }
    }
}
