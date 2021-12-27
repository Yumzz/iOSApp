//
//  BackButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import SwiftUI

struct BackButton: View {
    var mode: Binding<PresentationMode>
    var dark: Bool = false
    
    var body: some View {
        
        HStack{
            Button(action: goBack){
                
                Image(dark ? "white_back_button" : "back_button")
                    .renderingMode(.original)
            }
            
            
        }
    }
    
    func goBack(){
//        navigationController?.popToRootViewController(animated: true)
        self.mode.wrappedValue.dismiss()
        
    }
}
