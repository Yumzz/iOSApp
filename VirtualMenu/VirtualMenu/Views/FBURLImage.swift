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

    init(url: String) {
        imageLoader = ImageLoader()
        imageLoader.loadImage(url: url)
    }

    var body: some View {
        Image(uiImage:
            imageLoader.data != nil ? UIImage(data: imageLoader.data!)! : UIImage())
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
//            .frame(width: 88, height: 88, alignment: .leading)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width:100, height:100)
            
            .background(Color.gray)
//            .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }
}

struct FBURLImage_Previews: PreviewProvider {
    static var previews: some View {
        FBURLImage(url: "")
    }
}
