//
//  Navigator.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 30/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

class Navigator: ObservableObject {
    
    @Published var isOnboardingShowing: Bool
    
    init() {
        //TODO: initialize to false if the user logged in before
        isOnboardingShowing = true
    }
    
}
