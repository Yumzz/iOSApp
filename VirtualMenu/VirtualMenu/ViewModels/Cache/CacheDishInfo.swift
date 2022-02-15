//
//  CacheDishInfo.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/3/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

class CacheDishInfo: ObservableObject {
    
    @ObservedObject var dishLoader: DishLoader = DishLoader()
    //cache the dish and rest as models - all attributes will be saved on them
    @State var Dish: DishFB = DishFB.previewDish()
    
    init(id: String){
        self.dishLoader.loadDish(withID: id) { (res) in
            switch res {
                case .success(let dish):
                    self.Dish = dish
                    break
                case(.failure(let e)):
                    break
            }
        }
    }
    
}
