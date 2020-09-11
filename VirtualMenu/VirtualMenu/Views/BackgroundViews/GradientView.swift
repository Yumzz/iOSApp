//
//  GradientView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/11/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct GradientView: UIViewRepresentable {

        func makeUIView(context: Context) -> UIView {
            return GradientUIView()
        }

        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }
