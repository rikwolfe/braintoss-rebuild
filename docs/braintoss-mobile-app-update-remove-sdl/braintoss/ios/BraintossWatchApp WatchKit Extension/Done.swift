//
//  Done.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

struct DoneView: View {

    @Environment(\.presentationMode) var presentation

    var body: some View {
        GeometryReader { geometry in
            Image("Voice_Check_Icon")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onTapGesture {
                    self.presentation.wrappedValue.dismiss()
                }
        }.navigationBarBackButtonHidden(true)
    }
}
