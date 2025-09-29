//
//  Text.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 25/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

extension Text {
    static func createCancelButton(_ width: CGFloat) -> some View {
        return Text(String("\u{00D7}"))
            .font(.system(size: width * 1.1))
            .fontWeight(.regular)
            .frame(minWidth: 0, idealWidth: 0, maxWidth: width,
                   minHeight: 0, idealHeight: 0, maxHeight: width)
            .offset(x: -(width * 0.01), y: -(width * 0.11))
            .foregroundColor(.black)
            .background(Color.neonCarrot)
            .cornerRadius(width / 2)
    }
}
