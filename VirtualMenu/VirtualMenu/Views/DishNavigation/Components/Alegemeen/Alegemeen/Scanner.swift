//
//  Scanner.swift
//  Alegemeen
//
//  Created by Rohan Tyagi on 3/6/21.
//

import Foundation
import UIKit
import SwiftUI

struct Scanner: UIViewControllerRepresentable {
private let completionHandler: ([String]?) -> Void

init(completion: @escaping ([String]?) -> Void) {
    self.completionHandler = completion
}
 
typealias UIViewControllerType = ScannerViewController
 
func makeUIViewController(context: UIViewControllerRepresentableContext<Scanner>) -> ScannerViewController {
    let viewController = ScannerViewController()
    return viewController
}
 
func updateUIViewController(_ uiViewController: ScannerViewController, context: UIViewControllerRepresentableContext<Scanner>) {}
 
}
