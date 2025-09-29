//
//  Done.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct SendingView: View {

    @State private var rotation = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 24)
                ZStack {
                    Image("Braintoss Watch Icon Sending")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.22,
                               height: geometry.size.width * 0.22,
                               alignment: .center)
                        .offset(x: -2, y: 0.5)
                    Image("Braintoss Watch Icon Loading")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4,
                               alignment: .center)
                        .rotationEffect(.degrees(rotation))
                }
                Text("Sending...")
                    .font(.system(size: WKInterfaceDevice.model == .w44 ||
                                        WKInterfaceDevice.model == .w42 ? 12 : 11))
                    .fontWeight(.regular)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 3)
                    .foregroundColor(.white)
            }.onReceive(timer) { _ in
                rotation += 8
            }
        }
    }
}
