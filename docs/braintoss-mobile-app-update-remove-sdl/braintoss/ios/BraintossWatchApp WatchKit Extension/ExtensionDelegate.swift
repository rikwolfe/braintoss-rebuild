//
//  ExtensionDelegate.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 31/08/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WatchKit
import SwiftUI
import WatchConnectivity
import Network

class ExtensionState: NSObject {

    static let shared = ExtensionState()
    private let monitor = NWPathMonitor()
    
    private override init() { super.init() }
    
    @objc dynamic var didBecomeActive = false
    @objc dynamic var willResignActive = false
    @objc dynamic var didReceiveAppContext = false
    @objc dynamic var didFinishFileTransfer = false
    var hasInternetConnection: Bool {
        return monitor.currentPath.status != .requiresConnection
    }

    fileprivate func setupNetworkMonitor() {
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        ExtensionState.shared.setupNetworkMonitor()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        setupWCSession()
        ExtensionState.shared.didBecomeActive = true
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        ExtensionState.shared.willResignActive = true
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

extension ExtensionDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let userId = applicationContext[DataConstants.userId] as? String,
            let emails = applicationContext[DataConstants.emailList] as? [String] else { return }
        
        let aliases = applicationContext[DataConstants.aliasList] as? [String]
        
        UserDefaults.standard.set(userId, forKey: DataConstants.userId)
        UserDefaults.standard.set(emails, forKey: DataConstants.emailList)
        UserDefaults.standard.set(aliases, forKey: DataConstants.aliasList)
        ExtensionState.shared.didReceiveAppContext = true
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        if error == nil {
            try? FileManager.default.removeItem(at: fileTransfer.file.fileURL)
        }
        if fileTransfer.file.metadata?[GeneralConstants.skipNotification] as? Bool ?? true {
            return
        }
        ExtensionState.shared.didFinishFileTransfer = true
    }
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
}

private extension ExtensionDelegate {
    
    func setupWCSession() {
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
}
