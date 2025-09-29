//
//  FlutterHandler.swift
//  Runner
//
//  Created by Maja Djordjevic on 11.5.22..
//

import Foundation
import Flutter
import AVFoundation

class FlutterHandler {

    var onUpdateWatchApplicationContext: ((_ context: [String: Any]) -> Void)?
    
    static let shared = FlutterHandler()
    
    private var appChannel: FlutterMethodChannel?
    func setup(controller: FlutterViewController?) {
        guard let controller = controller else { return }

        appChannel = FlutterMethodChannel(name: Constants.appChannel,
                                          binaryMessenger: controller.binaryMessenger)

        appChannel?.setMethodCallHandler(methodHandler)
    }
    
    func uploadFileWith(info: [String: Any]) {
        appChannel?.invokeMethod(Constants.uploadAudio, arguments: info)
    }

    func navigateWithSiri(route: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.appChannel?.invokeMethod(Constants.navigateWithSiri, arguments: route)
        }
    }
    
    func uploadFileFromCar(info: [String: Any]) {
        appChannel?.invokeMethod("uploadFromCar", arguments: info)
    }
}

private extension FlutterHandler {
    
    var methodHandler: FlutterMethodCallHandler {
        return { [weak self] (call, result) in
            if call.method == Constants.userInfo {
                let info = call.arguments as? [String: Any] ?? [:]
                self?.updateWatchApplicationContext(info: info)
            }
            else if call.method == Constants.isMusicPlaying {
                result(AVAudioSession.sharedInstance().isOtherAudioPlaying)
            }
        }
    }
    
    func updateWatchApplicationContext(info: [String: Any]) {
        guard let emailList = info[Constants.emailList] as? [String],
            let userId = info[Constants.userId] as? String else { return }
        
        let aliasList = info[Constants.aliasList] as? [String]
        
        let context = [Constants.updateContextTrigger: UUID().uuidString,
                       Constants.userId: userId,
                       Constants.emailList: emailList,
                       Constants.aliasList: aliasList] as [String: Any]

        onUpdateWatchApplicationContext?(context)
    }
}
