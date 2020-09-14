//
//  BottomMapGradientView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/13/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct BottomMapGradientView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        return BottomMapGradientUIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
