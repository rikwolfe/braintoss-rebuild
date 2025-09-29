//
//  WatchModel.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 29/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import WatchKit

enum WatchModel {
    case w38, w40, w42, w44, unknown
}

extension WKInterfaceDevice {
    static var model: WatchModel {
        switch WKInterfaceDevice.current().screenBounds.size {
        case CGSize(width: 136, height: 170):
            return .w38
        case CGSize(width: 162, height: 197):
            return .w40
        case CGSize(width: 156, height: 195):
            return .w42
        case CGSize(width: 184, height: 224):
            return .w44
        default:
            return .unknown
        }
    }
}
