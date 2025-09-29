//
//  EmailList.swift
//  BraintossWatchApp Extension
//
//  Created by Nemanja Crnomut on 07/09/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import SwiftUI

class EmailListViewModel: ObservableObject {
    
    var emails = [String]()
    var onChoosenEmail: ((_ email: String) -> Void)?
}

struct EmailListView: View {

    @Environment(\.presentationMode) var presentation
    @ObservedObject var model = EmailListViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical) {
                    VStack(spacing: 8) {
                        ForEach(self.model.emails, id: \.self) { email in
                            self.createEmailField(email)
                        }
                    }
                }          
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private extension EmailListView {
    
    func createEmailField(_ email: String) -> some View {
        let alias = getAlias(email: email)
        return Text(alias != "" ? alias : email)
            .font(.system(size: 17)).fontWeight(.medium)
            .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity,
                   minHeight: 0, idealHeight: 32, maxHeight: 32, alignment: .leading)
            .padding(.leading, 8)
            .background(Color.sunglow)
            .foregroundColor(.mediumElectricBlue)
            .cornerRadius(8)
            .onTapGesture {
                self.model.onChoosenEmail?(email)
                self.presentation.wrappedValue.dismiss()
            }
    }
    
    func getAlias(email: String) -> String {
        let index =  UserData.emails.firstIndex(of: email)!
        let alias = UserData.aliases[index]
        return alias
    }
}

private enum Constants {
    static let cancelButtonHeightModifier = CGFloat(0.3)
}
