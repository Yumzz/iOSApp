//
//  CacheDishInfo.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/3/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct CacheDishInfo: View {
    @ObservedObject var dishLoader: DishLoader
    
    let attribute: String
    var text: String = ""
    
    var cache: Cache
    
    init(attribute: String){
        self.attribute = attribute
        
        self.cache = dishLoader.cache
        
    }
    
}
