//
//  AudioRecorder.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import AVFoundation

class RecordingController: NSObject {

    var recordingLength: TimeInterval = 0
    var progressUpdateFrequency: TimeInterval = 0
    var onRecordingProgressUpdated: ((_ progress: TimeInterval) -> Void)?
    var onDidFinishRecording: ((_ fileURL: URL?) -> Void)?
    
    private var recorder: AVAudioRecorder?
    private var isRecording = false
    private var timer: Timer?
    private var progress: TimeInterval = 0.03
    private var shouldCancelRecording = false
    
    func record() {
        DispatchQueue.once {
            #warning("find a better way to do this")
            // problem: first recording after app is activated records sucessfully,
            // has the correct size but audio can't be reproduced
            fakeRecording()
        }
        guard !isRecording else { return }
        isRecording = true
        shouldCancelRecording = false
        doRecording()
    }
    
    func cancel() {
        guard let recoder = recorder else { return }
        if recoder.isRecording {
            shouldCancelRecording = true
            stop()
        }
        else {
            removeRecording()
        }
    }
    
    func stop() {
        timer?.invalidate()
        recorder?.stop()
        recorder = nil
    }
}

private extension RecordingController {

    func fakeRecording() {
        setupAudioRecorder()
        recorder?.record()
        recorder?.stop()
    }
    
    func doRecording() {
        setupAudioRecorder()
        recorder?.prepareToRecord()
        recorder?.delegate = self
        recorder?.record()
        startTimer()
    }
    
    func setupAudioRecorder() {
        let interval = Int(Date().timeIntervalSince1970)
        let userId = UserData.userId
        let fileName = "\(interval)-\(userId)-voice.m4a"
        let directory = getDirectory()
        let filePathString = "\(directory)/\(fileName)"
        
        guard let filePath = URL(string: filePathString) else { return }

        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 2,
                        AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue]

        recorder = try? AVAudioRecorder(url: filePath, settings: settings)
    }

    func getDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func startTimer() {
        progress = 0.03
        let progressIncrease = progressUpdateFrequency / recordingLength
        timer = Timer.scheduledTimer(withTimeInterval: progressUpdateFrequency,
                                     repeats: true) { [weak self] _ in
                                        self?.updateProgress(progressIncrease)
        }
    }
    
    func updateProgress(_ progressIncrease: TimeInterval) {
        progress += progressIncrease
        onRecordingProgressUpdated?(progress)
        if progress >= 1 { stop() }
    }
    
    func removeRecording() {
        guard let url = recorder?.url else { return }
        try? FileManager.default.removeItem(at: url)
    }
}

extension RecordingController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        if shouldCancelRecording {
            removeRecording()
            return
        }
        onDidFinishRecording?(flag ? recorder.url : nil)
    }
}
