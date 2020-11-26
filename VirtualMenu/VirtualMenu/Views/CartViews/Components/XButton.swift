//
//  XButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import SwiftUI

struct XButton: View {
    var mode: Binding<PresentationMode>
    var body: some View {
        
        HStack{
            Button(action: goBack){
                Image("x_button")
                    .renderingMode(.original)
            }
            
            
        }
    }
    
    func goBack(){
//        navigationController?.popToRootViewController(animated: true)
        self.mode.wrappedValue.dismiss()
        
    }
}
