//
//  ContentView.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 31/08/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation
import WatchConnectivity

enum ContentViewState {
    case waiting,
         recording,
         emails,
         sending,
         done,
         sendingFailed,
         recordingFailed,
         unknown
}

class ContentViewModel: ObservableObject {
    
    @Published var state: ContentViewState = .unknown {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.shouldShowTransferComplete = self.state == .done
            }
        }
    }
    @Published var shouldShowStartButton = true
    @Published var recordingProgress: Float = 0
    @Published fileprivate var shouldShowTransferComplete = false
}

struct ContentView: View {
    
    var onStartRecordingClicked: (() -> Void)?
    var onSendRecordingClicked: (() -> Void)?
    var onCancelRecordingClicked: (() -> Void)?
    var onChoosenEmail: ((_ email: String) -> Void)?

    @ObservedObject var model = ContentViewModel()

    var body: some View {
        GeometryReader { geometry in
            switch model.state {
            case .waiting:
                WaitingView()
            case .recording:
                self.createRecordingView(geometry)
            case .emails:
                self.createEmailList()
            case .sending:
                SendingView()
            case .sendingFailed:
                FailedView.sendingFailedView().onTapGesture {
                    self.model.state = .recording
                }
            case .recordingFailed:
                FailedView.recordingFailedView().onTapGesture {
                    self.model.state = .recording
                }
            default:
                EmptyView()
            }
            self.createNavigationLinks()
        }
    }
}

fileprivate var contentHeightRatio: CGFloat = 0

private extension ContentView {
    
    func createRecordingView(_ geometry: GeometryProxy) -> some View {
        contentHeightRatio = geometry.size.height / WKInterfaceDevice.current().screenBounds.height
        return VStack {
            self.createMicIcon(geometry)
            Spacer()
            self.createProgressBar(geometry)
            Spacer()
            if self.model.shouldShowStartButton {
                self.createStartButton(geometry)
            }
            else {
                self.createButtonStack(geometry)
            }
        }
    }
    
    func createMicIcon(_ geometry: GeometryProxy) -> some View {
        let height = Constants.micIconHeight
        return Image("Voice_Microphone_Icon")
            .resizable()
            .scaledToFit()
            .frame(height: height)
    }

    func createProgressBar(_ geometry: GeometryProxy) -> some View {
        let height = Constants.progressBarHeight
        let progressBar = ProgressBarView()
        progressBar.model.progressValue = model.recordingProgress
        return progressBar
            .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity,
                   minHeight: 0, idealHeight: height, maxHeight: height)
    }

    func createButtonStack(_ geometry: GeometryProxy) -> some View {
        let height = Constants.startButtonHeight
        return HStack {
            self.createCancelButton(height)
            Spacer(minLength: 16)
            self.createSendButton(height)
        }
        .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity,
               minHeight: 0, idealHeight: 0, maxHeight: height)
    }

    func createSendButton(_ height: CGFloat) -> some View {
        return Image("Photo_Note_Send_Button")
            .scaleEffect(0.6)
            .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity,
                   minHeight: 0, idealHeight: 0, maxHeight: .infinity)
            .background(Color.sunglow)
            .cornerRadius(height / 2)
            .onTapGesture {
                self.onSendRecordingClicked?()
            }
    }

    func createCancelButton(_ width: CGFloat) -> some View {
        return Text.createCancelButton(width)
            .onTapGesture {
                self.onCancelRecordingClicked?()
            }
    }

    func createStartButton(_ geometry: GeometryProxy) -> some View {
        let height = Constants.startButtonHeight
        return Button(action: {
                self.onStartRecordingClicked?()
            }) {
                Text("Start").font(.system(size: 22)).fontWeight(.black)
            }
            .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity,
                   minHeight: 0, idealHeight: 0, maxHeight: height)
            .foregroundColor(.mediumElectricBlue)
            .background(Color.sunglow)
            .cornerRadius(height / 2)
    }
    
    func createEmailList() -> some View {
        let emailListView = EmailListView()
        emailListView.model.emails = UserData.emails
        emailListView.model.onChoosenEmail = self.onChoosenEmail
        return emailListView
    }
    
    func createNavigationLinks() -> some View {
        return NavigationLink(destination: DoneView(),
                           isActive: self.$model.shouldShowTransferComplete) {
                Text("")
        }.frame(width: 0, height: 0)
    }
}

private enum Constants {
    static var micIconHeight: CGFloat {
        var height: CGFloat = 0
        switch WKInterfaceDevice.model {
        case .w38:
            height = 128
        case .w40, .w42:
            height = 164
        case .w44:
            height = 196
        default:
            height = 128
        }
        return (height / WKInterfaceDevice.current().screenScale) * contentHeightRatio
    }

    static var progressBarHeight: CGFloat {
        var height: CGFloat = 0
        switch WKInterfaceDevice.model {
        case .w38:
            height = 17
        case .w40, .w42:
            height = 20
        case .w44:
            height = 22
        default:
            height = 17
        }
        return (height / WKInterfaceDevice.current().screenScale)
    }
    
    static var startButtonHeight: CGFloat {
        var height: CGFloat = 0
        switch WKInterfaceDevice.model {
        case .w38:
            height = 76
        case .w40, .w42:
            height = 90
        case .w44:
            height = 94
        default:
            height = 76
        }
        return (height / WKInterfaceDevice.current().screenScale)
    }
}
