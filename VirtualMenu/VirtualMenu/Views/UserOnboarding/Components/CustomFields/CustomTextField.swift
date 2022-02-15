//
//  CustomTextField.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    
    var field: String
    var strLabel: String
    
    @Binding var strField: String
    
    var uiTextAutoCapitalizationType:UITextAutocapitalizationType
    var uiKeyboardType: UIKeyboardType
    
    var body: some View {
        
        VStack (spacing: 0) {
            Text(field)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 55)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 514, weight: .regular, design: .default))
                .foregroundColor(Color("OrangeWhite"))
            TextField(strLabel, text: $strField)
                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                .imageScale(.small)
                .keyboardType(uiKeyboardType)
                .autocapitalization(uiTextAutoCapitalizationType)
                .foregroundColor(Color("PinkishOrange"))
            Divider()
                .frame(width: UIScreen.main.bounds.width/1.2, height: 20, alignment: .leading)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .foregroundColor(Color("Back"))
//                .textFieldStyle(RoundedBorderTextFieldStyle())
                
//                .shadow(radius: 4)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField(field: "Field", strLabel: "Label", strField: .constant(""), uiTextAutoCapitalizationType: UITextAutocapitalizationType.none, uiKeyboardType: .alphabet)
    }
}
