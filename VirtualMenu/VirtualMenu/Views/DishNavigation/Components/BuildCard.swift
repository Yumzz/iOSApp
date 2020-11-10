//
//  BuildCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/9/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct BuildCard: View {
    
    var buildPrices: [String: String]
    var typetoOpts: [String: [String]]
    var exclusive: [String:Bool] = [String:Bool]()
    var dish: DishFB
    @State var typeNames: [String] = [String]()
    @State var color : [String: Color] = [String: Color]()
    
    @EnvironmentObject var order : OrderModel
    
    var body: some View {
        ZStack {
            VStack{
                ForEach(self.typeNames, id: \.self){ type in
                    Text(type)
                        .font(.system(size: 18)).bold()
                    ForEach(self.typetoOpts[type]!, id: \.self){ opt in
                        HStack{
                            VStack(alignment: .leading){
                                Text(opt)
                                    .font(.system(size: 18))
                                if((buildPrices[opt]! as NSString).doubleValue == 0.00){
                                    Text("Free")
                                        .font(.system(size: 14))
                                }
                                else{
                                    Text("\(DishFB.formatPrice(price: Double((buildPrices[opt]! as NSString).doubleValue)))")
                                        .font(.system(size: 14))
                                }
                            }
                            Spacer()
                            RoundedRectangle.init(cornerRadius: 5)
                                .fill(self.color[opt]!)
                                .border(ColorManager.yumzzOrange)
                                .frame(width: 32, height: 32)
                                .foregroundColor(ColorManager.yumzzOrange)
                                .onTapGesture {
                                    if(exclusive[type]!){
                                        if(self.color[opt] == ColorManager.yumzzOrange){
                                            self.color[opt] = Color.white
                                            let x = self.order.optsChosen[dish]!.firstIndex(of: opt)!
                                            self.order.optsChosen[dish]?.remove(at: x)
                                            if(self.order.optsChosen[dish] == []){
                                                self.order.optsChosen[dish] = nil
                                            }
                                        }
                                        else{
                                            for x in typetoOpts[type]!{
                                                self.color[x] = Color.white
                                            }
                                            self.order.optsChosen[dish]?.removeAll()
                                            self.order.optsChosen[dish]?.append(opt)
                                            self.color[opt] = ColorManager.yumzzOrange
                                        }
                                    }
                                    else{
                                        if(self.color[opt] == ColorManager.yumzzOrange){
                                            self.color[opt] = Color.white
                                            let x = self.order.optsChosen[dish]!.firstIndex(of: opt)!
                                            self.order.optsChosen[dish]?.remove(at: x)
                                            if(self.order.optsChosen[dish] == []){
                                                self.order.optsChosen[dish] = nil
                                            }
                                        }
                                        else{
                                            self.order.optsChosen[dish]?.append(opt)
                                            self.color[opt] = ColorManager.yumzzOrange
                                        }
                                    }
                                    //Necessary actions:
                                    //If type is exclusive, then turn others  of same type white
                                    //Turn white if orange and clicked
                                    //turn orange if white and clicked
                                    //turn orange if
                                }
                        }

                    }
                }
                
                
            }
        }.onAppear(){
            for x in typetoOpts.keys {
                print("type: \(x)")
                self.typeNames.append(x)
                for opt in typetoOpts[x]!{
                    self.color[opt] = Color.white
                }
            }
        }
    }
}
