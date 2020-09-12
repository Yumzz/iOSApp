//
//  GradientUIView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/11/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit

class GradientUIView : UIView {
    var topColor : UIColor = UIColor().colorFromHex("#F88379", 1)
    
    var bottomColor: UIColor = UIColor().colorFromHex("#FFFFFF", 1)
    
    var startPointX : CGFloat = 0
    var startPointY : CGFloat = 0
    
    var endPointX: CGFloat = 0.25
    var endPointY: CGFloat = 0.75
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
