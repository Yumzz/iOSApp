//
//  OptionsCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/15/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct BuildOptsCard: View {
    var options: [String: Float]
    var typePrices: [String: Float]
    @State var optNames: [String] = [String]()
    @State var color : [String: Color] = [String: Color]()
    var exclusive: Bool
    
    @State var optCosts : Double = 0.0
        
    @EnvironmentObject var order : OrderModel
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    ForEach(self.optNames, id:\.self){ opt in
                        HStack(spacing: 10){
                            VStack(alignment: .leading){
                                Text("Add \(opt)")
                                    .font(.system(size: 18))
                                if(options[opt]! == 0.00){
                                    Text("Free")
                                        .font(.system(size: 14))
                                }
                                else{
                                    Text("\(DishFB.formatPrice(price: Double(options[opt]!)))")
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
                                    if(self.color[opt]! == Color.white){
                                        if(exclusive){
//                                            if(!self.order.optsChosen.isEmpty){
//                                                if(!self.order.optsChosen[dish]!.isEmpty){
//                                                    self.order.optsChosen[dish]!.removeAll()
//                                                }
//                                            }
                                            for x in self.color.keys{
                                                self.color[x] = Color.white
                                            }
                                        }
                                        self.color[opt] = ColorManager.yumzzOrange
//                                        if(self.order.optsChosen[dish] == nil){
//                                            self.order.optsChosen[dish] = []
//                                        }
//                                        self.order.optsChosen[dish]!.append(opt)
                                    }
                                    else{
                                        self.color[opt] = Color.white
//                                        let x = self.order.optsChosen[dish]!.firstIndex(of: opt)!
//                                        self.order.optsChosen[dish]?.remove(at: x)
//                                        if(self.order.optsChosen[dish] == []){
//                                            self.order.optsChosen[dish] = nil
//                                        }
                                    }
                                }
                        }
                    }
                    
                }
            }.background(Color.white)
            .frame(width: UIScreen.main.bounds.width/1.3, height: 150, alignment: .center)
            .padding()
            
        }.onAppear(){
            for x in options.keys {
                print("options: \(x)")
                self.optNames.append(x)
                self.color[x] = Color.white
            }
        }
        .padding()

        
    }
}
