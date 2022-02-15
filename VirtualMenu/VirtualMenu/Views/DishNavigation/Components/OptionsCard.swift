//
//  OptionsCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/15/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct OptionsCard: View {
    var options: [String: Float]
    @State var optNames: [String] = [String]()
    @State var color : [String: Color] = [String: Color]()
    var exclusive: Bool
    
    @State var optCosts : Double = 0.0
    var dish: DishFB
    
//    #if !APPCLIP
    @EnvironmentObject var order : OrderModel
//    #endif
    
    @State var optSelected: [String: Bool] = [String:Bool]()
    
    
    func toggle(opt: String) {
        if(!self.optSelected[opt]!){
            if(exclusive){
//                #if !APPCLIP
                if(!self.order.optsChosen.isEmpty){
                    if(!self.order.optsChosen[dish]!.isEmpty){
                        self.order.optsChosen[dish]!.removeAll()
                    }
                }
//                #endif

                for x in self.optSelected.keys{
                    self.optSelected[x] = false
                }
            }
            self.optSelected[opt] = true
//            #if !APPCLIP

            if(self.order.optsChosen[dish] == nil){
                self.order.optsChosen[dish] = []
            }
            self.order.optsChosen[dish]!.append(opt)
//            #endif
        }
        else{
//            #if !APPCLIP
            self.optSelected[opt] = false
            let x = self.order.optsChosen[dish]!.firstIndex(of: opt)!
            self.order.optsChosen[dish]?.remove(at: x)
            if(self.order.optsChosen[dish] == []){
                self.order.optsChosen[dish] = nil
            }
//            #endif
        }
    }
    
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    ForEach(self.optNames, id:\.self){ opt in
                        HStack(spacing: 10){
                            VStack(alignment: .leading){
                                Text("Add \(opt)")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color("Back"))
                                if(options[opt]! == 0.00){
                                    Text("Free")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("Back"))
                                }
                                else{
                                    Text("\(DishFB.priceFix(price: String(options[opt]!)))")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("Back"))
                                }
                            }
                            Spacer()
                            
                            Button(action: {self.toggle(opt: opt)}) {
                                Image(systemName: self.optSelected[opt]! ? "checkmark.square" : "square")
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(ColorManager.yumzzOrange)
                                    .font(.system(size: 30))
                            }
                        }
                    }
                    
                }
            }.background(Color("Blackest"))
            .frame(width: UIScreen.main.bounds.width/1.3, height: 150, alignment: .center)
            .padding()
            
        }.onAppear(){
            for x in options.keys {
                print("options: \(x)")
                self.optNames.append(x)
                self.color[x] = Color.white
                self.optSelected[x] = false
            }
        }
        .padding()

        
    }
}
