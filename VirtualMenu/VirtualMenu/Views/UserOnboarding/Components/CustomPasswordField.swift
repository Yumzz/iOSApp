//
//  CustomPasswordField.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct CustomPasswordField: View {
    
    var strLabel: String
    
    @Binding var password: String
    
    var body: some View {
        VStack (spacing: 0) {

            
            SecureField(strLabel, text: $password)
                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                .imageScale(.small)
                .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .shadow(radius: 4)

        }
    }
}

struct CustomPasswordField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomPasswordField(strLabel: "Password", password: .constant(""))
    }
}
