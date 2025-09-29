package com.example.braintoss
//
//import android.app.Notification
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.Service
//import android.content.Intent
//import android.os.Build
//import android.os.IBinder
//import android.util.Log
//import com.example.braintoss.sendToEmail
//import com.smartdevicelink.managers.CompletionListener
//import com.smartdevicelink.managers.SdlManager
//import com.smartdevicelink.managers.SdlManagerListener
//import com.smartdevicelink.managers.file.filetypes.SdlArtwork
//import com.smartdevicelink.managers.lifecycle.LifecycleConfigurationUpdate
//import com.smartdevicelink.managers.lockscreen.LockScreenConfig
//import com.smartdevicelink.managers.screen.AlertAudioData
//import com.smartdevicelink.managers.screen.AlertView
//import com.smartdevicelink.managers.screen.SoftButtonObject
//import com.smartdevicelink.managers.screen.SoftButtonState
//import com.smartdevicelink.managers.screen.choiceset.ChoiceCell
//import com.smartdevicelink.managers.screen.choiceset.ChoiceSet
//import com.smartdevicelink.managers.screen.choiceset.ChoiceSetSelectionListener
//import com.smartdevicelink.managers.screen.menu.MenuCell
//import com.smartdevicelink.managers.screen.menu.VoiceCommand
//import com.smartdevicelink.managers.screen.menu.VoiceCommandSelectionListener
//import com.smartdevicelink.protocol.enums.FunctionID
//import com.smartdevicelink.proxy.RPCNotification
//import com.smartdevicelink.proxy.RPCResponse
//import com.smartdevicelink.proxy.rpc.*
//import com.smartdevicelink.proxy.rpc.enums.*
//import com.smartdevicelink.proxy.rpc.listeners.OnRPCNotificationListener
//import com.smartdevicelink.proxy.rpc.listeners.OnRPCResponseListener
//import com.smartdevicelink.transport.MultiplexTransportConfig
//import com.smartdevicelink.transport.TCPTransportConfig
//import com.smartdevicelink.util.DebugTool
//import com.smartdevicelink.util.SystemInfo
//import org.json.JSONArray
//import org.json.JSONObject
//import java.io.File
//import java.util.*
//
//
//const val TAG = "BRAINTOSS-SDL"
//
//data class Email(
//        val emailAddress: String,
//        val alias: String
//)
//
//class SdlService : Service() {
//    private val CHANNEL_ID = "Braintoss"
//    private val APP_NAME = "Braintoss"
//    private val APP_ID = "4c5fc5e3-1902-41d2-a2cb-8ce0c8fb5bbc"
//    private var sdlManager: SdlManager? = null
//
//    private val maxDuration: Int = 32000
//    private val audioRecorder: SdlAudioRecorder = SdlAudioRecorder()
//    private var fileName: String? = null
//    private var capabilitiesState: AudioPassThruCapabilities? = null
//    private var userId: String = UUID.randomUUID().toString()
//    val emails: MutableList<Email> = ArrayList()
//
//
//    override fun onCreate() {
//        super.onCreate()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel("channelId", "channelName", NotificationManager.IMPORTANCE_DEFAULT)
//            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//            if (notificationManager != null) {
//                notificationManager.createNotificationChannel(channel)
//                val serviceNotification = Notification.Builder(this, channel.id)
//                        .setContentTitle("FORD")
//                        .setSmallIcon(R.drawable.sdl_app_icon)
//                        .setContentText("Ford Linked")
//                        .setChannelId(channel.id)
//                        .build()
//                startForeground(FOREGROUND_SERVICE_ID, serviceNotification)
//            }
//        }
//    }
//
//    override fun onDestroy() {
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
//            notificationManager.deleteNotificationChannel(CHANNEL_ID)
//            stopForeground(true)
//        }
//        sdlManager!!.dispose()
//        super.onDestroy()
//    }
//
//    override fun onBind(intent: Intent): IBinder? {
//        return null
//    }
//
//    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
//        if (sdlManager == null) {
//            val transport = MultiplexTransportConfig(this, APP_ID, MultiplexTransportConfig.FLAG_MULTI_SECURITY_OFF)
//
//            val appType = Vector<AppHMIType>()
//            appType.add(AppHMIType.DEFAULT)
//
//            val listener: SdlManagerListener = object : SdlManagerListener {
//                override fun onStart() {
//                    sdlManager?.systemCapabilityManager?.takeIf { it.isCapabilitySupported(SystemCapabilityType.AUDIO_PASSTHROUGH) }?.getCapability(SystemCapabilityType.AUDIO_PASSTHROUGH, null,true)?.let { listOfCapabilities ->
//                        if (listOfCapabilities is List<*>) {
//                            (listOfCapabilities as List<AudioPassThruCapabilities>).firstOrNull()?.let { capabilities ->
//                                capabilitiesState = capabilities
//
//                                sdlManager?.let { nonNullSdlManager ->
//                                } ?: { Log.d(TAG, "sdlManager was null at this point") }.invoke()
//                            } ?: { Log.d(TAG, "could not get the capability at index 0")}.invoke()
//                        } else {
//                            Log.e(TAG, "capabilities is not of the right type")
//                        }
//                    } ?: Log.e(TAG, "no sdlManager or capabilityManager available")
//                }
//
//                override fun onDestroy() {
//                    this@SdlService.stopSelf()
//                }
//
//                override fun onError(info: String, e: Exception) {}
//                override fun managerShouldUpdateLifecycle(language: Language, hmiLanguage: Language): LifecycleConfigurationUpdate {
//                    val update = LifecycleConfigurationUpdate()
//                    return update
//                }
//
//                override fun onSystemInfoReceived(systemInfo: SystemInfo): Boolean {
//                    return true
//                }
//            }
//
//            val appIcon = SdlArtwork("ic_launcher_round", FileType.GRAPHIC_PNG, R.drawable.sdl_app_icon, true)
//            val lockScreenConfig = LockScreenConfig()
//
//            val builder = SdlManager.Builder(this, APP_ID, APP_NAME, listener)
//            builder.setAppTypes(appType)
//            builder.setAppIcon(appIcon)
//            builder.setLockScreenConfig(lockScreenConfig)
//
//            // This is a connection for HEAD UNIT
//            builder.setTransportType(transport)
//            // This is a TCP connection for emulator
////             builder.setTransportType(TCPTransportConfig(18951, "m.sdl.tools", false))
//
//            sdlManager = builder.build()
//            val onRPCNotificationListenerMap: MutableMap<FunctionID, OnRPCNotificationListener> = HashMap()
//            onRPCNotificationListenerMap[FunctionID.ON_HMI_STATUS] = object : OnRPCNotificationListener() {
//                override fun onNotified(notification: RPCNotification) {
//                    val onHMIStatus = notification as OnHMIStatus
//                    if (onHMIStatus.hmiLevel == HMILevel.HMI_FULL && onHMIStatus.firstRun) {
//                        // first time in HMI Full
//                        sdlManager?.let { nonNullSDLManager ->
//                            setMainScreen(nonNullSDLManager)
//                        }
//                    }
//                }
//            }
//            builder.setRPCNotificationListeners(onRPCNotificationListenerMap)
//            sdlManager = builder.build().apply { start() }
//        }
//        return START_STICKY
//    }
//
//    companion object {
//        private const val FOREGROUND_SERVICE_ID = 12345
//    }
//
//    private fun onSuccessSendingFile (email : String) {
//        showAlert("Your message was sent to $email.", "Message sent")
//    }
//
//    private fun onErrorSendingFile (email : String) {
//        showAlert("Oops! Could not upload note. Please try again!", "Could not save note. Please try again")
//    }
//
//    private fun showAlert(message : String, speech : String) {
//        val isAlertAllowed = sdlManager!!.permissionManager.isRPCAllowed(FunctionID.ALERT)
//
//        if(isAlertAllowed){
//            val builder = AlertView.Builder()
//            builder.setText(message)
//            val alertView = builder.build()
//            val alertAudioData = AlertAudioData(speech)
//            alertView.audio = alertAudioData
//            sdlManager!!.screenManager.presentAlert(alertView, null)
//        }
//
//    }
//
//    private fun setMainScreen(sdlManagerIncoming: SdlManager) {
//        sdlManagerIncoming.screenManager?.let { screen ->
//
//            screen.beginTransaction()
//            val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
//            val emailList = prefs.getString("flutter.emailList", null);
//            val defaultEmail = prefs.getString("flutter.email", null);
//
//            if(defaultEmail == null){
//                val templateConfiguration = TemplateConfiguration().setTemplate(PredefinedLayout.GRAPHIC_WITH_TEXT.toString())
//
//                screen.primaryGraphic = SdlArtwork("Braintoss-BackgroundHome", FileType.GRAPHIC_PNG, R.drawable.sdl_background_home, true)
//                sdlManager!!.getScreenManager().setTextField1("Please, enter the email address in the Braintoss app.");
//
//                sdlManager!!.screenManager.changeLayout(templateConfiguration) { success ->
//                    if (success) {
//                        DebugTool.logInfo(TAG, "Layout set successfully")
//                    } else {
//                        DebugTool.logInfo(TAG, "Layout not set successfully")
//                    }
//                }
//
//            } else {
//                val templateConfiguration = TemplateConfiguration().setTemplate(PredefinedLayout.GRAPHIC_WITH_TILES.toString())
//
//                sdlManager!!.screenManager.changeLayout(templateConfiguration) { success ->
//                    if (success) {
//                        DebugTool.logInfo(TAG, "Layout set successfully")
//                    } else {
//                        DebugTool.logInfo(TAG, "Layout not set successfully")
//                    }
//                }
//
//                screen.primaryGraphic = SdlArtwork("Braintoss-BackgroundHome", FileType.GRAPHIC_PNG, R.drawable.sdl_background_home, true)
//                val voiceButtonState = SoftButtonState("Default", "Voice", SdlArtwork("Braintoss-ButtonVoice", FileType.GRAPHIC_PNG, R.drawable.sdl_button_voice, true))
//                val voiceButton = SoftButtonObject("VoiceButton", voiceButtonState, object : SoftButtonObject.OnEventListener {
//                    override fun onPress(softButtonObject: SoftButtonObject?, onButtonPress: OnButtonPress?) {
//                        sdlManager?.let {
//                            recordNote()
//                        }
//                    }
//
//                    override fun onEvent(softButtonObject: SoftButtonObject?, onButtonEvent: OnButtonEvent?) {
//                        Log.d(TAG, "g. onEvent called , onButtonEvent: $onButtonEvent")
//                    }
//                })
//
//                screen.softButtonObjects = listOf(voiceButton)
//
//                val mJsonObject: JSONObject = JSONObject(defaultEmail)
//                if(defaultEmail != null){
//                    val email: String = mJsonObject.getString("emailAddress");
//                    val alias: String = mJsonObject.getString("alias");
//                    emails.add(0, Email(emailAddress = email, alias = alias));
//                }
//
//                val cell = MenuCell("Voice", "", "", SdlArtwork("Braintoss-ButtonVoice", FileType.GRAPHIC_PNG, R.drawable.sdl_button_voice, true), null, Collections.singletonList("Record Note")) {
//                    sdlManager?.let {
//                        recordNote()
//                    }
//                }
//
//                sdlManager!!.screenManager.menu = Collections.singletonList(cell)
//
//                if (sdlManagerIncoming.systemCapabilityManager?.isCapabilitySupported(SystemCapabilityType.VOICE_RECOGNITION) == true) {
//                    screen.voiceCommands = mutableListOf(VoiceCommand(mutableListOf("Take note"), object : VoiceCommandSelectionListener {
//                        override fun onVoiceCommandSelected() {
//                            Log.d(TAG, "h. onVoiceCommandSelected")
//                            sdlManager?.let {
//                                recordNote()
//                            }
//                        }
//                    }))
//                }
//            }
//
//            if(emailList != null){
//                val mJsonArray: JSONArray = JSONArray(emailList)
//                for (i in 0 until mJsonArray.length()) {
//                    val mJsonObject: JSONObject = mJsonArray.getJSONObject(i);
//                    val emailAddress: String = mJsonObject.getString("emailAddress");
//                    val alias: String = mJsonObject.getString("alias");
//                    emails.add(Email(emailAddress = emailAddress, alias = alias))
//                }
//            }
//
//
//            screen.commit {
//                Log.d(TAG, "i. Screen update succesful: $it")
//            }
//        }
//
//
//    }
//
//    private fun recordNote() {
//        initFile()
//        capabilitiesState?.let {
//            audioRecorder.startAudioRecording(getFile(), SdlAudioRecorder.AmplifierMode.LiveProcessing, it)
//
//            val initialPrompt = TTSChunk("Recording...", SpeechCapabilities.TEXT)
//
//            val audioPassThru = PerformAudioPassThru()
//                    .setAudioPassThruDisplayText1("Recording...")
//                    .setInitialPrompt(Arrays.asList(initialPrompt))
//                    .setSamplingRate(it.samplingRate)
//                    .setMaxDuration(maxDuration)
//                    .setBitsPerSample(it.bitsPerSample)
//                    .setAudioType(it.audioType)
//                    .setMuteAudio(false)
//            audioPassThru.onRPCResponseListener = object : OnRPCResponseListener() {
//                override fun onResponse(correlationId: Int, response: RPCResponse) {
//                    when (response.resultCode) {
//                        Result.SUCCESS -> {
//                            audioRecorder.finishAudioRecording()
//                            sdlManager?.let {
//                                prepareEmailChoices(it)
//                            }
//                        }
//                        Result.ABORTED -> {
//                            audioRecorder.cancelAudioRecording()
//                            getFile().delete()
//                        }
//                        else -> {
//                            audioRecorder.cancelAudioRecording()
//                            getFile().delete()
//                        }
//                    }
//                }
//            }
//            sdlManager!!.sendRPC(audioPassThru)
//        }
//    }
//
//    private fun initFile(){
//        fileName = String.format("%s-%s-voice", Date().time, userId ?: "no_user_id_found")
//
//        val file = getFile()
//        if(file.exists()){
//            file.delete()
//            file.createNewFile()
//        }
//    }
//
//    private fun getFile(): File = File(applicationContext.applicationInfo.dataDir).let { parentDirectory ->
//        if (!parentDirectory.exists()) {
//            val directoriesWereMade = parentDirectory.mkdirs()
//            Log.d("huerta", "directoriesWereMade : $directoriesWereMade")
//        }
//        File(parentDirectory, "$fileName.wav").apply {
//            Log.d(TAG, "m. requesting a file to use: $this")
//        }
//    }
//
//    private fun prepareEmailChoices(sdlManagerIncoming: SdlManager) {
//        if(emails.isNotEmpty()) {
//            if(emails.size == 1){
//                capabilitiesState?.let {nonNullCapabilities ->
//                    sendToEmail(userId, getFile(), emails[0], nonNullCapabilities, applicationContext, ::onSuccessSendingFile, ::onErrorSendingFile)
//                }
//            } else {
//                val choices = emails.mapIndexed { index, email ->
//                    var value= if (email.alias != "") email.alias else email.emailAddress
//                    val appendDefaultStr = email.emailAddress == emails[0].emailAddress
//                    val cellText = "${index + 1}. $value" + if (appendDefaultStr) getString(R.string.default_email_suffix) else ""
//                    val choicesInVoiceInput = listOf("${index + 1}. $value", value, "${index + 1}")
//                    ChoiceCell(cellText, choicesInVoiceInput, null)
//                }
//                sdlManagerIncoming.screenManager?.preloadChoices(choices, object : CompletionListener {
//                    override fun onComplete(success: Boolean) {
//                        Log.d(TAG, "m. onComplete called")
//                        sdlManager?.screenManager?.let { screenManager ->
//                            val choicesSet = ChoiceSet(
//                                    "Select your e-mail",
//                                    null,
//                                    null,
//                                    "Please say your line number or email address to send your Braintoss",
//                                    null,
//                                    "your line number or email address to send your Braintoss",
//                                    null,
//                                    null,
//                                    choices, object : ChoiceSetSelectionListener {
//                                override fun onChoiceSelected(choiceCell: ChoiceCell?, triggerSource: TriggerSource?, rowIndex: Int) {
//                                    Log.d(TAG, "n onChoiceSelected called")
//                                    if (choiceCell != null) {
//                                        capabilitiesState?.let { nonNullCapabilities ->
//                                            emails.getOrNull(rowIndex)?.let { email ->
//                                                sendToEmail(userId, getFile(), email, nonNullCapabilities, applicationContext, ::onSuccessSendingFile, ::onErrorSendingFile)
//                                            }
//                                        }
//                                    }
//                                }
//
//                                override fun onError(error: String?) {
//                                    Log.e(TAG, "n. onError called Cannot preload email choices: $error")
//                                }
//                            })
//                            choicesSet.timeout = 60
//                            screenManager.presentChoiceSet(choicesSet, InteractionMode.BOTH)
//                        }
//                    }
//                })
//            }
//        } else {
//            Log.d(TAG," XXXXX : no emails found")
//        }
//    }
//}
//
