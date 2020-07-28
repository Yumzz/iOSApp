//
//  BlackButton.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct BlackButton: View {
    
    var strLabel: String
    var imgName: String?
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                if (imageExists(named: imgName)){
                    
                    Image(imgName!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
                Text(strLabel)
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
                
        .modifier(LeadingTextModifier(imgExists: imageExists(named: imgName)))
           
        }
        .cornerRadius(10)
        .background(Color(UIColor().colorFromHex("#000000", 1)))
    }
}


//Modifier to have a leading text when there is an image
struct LeadingTextModifier: ViewModifier {

    var imgExists: Bool

    func body(content: Content) -> some View {
        Group {
            if self.imgExists {
                content.frame(width: UIScreen.main.bounds.width/1.5, height: 40, alignment: .leading)
            }
            else{
                content.frame(width: UIScreen.main.bounds.width/1.5, height: 40)
            }
        }
    }
}


func imageExists(named: String?) -> Bool {
    var exists = false
    
    if named != nil && ((UIImage(named: named!)) != nil){
        exists = true
    }
   
   return exists
}

struct BlackButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
             BlackButton(strLabel: "Button")
            BlackButton(strLabel: "Continue with Google", imgName: "continue_with_google")
        }
       
    }
}
