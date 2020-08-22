//
//  OrderCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/21/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderCard: View {

    var urlImage:FBURLImage?

    var dish: DishFB
    
    @ObservedObject var orderViewModel = OrderViewModel()
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View{
        Group {
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                    .frame(maxWidth: 0)
                if urlImage == nil {
                    Image(systemName: "circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 88, alignment: .leading)
                } else {
                    urlImage!
                        .frame(width: 150, height:150)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(dish.name).bold()
                        .foregroundColor(Color.primary)
                    
                    Spacer()
                        .frame(maxHeight: 0)
                    
                    
                    HStack (spacing: 5) {
                        
                        Text("\(dish.price)")
                            .foregroundColor(Color.secondary)
                            .font(.footnote)
                    }
                    
                    HStack (spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)

//                        Text(String(starRating)).bold()
//                            .foregroundColor(Color.primary)
//                            .font(.footnote)

//                        Text("(\(String(nbOfReviews)) Reviews)")
//                            .foregroundColor(Color(UIColor.systemGray))
//                            .font(.footnote)
                    }
                }
                VStack(alignment: .trailing) {
                    Image("delete_cross")
                        .frame(width: 150, height: 150)
                        .onTapGesture {
                            self.orderViewModel.deleteDish(dish: self.dish)
                        }
                    //pressing this should call deleteDish (which should refresh the list)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(Color.backgroundColor(for: colorScheme))
            .cornerRadius(10)
            //        .shadow(radius: 5)
        }
        .padding(.horizontal)
    }


}
