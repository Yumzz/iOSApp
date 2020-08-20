//
//  UserStore.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 30/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

class UserStore: ObservableObject {
    @Published var isLogged: Bool = {
        // Register the app default:
        UserDefaults.standard.register(defaults: ["isLogged" : false])
        
        // Initialize the property with the current user default:
        return UserDefaults.standard.bool(forKey: "isLogged")
        }()
        {
        didSet {
            UserDefaults.standard.set(self.isLogged, forKey: "isLogged")
        }
    }
    
    @Published var showOnboarding: Bool = {
        // Register the app default:
        UserDefaults.standard.register(defaults: ["showOnboarding" : true])
        
        // Initialize the property with the current user default:
        return UserDefaults.standard.bool(forKey: "showOnboarding")
        }()
        {
        didSet {
            UserDefaults.standard.set(self.showOnboarding, forKey: "showOnboarding")
        }
    }
    
}
