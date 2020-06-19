//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by William Bai on 6/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishDetailsView: View {
    
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(dish.name)")
                .font(.title)
            Image(uiImage: Dish.getUIImageFromCKAsset(image: dish.coverPhoto)!)
                .resizable()
                .frame(width: 330, height: 230)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(25)
            Text(Dish.formatPrice(price: dish.price))
            Text(dish.description)
            ScrollView(.vertical) {
                Text("Reviews")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("review")
                }
            }.frame(width: 330, height: 360, alignment: .center).cornerRadius(25)
        }.padding()
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: Dish.previewDish())
    }
}
