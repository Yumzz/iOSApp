//
//  StartViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/30/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct StartViewController: View {
    
    
    @State private var isShowingScannerSheet = false
    @State private var text: String = ""
     
    
    
    var body: some View {
        NavigationView{
                VStack{
                    VStack{
                        Logo()
                        Spacer()
                    }
                
                    VStack(spacing: 30){
                        CustomButton(action: {print("Digital tapped!") })
                        {
                            Text("Digital Menu")
                        }
                    
                        CustomButton(action: {self.isShowingScannerSheet.toggle() })
                        {
                            Text("Scan Menu")
                        }.sheet(isPresented: self.$isShowingScannerSheet) { ScanView() }
                    
                    }
                  
                }
            
        }
        
    }
     
//    private func makeScannerView() -> SignInView {
//
//        ScannerViewController(completion: { textPerPage in
//            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                self.text = text
//            }
//            self.isShowingScannerSheet = false
//        })
//    }
//    }
}