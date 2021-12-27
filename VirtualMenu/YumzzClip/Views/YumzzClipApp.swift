//
//  YumzzClipApp.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 12/22/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

@main
struct YumzzClipApp: App {
//    let window = UIWindow(windowScene: windowScene)
    let order = OrderModel()
    var body: some Scene {
        WindowGroup {
            StartView().environmentObject(order)
        }
    }
}
