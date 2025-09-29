//
//  WCSessionHandler.swift
//  Runner
//
//  Created by Nemanja Crnomut on 21/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import WatchConnectivity

class WCSessionHandler: NSObject {
    
    var onFileReadyForUpload: ((_ info: [String: Any]) -> Void)?
    
    func setup() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    func updateApplicationContext(_ context: [String: Any]) {
        try? WCSession.default.updateApplicationContext(context)
    }
}

extension WCSessionHandler: WCSessionDelegate {

    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        guard let email = file.metadata?[Constants.email] as? String else { return }
        let destination = moveWCSessionFile(file)
        let watchOSVersion = file.metadata?[Constants.watchOSVersion] as? String ?? ""
        let fileUploadedByWatch = file.metadata?[Constants.fileUploadedByWatch] as? Bool ?? false
        let watchHttpRequestStatus = file.metadata?[Constants.watchHttpRequestStatus] as? String ?? ""
        let uploadInfo = [Constants.email: email,
                          Constants.fileURL: destination,
                          Constants.watchOSVersion: watchOSVersion,
                          Constants.fileUploadedByWatch: fileUploadedByWatch,
                          Constants.watchHttpRequestStatus: watchHttpRequestStatus] as [String : Any]
        onFileReadyForUpload?(uploadInfo)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {
        replyHandler([:])
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}
}

private extension WCSessionHandler {
    
    func moveWCSessionFile(_ file: WCSessionFile) -> String {
        let source = file.fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")
        let destination = "\(getDirectory())/\(file.fileURL.lastPathComponent)"
        do {
            try FileManager.default.moveItem(atPath: source, toPath: destination)
        }
        catch {
            print(error.localizedDescription)
        }
        return destination
    }
    
    func getDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}
