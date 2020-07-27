//
//  CustomTextField.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    
    var strLabel: String
    
    @Binding var strField: String
    
    var uiTextAutoCapitalizationType:UITextAutocapitalizationType
    var uiKeyboardType: UIKeyboardType
    
    var body: some View {
        VStack (spacing: 0) {
            Text(strLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
            
            TextField("", text: $strField)
                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                .imageScale(.small)
                .keyboardType(uiKeyboardType)
                .autocapitalization(uiTextAutoCapitalizationType)
                .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
            
            Divider().background(Color(UIColor().colorFromHex("#F88379", 1)))
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomTextField(strLabel: "Label", strField: .constant(""), uiTextAutoCapitalizationType: UITextAutocapitalizationType.none, uiKeyboardType: .alphabet)
    }
}
