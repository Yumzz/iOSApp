//
//  Navigation.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 9/2/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
//import UIKit

open class Navigation: ObservableObject {
    let window: UIWindow

    public init(window: UIWindow) {
        self.window = window
    }
    
    public func pushView(_ view: AnyView, animated: Bool = true) {
            let controller = DestinationHostingController(rootView: view.environmentObject(self))
            pushViewController(controller, animated: animated)
        }

        public func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
            let nvc = window.rootViewController?.children.first?.children.first as? UINavigationController
            nvc?.pushViewController(viewController, animated: animated)
    }
}
