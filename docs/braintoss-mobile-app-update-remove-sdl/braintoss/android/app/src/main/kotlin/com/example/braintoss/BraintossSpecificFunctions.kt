//@file:Suppress("DEPRECATION")
//
package com.example.braintoss
//
//import android.content.Context
//import android.net.Uri
//import android.os.AsyncTask
//import android.os.Build
//import android.util.Base64
//import android.util.Log
//import com.example.braintoss.NativeMethodChannel
//import com.example.braintoss.TAG
//import com.koushikdutta.ion.Ion
//import com.smartdevicelink.proxy.rpc.AudioPassThruCapabilities
//import java.io.ByteArrayInputStream
//import java.io.File
//import java.io.IOException
//import java.io.ObjectInputStream
//import java.util.*
//
//const val API_KEY = "PFGBNakkoyJ7Ry9N3E3xgnCYbLPxFK8K"
//
//fun sendToEmail(userId: String, file: File, email: Email, capabilitiesState : AudioPassThruCapabilities, context: Context, success : (email : String) -> Unit, error : (email : String) -> Unit){
//    val messageIdToSend = UUID.randomUUID().toString()
//    object : AsyncTask<Void?, Void?, Void?>() {
//        override fun doInBackground(vararg p0: Void?): Void? {
//            uploadFile(buildUploadUrl(file,userId,capabilitiesState, context, email.emailAddress, messageIdToSend), file, context, success, error, email)
//            return null
//        }
//
//    }.execute(null)
//
//    val info = mapOf("messageId" to messageIdToSend,"emailParam" to email.emailAddress,"fileURL" to file.path)
//    NativeMethodChannel.passDataToFlutter(info)
//}
//
//fun buildUploadUrl(file: File,userId: String,capabilitiesState : AudioPassThruCapabilities, context: Context, email: String, messageId: String): String {
//    context.getSharedPreferences("FlutterSharedPreferences", 0).apply {
//        val language = getString("flutter.languageCode", "en_US");
//
//        val os = "android-${Build.VERSION.SDK_INT}"
//
//        val uri = Uri.parse("https://api.braintoss.com").buildUpon()
//                .appendQueryParameter("key", API_KEY)
//                .appendQueryParameter("uid", userId)
//                .appendQueryParameter("lang", language)
//                .appendQueryParameter("d", "${Build.DEVICE}-ford")
//                .appendQueryParameter("mid", messageId)
//                .appendQueryParameter("os", os)
//                .appendQueryParameter("v", BuildConfig.VERSION_NAME)
//                .build()
//
//        val result = "$uri&email=$email&rate=${capabilitiesState?.samplingRate.toString().replace("KHZ", "000")}"
//
//        return result
//    }
//}
//
//
//fun uploadFile(urlString: String, file: File?, context: Context?, success : (email : String) -> Unit, error : (email : String) -> Unit, email : Email) {
//    Log.d("huerta", "file exists: ${file?.exists()} size(human): ${file?.length() ?: 1} location: ${file?.absolutePath}")
//    Ion.with(context)
//            .load(urlString)
//            .setMultipartFile("file", file)
//            .asString()
//            .setCallback { e: java.lang.Exception?, result: String? ->
//                var value= if (email.alias != "") email.alias else email.emailAddress
//                if(e == null) {
//                    success(value)
//                } else {
//                    error(value)
//                }
//            }
//}
