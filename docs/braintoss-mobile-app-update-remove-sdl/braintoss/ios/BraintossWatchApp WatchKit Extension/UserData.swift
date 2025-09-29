//
//  UserData.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 20/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

struct UserData {

    static var userId: String {
        return UserDefaults.standard
            .object(forKey: DataConstants.userId) as? String ?? UUID().uuidString
    }

    static var emails: [String] {
        return UserDefaults.standard
            .object(forKey: DataConstants.emailList) as? [String] ?? []
    }

    static var aliases: [String] {
        return UserDefaults.standard
            .object(forKey: DataConstants.aliasList) as? [String] ?? []
    }
}
