//
//  DestinationHostingController.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 9/2/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

open class DestinationHostingController<T: View>: UIHostingController<T> {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rootMirror = Mirror(reflecting: rootView)

        let storageMirror = rootView is AnyView ? rootMirror : Mirror(reflecting: rootMirror.descendant("content")!)
        let navigationTitleConfiguration = extractNavigationTitleConfiguration(storageMirror: storageMirror)

        if let navigationTitleConfiguration = navigationTitleConfiguration {
            navigationItem.title = navigationTitleConfiguration.title
//            navigationItem.largeTitleDisplayMode = navigationTitleConfiguration.displayMode
        }
    }
    private func extractNavigationTitleConfiguration(storageMirror: Mirror) -> NavigationBarTitleConfiguration? {
            guard let storage = storageMirror.descendant("storage") else { return nil }
            let storageMirror = Mirror(reflecting: storage)

            guard let swiftUIView = storageMirror.descendant("view") else { return nil }
            if let view = swiftUIView as? DestinationView {
                return view.navigationBarTitleConfiguration
            }

            return nil
        }
    }

public struct NavigationBarTitleConfiguration {
    let title: String
    let displayMode: NavigationBarItem.TitleDisplayMode
}

public protocol DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration { get }
}
