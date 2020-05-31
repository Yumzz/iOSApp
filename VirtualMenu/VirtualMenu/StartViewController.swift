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
    
    var body: some View {
        
        NavigationView{
                VStack{
                    VStack{
                        Logo()
                        Spacer()
                    }
                
                    VStack(spacing: 30){
                        //buttons
                        NavigationLink(destination: SignInView()){
                            CustomButton(action: {print("Digital tapped!") })
                            {
                                Text("Digital Menu")
                            }
                        }
                    
                        CustomButton(action: {print("Scan tapped!") })
                        {
                            Text("Scan Menu")
                        }
                    
                    }
                
                }
            
        }
        
    }
    
}
