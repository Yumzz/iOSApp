//
//  CoralButton.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import SwiftUI

struct CoralButton: View {
    
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
                        .frame(width: 50, height: 30)
                }
                
                Text(strLabel)
                        .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
        .modifier(LeadingTextModifier(imgExists: imageExists(named: imgName)))
           
        }
            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
            .background(Color(UIColor().colorFromHex("#F88379", 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
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

struct CoralxButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
             CoralButton(strLabel: "Button")
            CoralButton(strLabel: "Continue with Google", imgName: "continue_with_google")
        }
       
    }
}
