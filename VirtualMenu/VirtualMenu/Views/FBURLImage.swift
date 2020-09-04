//
//  FBURLImage.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 08/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct FBURLImage: View {
    @ObservedObject var imageLoader: ImageLoader
    
    var aspectRatio: ContentMode = .fit
    var width = CGFloat()
    var height = CGFloat()
    
    init(url: String, imageAspectRatio: ContentMode = .fit, imageWidth: CGFloat = 88, imageHeight: CGFloat = 88) {
        imageLoader = ImageLoader()
        imageLoader.loadImage(url: url)
        
        self.aspectRatio = imageAspectRatio
        
        self.width = imageWidth
        self.height = imageHeight
    }
    
    init(url: String, imageAspectRatio: ContentMode = .fit, imageWidth: CGFloat, imageHeight: CGFloat, owndimen: Bool) {
        imageLoader = ImageLoader()
        imageLoader.loadImage(url: url)
        
        self.aspectRatio = imageAspectRatio
        
        self.width = imageWidth
        self.height = imageHeight
    }
    
    var body: some View {
        
        Group {
            if imageLoader.data == nil {
                EmptyView()

            } else {
                Image(uiImage: UIImage(data: imageLoader.data!)!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: self.aspectRatio)
                    .frame(width: self.width, height: self.height, alignment: .center)
//                    .background(Color.gray)
            }
        }
    }
}

struct FBURLImage_Previews: PreviewProvider {
    static var previews: some View {
        FBURLImage(url: "")
    }
}
