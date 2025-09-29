package com.example.braintoss

import android.Manifest.permission.BLUETOOTH_CONNECT
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
//import com.smartdevicelink.transport.SdlBroadcastReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        //GeneratedPluginRegistrant.registerWith(flutterEngine);
        java.lang.Thread.sleep(1000);
        super.configureFlutterEngine(flutterEngine)
        NativeMethodChannel.configureChannel(flutterEngine)
    }

    // private fun requestPermission() {
    //     ActivityCompat.requestPermissions(this, arrayOf<String>(BLUETOOTH_CONNECT), REQUEST_CODE)
    // }
    // private fun checkPermission(): Boolean {
    //     return PackageManager.PERMISSION_GRANTED == ContextCompat.checkSelfPermission(
    //         applicationContext, BLUETOOTH_CONNECT
    //     )
    // }

    // val REQUEST_CODE: Int = 200

    // override fun onRequestPermissionsResult(
    //     requestCode: Int,
    //     permissions: Array<String?>,
    //     grantResults: IntArray
    // ) {
    //     when (requestCode) {
    //         REQUEST_CODE -> if (grantResults.size > 0) {
    //             val btConnectGranted = grantResults[0] == PackageManager.PERMISSION_GRANTED

    //             if (btConnectGranted) {
    //                 //Bluetooth permissions have been granted by the user so we can try to start out SdlService.
    //                 SdlBroadcastReceiver.queryForConnectedService(this)
    //             }
    //         }
    //     }
    // }

    override fun onCreate(savedInstanceState: Bundle?) {
        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
            this.finish()
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        }

        super.onCreate(savedInstanceState)


        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !checkPermission()) {
        //     requestPermission()
        //     return
        // }
        // This line of code is for production
        //SdlBroadcastReceiver.queryForConnectedService(this)
        // used for TCP - This two lines of code are TCP connection for emulator
//         val sdlServiceIntent = Intent(this, SdlService::class.java)
//         startService(sdlServiceIntent)
    }
}