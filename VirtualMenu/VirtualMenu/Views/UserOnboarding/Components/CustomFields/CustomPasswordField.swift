//
//  CustomPasswordField.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct CustomPasswordField: View {
    
    var field: String
    var strLabel: String
    
    @Binding var password: String
    
    var body: some View {
        VStack (spacing: 0) {
            Text(field)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 60)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 514, weight: .regular, design: .default))
                .foregroundColor(Color("OrangeWhite"))
            SecureField(strLabel, text: $password)
                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                .imageScale(.small)
                .foregroundColor(Color("PinkishOrange"))
//                .border(SeparatorShapeStyle(), width: 5)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .shadow(radius: 4)
            Divider()
                .frame(width: UIScreen.main.bounds.width/1.2, height: 10, alignment: .leading)
                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                .foregroundColor(Color("Back"))

        }
    }
}

struct CustomPasswordField_Previews: PreviewProvider {
    
    static var previews: some View {
        CustomPasswordField(field: "Password", strLabel: "••••••••••", password: .constant(""))
    }
}
