//
//  ImageLoader.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 07/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

final class ImageLoader : ObservableObject {
    
    @Published var image: UIImage?
    
    var urlString: String?
    
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage(){
        
        if loadImageFromCache() {
            return
        }
        
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        
        guard let urlString = urlString else {
            return
        }
        
        let storage = Storage.storage()
        let ref = storage.reference().child(urlString)
        
        ref.downloadURL(completion: { (url, err) in
            if err != nil {
                return
            }
            else{
                ref.getData(maxSize: 1 * 2048 * 2048) { data, error in
                    
                    guard error == nil else {
                        print("Error: \(error!)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data found")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        guard let loadedImage = UIImage(data: data) else {
                            return
                        }
                        self.imageCache.set(forKey: self.urlString!, image: loadedImage)
                        self.image = loadedImage
                    }
                }
            }
            return
        })
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = self.urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        self.image = cacheImage
        return true
    }
    
}
