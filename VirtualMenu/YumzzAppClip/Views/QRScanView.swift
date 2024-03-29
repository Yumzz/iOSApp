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

init(completion: @escaping ([String]?) -> Void) {
    self.completionHandler = completion
}
 
typealias UIViewControllerType = QRScanViewController
 
func makeUIViewController(context: UIViewControllerRepresentableContext<QRScanView>) -> QRScanViewController {
    let viewController = QRScanViewController()
    return viewController
}
 
func updateUIViewController(_ uiViewController: QRScanViewController, context: UIViewControllerRepresentableContext<QRScanView>) {}
 
}
