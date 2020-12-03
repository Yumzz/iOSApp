//
//  FBURLImage.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 08/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct FBURLImageCircle: View {
    @ObservedObject var imageLoader: ImageLoader
    
    var aspectRatio: ContentMode = .fill
    var width = CGFloat()
    var height = CGFloat()
    
    let url: String
    
    init(url: String, imageAspectRatio: ContentMode = .fill, imageWidth: CGFloat = 88, imageHeight: CGFloat = 88) {
        self.url = url
        self.aspectRatio = imageAspectRatio
        self.width = imageWidth
        self.height = imageHeight
        
        imageLoader = ImageLoader(urlString: self.url)
    }
    
    var body: some View {
        
        Group {
            if (imageLoader.image != nil) {
                Image(uiImage: imageLoader.image!.circle!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: self.aspectRatio)
                    .frame(width: self.width, height: self.height, alignment: .center)
                    
            } else {
                Rectangle()
                    .frame(width: self.width, height: self.height, alignment: .center)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct FBURLImageCircle_Previews: PreviewProvider {
    static var previews: some View {
        FBURLImageCircle(url: "")
    }
}
