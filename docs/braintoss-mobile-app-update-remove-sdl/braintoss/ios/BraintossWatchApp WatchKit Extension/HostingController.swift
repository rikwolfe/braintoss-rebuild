//
//  HostingController.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 31/08/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import WatchConnectivity

class HostingController: WKHostingController<ContentView> {

    override var body: ContentView {
        return contentView
    }
    
    private var contentView = ContentView()
    private let recordingController = RecordingController()
    private var fileURL: URL?
    private var email: String?
    private var tokens = [NSKeyValueObservation]()
    private var nextState = ContentViewState.unknown

    override init() {
        super.init()
        setupContentViewCallbacks()
        setupRecordingController()
        setupAppCallbacks()
    }
    
    deinit {
        tokens.forEach { $0.invalidate() }
    }
}

private extension HostingController {
    
    func setupContentViewCallbacks() {
        contentView.onStartRecordingClicked = { [weak self] in
            self?.contentView.model.shouldShowStartButton = false
            self?.recordingController.record()
        }

        contentView.onSendRecordingClicked = { [weak self] in
            self?.recordingController.stop()
        }

        contentView.onCancelRecordingClicked = { [weak self] in
            guard let self = self else { return }
            self.recordingController.cancel()
            self.resetRecordingScreen()
        }

        contentView.onChoosenEmail = { [weak self] email in
            guard let self = self else { return }
            self.email = email
            self.transferAudioRecording()
        }
    }
    
    func setupRecordingController() {
        recordingController.recordingLength = 30
        recordingController.progressUpdateFrequency = 0.1

        recordingController.onRecordingProgressUpdated = { [weak self] progress in
            self?.contentView.model.recordingProgress = Float(progress)
        }
        
        recordingController.onDidFinishRecording = { [weak self] fileURL in
            guard let fileURL = fileURL else {
                self?.resetRecordingScreen()
                return
            }
            self?.fileURL = URL(fileURLWithPath: fileURL.absoluteString)
            self?.checkEmailList()
        }
    }
    
    func setupAppCallbacks() {
        tokens.append(
            ExtensionState.shared
                .observe(\.didBecomeActive, options: .new) { [weak self] _,_ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self?.setWaitingScreen(visible: UserData.emails.isEmpty)
                    }
                })
        
        tokens.append(
            ExtensionState.shared
                .observe(\.willResignActive, options: .new) { [weak self] _,_ in
                    self?.contentView.model.state = .recording
            })
        
        tokens.append(
            ExtensionState.shared
                .observe(\.didReceiveAppContext, options: .new) { [weak self] _,_ in
                    guard let self = self else { return }
                    if !(self.contentView.model.state == .waiting ||
                            self.contentView.model.state == .unknown)  { return }
                    self.setWaitingScreen(visible: false)
            })

        tokens.append(
            ExtensionState.shared
                .observe(\.didFinishFileTransfer, options: .new) { [weak self] _,_ in
                    self?.applyNextState()
            })
    }

    func checkEmailList() {
        if UserData.emails.count > 1 {
            contentView.model.state = .emails
        }
        else {
            email = UserData.emails.first
            transferAudioRecording()
        }
    }
    
    func transferAudioRecording() {
        guard let fileUrl = fileURL, let email = email else { return }

        var metadata: [String: Any] = [Constants.email: email,
                                       Constants.watchOSVersion: WKInterfaceDevice.current().systemVersion]
        
        contentView.model.state = .sending

        let transferBlock: (_ fileWasUploaded: Bool,
                            _ skipNotification: Bool) -> Void =
            { [weak self] fileWasUploaded, skipNotification in
                metadata[Constants.fileUploadedByWatch] = fileWasUploaded
                metadata[GeneralConstants.skipNotification] = skipNotification
                WCSession.default.transferFile(fileUrl, metadata: metadata)
                if skipNotification {
                    self?.applyNextState()
                }
            }

        // phone app presence check
        WCSession.default.sendMessage([:]) { [weak self] (reply) in
            self?.nextState = .done
            transferBlock(false, false)
        } errorHandler: { [weak self] (error) in
            if !ExtensionState.shared.hasInternetConnection {
                self?.nextState = .sendingFailed
                transferBlock(false, true)
            }
            else {
                self?.uploadFile() { [weak self] success, status in
                    self?.nextState = success ? .done : .sendingFailed
                    metadata[Constants.watchHttpRequestStatus] = status
                    transferBlock(success, true)
                }
            }
        }
    }
    
    func resetRecordingScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentView.model.recordingProgress = 0
            self.contentView.model.shouldShowStartButton = true
        }
    }
    
    func applyNextState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentView.model.state = self.nextState
            self.backToRecordingScreen()
        }
    }

    func backToRecordingScreen() {
        resetRecordingScreen()
        let timeout = nextState == .done ? 1.3 : 5
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.contentView.model.state = .recording
        }
    }

    func setWaitingScreen(visible: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.model.state = visible ? .waiting : .recording
        }
    }
}

#warning("All of this should be moved into a local pod and then used by both iOS app and watchOS app")
//TODO: extract the code for uploading the file from SDLProxy.swift and HostingController.swift into a local pod
private extension HostingController {
    
    func uploadFile(_ completion: @escaping (_ success: Bool, _ status: String) -> Void) {
        
        let failed = {
            completion(false, Constants.statusQueuedFailed)
        }
        
        guard let fileUrl = fileURL, let email = email else {
            failed()
            return
        }

        guard let audioDataToUpload = try? Data(contentsOf: fileUrl) else {
            failed()
            return
        }

        guard let emailParam = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let userIdParam = UserData.userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let versionParam = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let buildNumberParam = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        else {
            failed()
            return
        }

        let currentLanguageParam = ""
        let messageIdParam = UUID().uuidString
        let systemName = WKInterfaceDevice.current().systemName
        let systemVersion = WKInterfaceDevice.current().systemVersion
        let deviceModelName = ""

        let urlString = "https://api.braintoss.com/?email=\(emailParam)&uid=\(userIdParam)&lang=\(currentLanguageParam)&d=\(deviceModelName)-watch&mid=\(messageIdParam)&os=\(systemName)-\(systemVersion)&v=\(versionParam).\(buildNumberParam)&rate=128&key=PFGBNakkoyJ7Ry9N3E3xgnCYbLPxFK8K"

        let boundary = "SDLProxy-\(UUID().uuidString)"

        guard let url = URL(string: urlString) else {
            failed()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setMultipartFormDataHTTPBody(boundary: boundary,
                                             data: audioDataToUpload,
                                             mimeType: "audio/x-m4a",
                                             filename: fileUrl.lastPathComponent)

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let uploadTask = session.dataTask(with: request) { (data, response, error) in
            var status = Constants.statusQueuedFailed
            if let data = data,
               let body = String(data: data, encoding: .utf8),
               body.contains("100") {
                status = Constants.statusSentEnd
            }
            completion(error == nil, status)
        }
        uploadTask.resume()
    }
}

extension HostingController: URLSessionDelegate {
    
    #warning("Temporarely disabling auth challenge because of invalid certificate error coming from the server")
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
}

private enum Constants {
    static let email = "Email"
    static let watchOSVersion = "WatchOSVersion"
    static let fileUploadedByWatch = "FileUploadedByWatch"
    static let watchHttpRequestStatus = "WatchHttpRequestStatus"
    static let statusSentEnd = "STATUS_SENT_END"
    static let statusQueuedFailed = "QUEUED_FAILED"
}
