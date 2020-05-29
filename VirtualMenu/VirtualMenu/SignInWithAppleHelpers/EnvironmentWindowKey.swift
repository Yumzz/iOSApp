//
//  EnvironmentWindowKey.swift
//  SwiftUISignInWithApple
//
//  Created by Rohan Tyagi on 05/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import SwiftUI

struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
    var window: UIWindow? {
        get { return self[WindowKey.self].value }
        set { self[WindowKey.self] = .init(value: newValue) }
    }
}

