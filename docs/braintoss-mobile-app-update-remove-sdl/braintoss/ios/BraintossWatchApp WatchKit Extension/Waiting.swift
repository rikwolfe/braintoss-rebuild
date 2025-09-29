//
//  Done.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct WaitingView: View {

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 16)
                Image("Braintoss Watch Icon Retreiving")
                    .resizable()
                    .scaledToFit()
                    .padding([.horizontal])
                Spacer(minLength: 10)
                Text("Please open Braintoss on your iPhone to retrieve the necessary app data.")
                    .font(.system(size: WKInterfaceDevice.model == .w44 ||
                                        WKInterfaceDevice.model == .w42 ? 12 : 11))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding([.horizontal])
            }
        }
    }
}
