//
//  Extensions.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
        
    
    func colorFromHex(_ hex: String,_ alpha: CGFloat) -> UIColor {
        var hexstring = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexstring.hasPrefix("#"){
            hexstring.remove(at: hexstring.startIndex)
        }
        
        if hexstring.count != 6{
            return UIColor.black
        }
        
        var rgb : UInt32 = 0
        Scanner(string: hexstring).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat((rgb & 0x0000FF)) / 255.0, alpha: alpha)
        
    }
}

extension UIImage {
var circle: UIImage? {
  let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
  //let square = CGSize(width: 36, height: 36)
  let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
  imageView.contentMode = .scaleAspectFill
  imageView.image = self
  imageView.layer.cornerRadius = square.width / 2
  imageView.layer.masksToBounds = true
  UIGraphicsBeginImageContext(imageView.bounds.size)
  guard let context = UIGraphicsGetCurrentContext() else { return nil }
  imageView.layer.render(in: context)
  let result = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return result
}
}