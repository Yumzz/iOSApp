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
    var body: some View {
        
        HStack{
            Button(action: goBack){
                Image("back_button")
                    .renderingMode(.original)
            }
            
            
        }
    }
    
    func goBack(){
        print("wow")
//        navigationController?.popToRootViewController(animated: true)
        self.mode.wrappedValue.dismiss()
        
    }
}
