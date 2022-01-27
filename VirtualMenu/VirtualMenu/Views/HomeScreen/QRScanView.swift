//
//  QRScanView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct QRScanView: UIViewControllerRepresentable {
private let completionHandler: ([String]?) -> Void
var choice: Int
    init(completion: @escaping ([String]?) -> Void, choice: Int) {
        self.completionHandler = completion
        self.choice = choice
    }
 
typealias UIViewControllerType = QRScanViewController
 
func makeUIViewController(context: UIViewControllerRepresentableContext<QRScanView>) -> QRScanViewController {
    let viewController = QRScanViewController(choice: self.choice)
    return viewController
}
 
func updateUIViewController(_ uiViewController: QRScanViewController, context: UIViewControllerRepresentableContext<QRScanView>) {}
 
}
