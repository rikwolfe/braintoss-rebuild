//
//  Done.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct FailedView: View {

    static func sendingFailedView() -> FailedView {
        return FailedView(upperText: "Sending failed but your message is saved.",
                          lowerText: "Please open Braintoss on\nyour iPhone to resend.")
    }

    static func recordingFailedView() -> FailedView {
        return FailedView(upperText: "An error occured while recording the message.",
                          lowerText: "Please try again.")
    }

    @State var upperText: String
    @State var lowerText: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 24)
                Image("Braintoss Watch Icon Failed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                    .position(x: geometry.size.width / 2, y: geometry.size.width * 0.35 / 2)
                createTextView(upperText)
                Spacer()
                createTextView(lowerText)
            }
        }
    }
    
    private func createTextView(_ text: String) -> some View {
        return Text(text)
            .font(.system(size: WKInterfaceDevice.model == .w44 ||
                                WKInterfaceDevice.model == .w42 ? 12 : 11))
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
    }
}
