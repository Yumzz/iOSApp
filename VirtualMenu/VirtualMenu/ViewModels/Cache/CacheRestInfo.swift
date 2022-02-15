//
//  CacheRestInfo.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/20/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

class CacheRestInfo: ObservableObject {
    
    @ObservedObject var restLoader: RestLoader = RestLoader()
    //cache the dish and rest as models - all attributes will be saved on them
    @State var rest: RestaurantFB = RestaurantFB.previewRest()
    
    init(id: String){
        self.restLoader.loadRest(withID: id) { (res) in
            switch res {
                case .success(let rest):
                    self.rest = rest
                    break
                case(.failure(let e)):
                    break
            }
        }
    }
    
}
