//
//  PastOrdersViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


class PastOrdersViewModel: ObservableObject{
    
    @EnvironmentObject var order : OrderModel
    
    func fetchPastOrders(){
        self.order.retrieveOrders(userID: userProfile.userId)
    }
    
    init(){
        self.fetchPastOrders()
    }
    
    
    
}
