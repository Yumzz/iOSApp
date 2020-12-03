//
//  Extensions.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit
import Combine
import SwiftUI

extension UIColor {
      
    func colorFromHex(_ hex: String,_ alpha: CGFloat) -> UIColor {
        var hexstring = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexstring.hasPrefix("#"){
            hexstring.remove(at: hexstring.startIndex)
        }
        
        if hexstring.count != 6{
            return UIColor.black
        }
        
        var rgb : UInt64 = 0
        Scanner(string: hexstring).scanHexInt64(&rgb)
        
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

extension UITabBar {
func tabsVisiblty(_ isVisiblty: Bool = true){
    if isVisiblty {
        self.isHidden = false
        self.layer.zPosition = 0
    } else {
        self.isHidden = true
        self.layer.zPosition = -1
    }
}
}


extension String {
    
    public func numberOfOccurrences(_ string: String) -> Int {
        return components(separatedBy: string).count - 1
    }
    
    func numOfNums() -> Int{
        self.numberOfOccurrences("0") + self.numberOfOccurrences("1") + self.numberOfOccurrences("2") + self.numberOfOccurrences("3") + self.numberOfOccurrences("4") + self.numberOfOccurrences("5") + self.numberOfOccurrences("6") + self.numberOfOccurrences("7") + self.numberOfOccurrences("8") + self.numberOfOccurrences("9")
    }
    
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}


extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
            }
            .animation(.easeOut(duration: 0.16))
        }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
            
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
