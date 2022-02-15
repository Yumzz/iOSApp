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
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

        /// Returns the data for the specified image in JPEG format.
        /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
        /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
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
    
//    public func
    static func priceFix(price: String) -> String {
        if(price.components(separatedBy: ".")[1].count < 2){
            if(price.components(separatedBy: ".")[1].count < 1){
                return price + "00"
            }
            else{
                return price + "0"
            }
        }
        else{
            return price
        }
    }
    
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
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

    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func sidesFixed(str: String, dishcat: [DishCategory]) -> String{
        if str.contains("choice of side") {
            let results = dishcat.filter { $0.name == "Sides" }
            let results2 = dishcat.filter { $0.name == "Sidelines" }
            if(!results.isEmpty){
                str.replacingOccurrences(of: "choice of side", with: "choice of \(results)")
            }
            if(!results2.isEmpty){
                str.replacingOccurrences(of: "choice of side", with: "choice of \(results2)")
            }
        }
        return str
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
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom + 40)
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

public struct TextStyle {
    // This type is opaque because it exposes NSAttributedString details and
    // requires unique keys. It can be extended by public static methods.

    // Properties are internal to be accessed by StyledText
    internal let key: NSAttributedString.Key
    internal let apply: (Text) -> Text

    private init(key: NSAttributedString.Key, apply: @escaping (Text) -> Text) {
        self.key = key
        self.apply = apply
    }
}

public extension TextStyle {
    static func foregroundColor(_ color: Color) -> TextStyle {
        TextStyle(key: .init("TextStyleForegroundColor"), apply: { $0.foregroundColor(color) })
    }

    static func bold() -> TextStyle {
        TextStyle(key: .init("TextStyleBold"), apply: { $0.bold() })
    }
}

public struct StyledText: View {
    // This is a value type. Don't be tempted to use NSMutableAttributedString here unless
    // you also implement copy-on-write.
    private var attributedString: NSAttributedString

    private init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public func style<S>(_ style: TextStyle,
                         ranges: (String) -> S) -> StyledText
        where S: Sequence, S.Element == Range<String.Index>
    {

        // Remember this is a value type. If you want to avoid this copy,
        // then you need to implement copy-on-write.
        let newAttributedString = NSMutableAttributedString(attributedString: attributedString)

        for range in ranges(attributedString.string) {
            let nsRange = NSRange(range, in: attributedString.string)
            newAttributedString.addAttribute(style.key, value: style, range: nsRange)
        }

        return StyledText(attributedString: newAttributedString)
    }
}
public extension StyledText {
    // A convenience extension to apply to a single range.
    func style(_ style: TextStyle,
               range: (String) -> Range<String.Index> = { $0.startIndex..<$0.endIndex }) -> StyledText {
        self.style(style, ranges: { [range($0)] })
    }
}
extension StyledText {
    public init(verbatim content: String, styles: [TextStyle] = []) {
        let attributes = styles.reduce(into: [:]) { result, style in
            result[style.key] = style
        }
        attributedString = NSMutableAttributedString(string: content, attributes: attributes)
    }
        public var body: some View { text() }

        public func text() -> Text {
            var text: Text = Text(verbatim: "")
            attributedString
                .enumerateAttributes(in: NSRange(location: 0, length: attributedString.length),
                                     options: [])
                { (attributes, range, _) in
                    let string = attributedString.attributedSubstring(from: range).string
                    let modifiers = attributes.values.map { $0 as! TextStyle }
                    text = text + modifiers.reduce(Text(verbatim: string)) { segment, style in
                        style.apply(segment)
                    }
            }
            return text
        }
    
}
extension TextStyle {
    static func highlight() -> TextStyle { .foregroundColor(ColorManager.yumzzOrange) }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

