package com.spendly

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.sms"
    private val REQUEST_CODE_SMS = 1001
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestSMSPermission" -> {
                        requestSMSPermission(result)
                    }
                    "getSMS" -> {
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS)
                            == PackageManager.PERMISSION_GRANTED) {
                            val smsList = getFilteredSMS()
                            result.success(smsList)
                        } else {
                            result.error("PERMISSION_DENIED", "SMS permission is not granted", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // Request SMS permission if not already granted.
    private fun requestSMSPermission(result: MethodChannel.Result) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS)
            != PackageManager.PERMISSION_GRANTED) {
            // Save the result callback to return the permission status later.
            permissionResult = result
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_SMS), REQUEST_CODE_SMS)
        } else {
            // Permission already granted.
            result.success(true)
        }
    }

    // Handle the permission request callback.
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_CODE_SMS) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            permissionResult?.success(granted)
            permissionResult = null
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    // Read SMS from the device's SMS inbox and filter for SBI UPI messages.
    private fun getFilteredSMS(): List<Map<String, String>> {
        val smsList = mutableListOf<Map<String, String>>()
        val uri: Uri = Uri.parse("content://sms/inbox")
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
        if (cursor != null && cursor.moveToFirst()) {
            do {
                val address = cursor.getString(cursor.getColumnIndex("address"))
                val body = cursor.getString(cursor.getColumnIndex("body"))
                
                // Filter criteria:
                // For debit messages: Contains "debited" and "UPI" (e.g., "Dear UPI user ... debited ... -SBI")
                // For credit messages: Contains "credited" and "SBI User" (e.g., "Dear SBI User, your A/c ... -credited ... -SBI")
                val isDebit = body.contains("debited", ignoreCase = true) && body.contains("UPI", ignoreCase = true)
                val isCredit = body.contains("credited", ignoreCase = true) && body.contains("SBI User", ignoreCase = true)
                
                if (isDebit || isCredit) {
                    val smsMap = mapOf("address" to address, "body" to body)
                    smsList.add(smsMap)
                }
            } while (cursor.moveToNext())
            cursor.close()
        }
        return smsList
    }
}

