//
//  ImageCache.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 12/09/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import UIKit

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    func reset(){
        cache.removeAllObjects()
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
