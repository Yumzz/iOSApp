//
//  PastOrders.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import Foundation
import Combine

struct PastOrders: View {
    
    @ObservedObject var listDishVM: PastOrdersViewModel
    
    var pastOrders: [Order] = []
    
    
    init() {
        
        var id = userProfile.userId
        
        print("Past Orders Vm created")
        
        self.listDishVM = PastOrdersViewModel()
        
//        self.pastOrders = self.listDishVM.
        
    }


    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                
//                ForEach(0...9, id: \.self){ dishCategory in
//
//
//
//                }
                
            }
        }
            
            
    }


}
