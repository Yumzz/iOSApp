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
    
    var aspectRatio: ContentMode = .fill
    var width = CGFloat()
    var height = CGFloat()
    
    let url: String
    var circle: Bool
    
    init(url: String, imageAspectRatio: ContentMode = .fill, imageWidth: CGFloat = 88, imageHeight: CGFloat = 88, circle: Bool) {
        self.url = url
        self.aspectRatio = imageAspectRatio
        self.width = imageWidth
        self.height = imageHeight
        self.circle = circle
        imageLoader = ImageLoader(urlString: self.url.replacingOccurrences(of: "\\", with: ""))


    }
    
    var body: some View {
        
        Group {
            if (imageLoader.image != nil) {
                if(circle){
                    Image(uiImage: imageLoader.image!.circle!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: self.aspectRatio)
                        .frame(width: self.width, height: self.height, alignment: .center)
                }
                else{
                    Image(uiImage: imageLoader.image!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: self.aspectRatio)
                        .frame(width: self.width, height: self.height, alignment: .center)
                }
            } else {
                Rectangle()
                    .frame(width: self.width, height: self.height, alignment: .center)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct FBURLImage_Previews: PreviewProvider {
    static var previews: some View {
        FBURLImage(url: "", circle: false)
    }
}
