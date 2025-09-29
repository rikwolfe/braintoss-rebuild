//
//  ProgressBar.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

class ProgressBarViewModel: ObservableObject {
    
    @Published var progressValue: Float = 0
}

struct ProgressBarView: View {
    
    @ObservedObject var model = ProgressBarViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.createProgressRectangle(geometry)
            }
            .cornerRadius(geometry.size.height)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(x: 0)
            .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .clipped()
        }
    }
}

private extension ProgressBarView {
    
    func createProgressRectangle(_ geometry: GeometryProxy) -> some View {
        let height = geometry.size.height
        let width = model.progressValue > 0 ? min(CGFloat(model.progressValue) * geometry.size.width,
                                                  geometry.size.width) : 0
        return Rectangle()
            .cornerRadius(height)
            .frame(width: width + height, height: height)
            .position(x: 0)
            .offset(x: width / 2 - height, y: height / 2)
            .foregroundColor(.neonCarrot)
            .animation(.linear)
    }
}
