import SmartDeviceLink
import Foundation
import Flutter
import AVFoundation
import CoreAudio

private let kRecordingMaximumDuration: UInt16 = .max
private let kRecordingFileNameSuffix: String = "voice.m4a"
private let kRecordingFormat: AudioFormatID = kAudioFormatMPEG4AAC

class ProxyManager: NSObject, SDLChoiceSetDelegate {
    private let appName = "Braintoss"
    private let appId = "c575e2ff-dc9d-4f2c-a918-19aabb2a3c99"
    
    fileprivate var sdlManager: SDLManager!

    static let sharedManager = ProxyManager()
    private var firstHMILevelState: SDLHMILevel

    private var emailList = [Email]()

    private var email: String {
        return UserDefaults.standard.object(forKey: "flutter.emailList") as? String ?? ""
    }
    
    private var defaultEmail: String {
        return UserDefaults.standard.object(forKey: "flutter.email") as? String ?? ""
    }

    private var currentLanguage: [String] {
        return UserDefaults.standard.object(forKey: "flutter.speechToTextLanguage") as? [String] ?? []
    }

    private var emailsChoiceSet: SDLChoiceSet?
    private let defaultEmailString = " (default)"

    private var audioData: Data?
    private var audioFileURL: URL?
    private var messageId: String?
    private var userId: String = UUID().uuidString

    private var recordNoteDidEnd: SDLResponseHandler!

    private override init() {
        firstHMILevelState = .none
        super.init()

        // Used for USB Connection
       let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)
        
        // Used TCP/IP Connection for emulator
//          let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "m.sdl.tools", port: 15173)

        lifecycleConfiguration.shortAppName = "Braintoss"
        lifecycleConfiguration.appIcon = SDLArtwork(image: #imageLiteral(resourceName: "SDL_appIcon"), persistent: true, as: .PNG)

        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled(), logging: .default(), fileManager: .default(), encryption: nil)

        sdlManager = SDLManager(configuration: configuration, delegate: self)
    }

    func connect() {
        sdlManager.start { (success, error) in
            if success {
                print("App is connected!")
            }
        }
    }
    
    let jsonDecoder = JSONDecoder()
    
    public func JSONDecode(JSONData:String)-> [Email] {
        do {
            let email = try jsonDecoder.decode([Email].self, from: Data(JSONData.utf8))
            return email
        } catch {
           print(error.localizedDescription)
        }
        
        return []
    }

    func setMainScreen() {
        
        sdlManager.screenManager.beginUpdates()
        
        if(defaultEmail.isEmpty){
            sdlManager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .graphicWithText))
            sdlManager.screenManager.textField1 = "Please, enter the email address in the Braintoss app."
            sdlManager.screenManager.primaryGraphic = SDLArtwork(image: #imageLiteral(resourceName: "SDL_homeScreen"), persistent: true, as: .PNG)
        } else {
            
            let jsonData = defaultEmail.data(using: .utf8)!
            let defEmail: Email = try! jsonDecoder.decode(Email.self, from: jsonData)
            var emails = JSONDecode(JSONData: email)
            emails.insert(defEmail, at: 0)
            emails.forEach{ email in
                self.emailList.append(email)
            }
            
            sdlManager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .graphicWithTiles))
            sdlManager.screenManager.primaryGraphic = SDLArtwork(image: #imageLiteral(resourceName: "SDL_homeScreen"), persistent: true, as: .PNG)
            let voiceButtonState = SDLSoftButtonState(stateName: LocalizationStrings.buttonStateName, text: LocalizationStrings.voiceText, image: #imageLiteral(resourceName: "SDL_voiceIcon"))
            let voiceButton = SDLSoftButtonObject(name: LocalizationStrings.buttonVoice, state: voiceButtonState)
            { [weak self] (isPressed, event) in
                guard isPressed != nil else { return }
                self?.recordNote()
            }
            sdlManager.screenManager.softButtonObjects = [voiceButton]
            
            sdlManager.screenManager.menu = [SDLMenuCell(title: LocalizationStrings.voiceText, icon: SDLArtwork(image: #imageLiteral(resourceName: "SDL_menuIcon"), name: LocalizationStrings.voiceText, persistent: true, as: .PNG), voiceCommands: nil)
            { [weak self] (triggerSource: SDLTriggerSource) in
                self?.recordNote()
            }]
            
        }
        
        if sdlManager.systemCapabilityManager.vrCapability {
            sdlManager.screenManager.voiceCommands = [SDLVoiceCommand(voiceCommands: [LocalizationStrings.takeNote], handler: { [weak self] in
                self?.recordNote()
            })]
        }
        
        prepareEmailChoices()
        sdlManager.screenManager.endUpdates()
    }
        
        private func prepareEmailChoices() {
            if emailList.count > 1 {
                SDLChoiceSet.defaultTimeout = 60.0
                let choices: [SDLChoiceCell] = emailList.enumerated().map { (index, email) in
                    let value = email.alias != "" ? email.alias : email.emailAddress
                    return SDLChoiceCell(text: index == 0 ? "\(index + 1). \(value)\(defaultEmailString)" : "\(index + 1). \(value)", artwork: nil, voiceCommands: ["\(index + 1). \(value)", value, "\(index + 1)"])
                }
                
                sdlManager.screenManager.preloadChoices(choices, withCompletionHandler: nil)
                emailsChoiceSet = SDLChoiceSet(title: LocalizationStrings.selectEmail, delegate: self, layout: SDLChoiceSetLayout.list, timeout: 60.0, initialPromptString: LocalizationStrings.initialPromptChoiceSet, timeoutPromptString: nil, helpPromptString: LocalizationStrings.helpPromptChoiceSet, vrHelpList: nil, choices: choices)
            }
        }
        
        private func recordNote() {
            
            prepareEmailChoices()
            
            audioData = Data()
            
            guard let audioPassThruCapabilities = sdlManager.systemCapabilityManager.audioPassThruCapabilities?.first else {
                return
            }
            
            if recordNoteDidEnd == nil {
                
                recordNoteDidEnd = { [weak self] (request, response, error) in
                    if error != nil {
                        return
                    }
                    
                    guard let passThruResponse = response as? SDLPerformAudioPassThruResponse else {
                        return
                    }
                    
                    guard passThruResponse.success.boolValue else {
                        return
                    }
                    
                    do {
                        try self?.saveAudioData()
                    }
                    catch {
                        self?.showAlert("\(LocalizationStrings.error) \(error)", speach: LocalizationStrings.couldNotSaveNote)
                    }
                }
            }
            
            let audioPassThruRequest = SDLPerformAudioPassThru(initialPrompt: LocalizationStrings.recording, audioPassThruDisplayText1: LocalizationStrings.recordingString, audioPassThruDisplayText2: nil, samplingRate: audioPassThruCapabilities.samplingRate, bitsPerSample: audioPassThruCapabilities.bitsPerSample, audioType: audioPassThruCapabilities.audioType, maxDuration: UInt32(kRecordingMaximumDuration), muteAudio: true, audioDataHandler: { [weak self] (newData) in
                guard let data = newData else { return }
                
                self?.audioData?.append(data)
            })
            
            sdlManager.send(request: audioPassThruRequest, responseHandler: recordNoteDidEnd)
        }
        
        private func saveAudioData() throws {
            
            guard let data = audioData, data.count > 0 else { return }
            
            guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 16000, channels: 1, interleaved: false) else { return }
            let numFrames = UInt32(data.count) / (audioFormat.streamDescription.pointee.mBytesPerFrame)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: numFrames) else  { return }
            buffer.frameLength = numFrames
            let bufferChannels = buffer.int16ChannelData!
            _ = data.copyBytes(to: UnsafeMutableBufferPointer(start: bufferChannels[0], count: data.count))
            
            // Convert to PCM Float 32 to amplify
            guard let floatAudioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: 1, interleaved: false) else { return }
            guard let floatBuffer = AVAudioPCMBuffer(pcmFormat: floatAudioFormat, frameCapacity: numFrames) else { return }
            floatBuffer.frameLength = numFrames
            let convertor = AVAudioConverter(from: audioFormat, to: floatAudioFormat)
            try convertor?.convert(to: floatBuffer, from: buffer)
            
            // Amplify Float 32 buffer
            let finalFloatBuffer = try amplifyBuffer(buffer: floatBuffer, channelCount: Int(floatAudioFormat.channelCount), frameLength: Int(floatBuffer.frameLength), stride: floatBuffer.stride)
            
            guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
            }
            
            let fileName = "\(Date().millisecondsSince1970)-\(userId)-\(kRecordingFileNameSuffix)"
          
            audioFileURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(fileName)

            let audioFile = try AVAudioFile(forWriting: audioFileURL!, settings: [AVFormatIDKey: kRecordingFormat, AVNumberOfChannelsKey: floatAudioFormat.channelCount, AVSampleRateKey: floatAudioFormat.sampleRate], commonFormat: floatAudioFormat.commonFormat, interleaved: floatAudioFormat.isInterleaved)
         
            try audioFile.write(from: finalFloatBuffer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.insertAndUpload()
            }
        }
        
        private func amplifyBuffer(buffer: AVAudioPCMBuffer, channelCount: Int, frameLength: Int, stride: Int) throws -> AVAudioPCMBuffer {
            
            guard let pcmFloatChannelData = buffer.floatChannelData else {
                throw SDLProxyError.couldNotNormalizeAudio
            }
            
            var channelData = Array(repeating: [Float](repeating: 0, count: frameLength), count: channelCount)
            
            for channel in 0..<channelCount {
                for sampleIndex in 0..<frameLength {
                    channelData[channel][sampleIndex] = pcmFloatChannelData[channel][sampleIndex * stride]
                }
            }
            
            var maxLev: Float = 0

            for c in 0..<Int(channelData.count) {
                let floats = UnsafeBufferPointer(start: buffer.floatChannelData?[c], count: Int(buffer.frameLength))
                let cmax = floats.max()
                let cmin = floats.min()

                // positive max
                maxLev = max(cmax ?? maxLev, maxLev)
                // negative max
                maxLev = -min(abs(cmin ?? -maxLev), -maxLev)
            }

            if maxLev == 0 {
                maxLev = Float.leastNormalMagnitude
            } else {
                maxLev = 10 * log10(maxLev)
            }
            
            let newMaxLev: Float = 15.0
            let gainFactor = Float( pow(10.0, newMaxLev / 20.0) / pow(10.0, maxLev / 20.0))
            
            var newArrays: [[Float]] = []
            for array in channelData {
                let newArray = array.map { $0 * gainFactor }
                newArrays.append(newArray)
            }

            for channel in 0..<newArrays.count {
                let channelNData = buffer.floatChannelData?[channel]
                for f in 0..<Int(buffer.frameCapacity) {
                    channelNData?[f] = newArrays[channel][f]
                }
            }
            
            return buffer
        }
        
        private func insertAndUpload() {
            messageId = UUID().uuidString
            
            guard let emailsChoiceSet = emailsChoiceSet else {
                uploadAudio(for: emailList.first)
                return
            }
            
            sdlManager.screenManager.present(emailsChoiceSet, mode: .both)
        }
                
        func choiceSet(_ choiceSet: SDLChoiceSet, didSelectChoice choice: SDLChoiceCell, withSource source: SDLTriggerSource, atRowIndex rowIndex: UInt) {
            if(emailList.indices.contains(Int(rowIndex))) {
                let email = emailList[Int(rowIndex)]
                uploadAudio(for: email)
            }
        }
        
        func choiceSet(_ choiceSet: SDLChoiceSet, didReceiveError error: Error) {
            print("Error while choosing email. Aborting!")
        }
        
        private func uploadAudio(for email: Email?) {
            guard let audioFileURL = audioFileURL, let email = email, let messageId = messageId else {
                showAlert(LocalizationStrings.noEmailPresent, speach: LocalizationStrings.noEmailPresentSpeach)
                return
            }
            
            guard let audioDataToUpload = try? Data(contentsOf: audioFileURL) else {
                showAlert(LocalizationStrings.fileCouldNotBeRead, speach: LocalizationStrings.fileCouldNotBeReadString)
                return
            }
            
            guard let emailParam = email.emailAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let userIdParam = userId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let currentLanguageParam = currentLanguage[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let messageIdParam = messageId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let systemName = UIDevice.current.systemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let systemVersion = UIDevice.current.systemVersion.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let versionParam = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                let buildNumberParam = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
                return
            }
            
            let info = ["messageId":messageIdParam, "emailParam":emailParam, "fileURL":audioFileURL.path] as [String : Any];
            
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine) 
            let deviceModelName = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
                        
            let urlString = "https://api.braintoss.com/?email=\(emailParam)&uid=\(userIdParam)&lang=\(currentLanguageParam)&d=\(deviceModelName)-ford&mid=\(messageIdParam)&os=\(systemName)-\(systemVersion)&v=\(versionParam).\(buildNumberParam)&rate=128&key=PFGBNakkoyJ7Ry9N3E3xgnCYbLPxFK8K"
            
            let boundary = "SDLProxy-\(UUID().uuidString)"
            
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setMultipartFormDataHTTPBody(boundary: boundary, data: audioDataToUpload, mimeType: "audio/x-m4a", filename: audioFileURL.lastPathComponent)
            
            let uploadTask = URLSession.shared.dataTask(with: request) { [unowned self] (data, response, error) in
                guard error == nil else {
                    self.showAlert(LocalizationStrings.CouldNotUploadNote, speach: LocalizationStrings.CouldNotUploadNoteSpeach)
                    return
                }
                FlutterHandler.shared.uploadFileFromCar(info: info);
                let value = email.alias != "" ? email.alias : email.emailAddress
                self.showAlert("\(LocalizationStrings.sendToEmail) \(value).", speach: LocalizationStrings.messageSent)
            }
            uploadTask.resume()
        }
        
        private func showAlert(_ text: String, speach: String) {
            sdlManager.send(SDLAlert(alertText: text, softButtons: nil, playTone: true, ttsChunks: [SDLTTSChunk(text: speach, type: .text)], alertIcon: nil, cancelID: 0))
        }    
    }

    extension ProxyManager: SDLManagerDelegate {
        
        func managerDidDisconnect() {
               print("Manager disconnected!")
           }

           func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
               if newLevel != .none && firstHMILevelState == .none {
                   firstHMILevelState = newLevel
                   setMainScreen()
               }
           }

           func didReceiveSystemInfo(_ systemInfo: SDLSystemInfo) -> Bool {
               print("Connected to system: \(systemInfo)")
               return true
           }
    }

    extension Date {
        var millisecondsSince1970: Int64 {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }
    }

    extension URLRequest {
        mutating func setMultipartFormDataHTTPBody(parameters: [String: String]? = nil,
                                          boundary: String,
                                          data: Data,
                                          mimeType: String,
                                          filename: String) {
            let body = NSMutableData()

            let boundaryPrefix = "--\(boundary)\r\n"

            for (key, value) in (parameters ?? [:]) {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }

            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))

            httpBody = body as Data
        }
    }

    extension NSMutableData {
        func appendString(_ string: String) {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
            append(data!)
        }

    }

    enum SDLProxyError: Swift.Error {  
        case couldNotNormalizeAudio
        
    }

