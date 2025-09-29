//
//  DispatchQueue.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 21/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

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
