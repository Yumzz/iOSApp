//
//  TagCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/3/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct TagCard: View {
    
    var dish: DishFB
    var card: Bool = true
    var dark: Bool = false
    
    
    var body: some View {
//        Group {
        HStack(spacing: 10){
            if(dish.tp_nums != [0] && dish.tp_nums[0] != 0){
                HStack{
                    if(dish.tp_nums[0] == 1){
                        Image("pepper")
                            .resizable()
                            .frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    if(dish.tp_nums[0] == 2){
                        Image("pepper").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Spacer().frame(width: 3)
                        Image("pepper").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    if(dish.tp_nums[0] == 3){
                        Image("pepper").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Spacer().frame(width: 3)
                        Image("pepper").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Spacer().frame(width: 3)
                        Image("pepper").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            
            if(dish.tp_nums[5] == 1){
                Image("vegan").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            
            if(dish.tp_nums[6] == 1){
                Image("vegetarian").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
                
            if(dish.photoExists){
                Image("camera").resizable().frame(width: card ? 15 : 40, height: card ? 15 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
                
//                Image(systemName: "list.bullet.rectangle")
//                    .font(.system(size: 18))
//                Spacer()
                
                
//                Spacer()
            }
            .padding()
            .onAppear(){
                print("\(dish.name): tp_nums: \(dish.tp_nums)")
            }
//            .foregroundColor(Color.white)
           
//        }
        .background(card ? (dark ? ColorManager.blackest : Color.white) : ((dark ? Color(ColorManager.darkBack) : ColorManager.offWhiteBack)))
    }
}
