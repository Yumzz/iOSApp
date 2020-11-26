//
//  InputValidation.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/23/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation


func isValidInput(inputVal: String) -> Bool {
    if inputVal == "" || inputVal.isEmpty {
        return false
    }
    return true
}

