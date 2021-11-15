//
//  ImageLoader.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 07/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
//#if !APPCLIP
import Firebase
import FirebaseFirestore
//#endif

final class ImageLoader : ObservableObject {
    
    @Published var image: UIImage?
    
    var urlString: String?
    
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage(){
        
        DispatchQueue.main.async { [self] in
            if(imageCache.get(forKey: self.urlString!) != nil){
                print("cached image")
                self.image = imageCache.get(forKey: self.urlString!)
            }
            else{
                if loadImageFromCache() {
                    print("urlfromcache: \(urlString)")
                    return
                }
                else{
                    print("made here")
                    loadImageFromUrl()

                }
            }
            
            
        }
    }
    
    func loadImageFromUrl() {
        DispatchQueue.main.async { [self] in
        
        guard let urlString = urlString else {
            print("guard failed in loadimfromurl: \(self.urlString)")
            return
        }
        
        let storage = Storage.storage()
        self.urlString = urlString
        print("greg: \(self.urlString)")
        let ref = storage.reference().child(self.urlString!)
        if((self.imageCache.get(forKey: self.urlString!)) != nil){
            print("tried to get from url but was alreadty cached!!!: \(self.urlString)")
            self.image = self.imageCache.get(forKey: self.urlString!)
        }
        else{
            ref.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(url)
                    print("error downloading image: \(self.urlString)")
                    return
                }
                else{
                    if((self.imageCache.get(forKey: self.urlString!)) != nil){
                        print("almost retrieved even though not necessary")
                        self.image = self.imageCache.get(forKey: self.urlString!)
                    }
                    else{
                    ref.getData(maxSize: 1 * 2048 * 2048) { data, error in
                        
                        guard error == nil else {
                            print("Error: \(error!) + \(self.urlString)")
                            return
                        }
                        
                        guard let data = data else {
                            print("No data found: \(self.urlString)")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            if(self.imageCache.get(forKey: self.urlString!) != nil){
                                print("retrieved even though not necessary")
                                self.image = self.imageCache.get(forKey: self.urlString!)
                            }
                            else{
                                guard let loadedImage = UIImage(data: data)?.jpeg(.lowest) else {
                                    return
                                }
                                guard let im = UIImage(data: loadedImage) else{
                                    return
                                }
                                self.imageCache.set(forKey: self.urlString!, image: im)
                                print("load: \(loadedImage)  \(self.urlString)")
                                self.image = im
                            }
                        }
                    }
                    }
                }
                return
            })
        }
        }
    }
    
    func loadImageFromCache() -> Bool {
        
        
        guard let urlString = self.urlString else {
            print("string does not exit")
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            print("not cached: \(self.urlString)")
            return false
        }
        
        DispatchQueue.main.async {
            self.image = cacheImage
            
        }
        return true
        
    }
    
}
