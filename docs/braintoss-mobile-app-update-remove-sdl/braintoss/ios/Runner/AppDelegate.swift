import UIKit
import Flutter
import AVFoundation
import Intents
@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private let sessionHandler = WCSessionHandler()
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ProxyManager.sharedManager.connect()
        setAudioSessionCategory()
        GeneratedPluginRegistrant.register(with: self)
        setupWCSessionHandler()
        setupFlutterChannel()
        registerSiriShortcuts()
  
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if (userActivity.activityType == "com.braintoss.braintoss.openNote")
        {
            FlutterHandler.shared.navigateWithSiri(route: "Note")
            return true
        }
        else if (userActivity.activityType == "com.braintoss.braintoss.openVoice")
        {
            FlutterHandler.shared.navigateWithSiri(route: "Voice")
            return true
        }
        else if (userActivity.activityType == "com.braintoss.braintoss.openPhoto")
        {
            FlutterHandler.shared.navigateWithSiri(route: "Photo")
            return true
        }
        return false
    }
}

private extension AppDelegate {

    func setupFlutterChannel() {
        FlutterHandler.shared.setup(controller: window?.rootViewController as? FlutterViewController)
        FlutterHandler.shared.onUpdateWatchApplicationContext = { [weak self] context in
            self?.sessionHandler.updateApplicationContext(context)
        }
    }
    
    func setupWCSessionHandler() {
        sessionHandler.setup()
        sessionHandler.onFileReadyForUpload = { [weak self] info in
            FlutterHandler.shared.uploadFileWith(info: info)
        }
    }
    
    func setAudioSessionCategory() {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.isOtherAudioPlaying {
            try? audioSession.setCategory(AVAudioSession.Category.ambient, options: .mixWithOthers)
        }
    }
    
    func registerSiriShortcuts() {
        let cases = SiriShortcutType.allCases
        var suggestions: [INShortcut] = []
        for type in cases {

            let activity = NSUserActivity(activityType: type.siriActivityType)
            activity.title = type.siriShortcutTitle
            activity.isEligibleForSearch = true
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(type.siriActivityType)
            activity.becomeCurrent()
            suggestions.append(INShortcut.init(userActivity: activity))
        }
        DispatchQueue.main.async {
            INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        }
    }
}
