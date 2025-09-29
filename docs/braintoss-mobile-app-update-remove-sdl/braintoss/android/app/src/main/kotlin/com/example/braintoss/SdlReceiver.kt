package com.example.braintoss
//
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import android.os.Parcelable
//import com.smartdevicelink.transport.SdlBroadcastReceiver
//import com.smartdevicelink.util.DebugTool
//import com.smartdevicelink.transport.TransportConstants
//import com.smartdevicelink.util.AndroidTools
//
//class SdlReceiver : SdlBroadcastReceiver() {
//    private val RECONNECT_LANG_CHANGE = "RECONNECT_LANG_CHANGE"
//    override fun onSdlEnabled(context: Context, intent: Intent) {
//        DebugTool.logInfo("SDL Enabled", "SDL Enabled")
//        intent.setClass(context, SdlService::class.java)
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
//            if (!AndroidTools.hasForegroundServiceTypePermission(context)) {
//                DebugTool.logInfo(TAG, "Permission missing for ForegroundServiceType connected device." + context);
//                return;
//            }
//        }
//
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//            if (intent.getParcelableExtra<Parcelable?>(TransportConstants.PENDING_INTENT_EXTRA) != null) {
//                val pendingIntent = intent.getParcelableExtra<Parcelable>(TransportConstants.PENDING_INTENT_EXTRA) as PendingIntent?
//                try {
//                    pendingIntent!!.send(context, 0, intent)
//                } catch (e: PendingIntent.CanceledException) {
//                    e.printStackTrace()
//                }
//            }
//        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            context.startForegroundService(intent)
//        } else {
//            context.startService(intent)
//        }
//    }
//
//    override fun defineLocalSdlRouterClass(): Class<out SdlRouterService?> {
//        return SdlRouterService::class.java
//    }
//
//
//    override fun onReceive(context: Context?, intent: Intent?) {
//        super.onReceive(context, intent)
//        context?.let { nonNullContext ->
//            if (intent != null) {
//                val action = intent.action
//                if (action != null) {
//                    if (action.equals(TransportConstants.START_ROUTER_SERVICE_ACTION, ignoreCase = true)) {
//                        if (intent.getBooleanExtra(RECONNECT_LANG_CHANGE, false)) {
//                            onSdlEnabled(nonNullContext, intent)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}