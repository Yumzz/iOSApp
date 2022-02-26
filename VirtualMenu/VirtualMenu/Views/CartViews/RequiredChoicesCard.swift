//
//  RequiredChoicesCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/19/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct RequiredChoicesCard: View {
//    var types = ["Substitute", "Choice of", "Add"]
    //incoming data - ["choice of" - ["", "", ""] , "add" - [["", "",""]:"price"], "substitute" - [["", "",""]:"price"]
    var dishes : [DishFB]
    let choiceSelect = ["substitute", "choice of", "add", "required", "required side", "can get"]
    @State var choicesClicked: Set<String> = []
    @State var choicesRemoved: Set<String> = []
    
    @EnvironmentObject var order : OrderModel
    
    var body: some View {
        ZStack{
            VStack{
//                ScrollView{
                    ForEach(self.dishes, id:\.name){ dish in
//                            ForEach(choiceSelect, id:\.self){ choiceType in
//                                    VStack{
                        Text("\(dish.name)")
                        Spacer().frame(height:10)
                        ScrollView(.horizontal){
                        HStack{
                            ForEach(0 ... dish.choices.count, id:\.self){ choiceNum in
                                if(dish.choices[String(choiceNum)]?["required"] != nil){
                                    ForEach(dish.choices[String(choiceNum)]!["required"]!, id:\.self){ choice in
                                        Group{
                                                Text("\(choice)")
                                                .foregroundColor(Color("BlackestOffWhite"))
                                                    RoundedRectangle.init(cornerRadius: 5)
                                                    .fill(self.choicesClicked.contains(choice  + "-\(dish.name)") ? ColorManager.yumzzOrange : Color.white)
                                                    .border(ColorManager.yumzzOrange)
                                                    .onTapGesture(){
                                                        if(self.choicesClicked.contains(choice + "-\(dish.name)")){
                                                            self.choicesRemoved.insert(choice + "-\(dish.name)")
                                                            self.choicesClicked.remove(choice + "-\(dish.name)")
//                                                            self.order
                                                            self.order.dishChoice[dish]?.replacingOccurrences(of: choice, with: "")
                                                            choicesRemoved.removeAll()
                                                        }
                                                        else{
                                                            self.choicesClicked.insert(choice + "-\(dish.name)")
                                                            self.order.dishChoice[dish]! += choice
                                                            //send notification to review order
                                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RequiredChoicesMet"), object: dish)
                                                        }
                                                    }
                                                    .frame(width: 20, height: 20)
                                        }
                                        .frame(width: 80, height: 100)
                                            .cornerRadius(10)
                                            .shadow(radius: 2)
                                            
                                        
//                                            .background(ColorManager.offWhiteBack)
                                        }
                                }
                            }
                        }
                        }.background(Color("PinkishOrange"))
//                                }
                                    
                                
                                
                                
//                            }
                            
                            
                        }
                        
                        
                        
//                    }
                    
                    
                }
                
            }.background(Color("BlackestOffWhite"))
            
        }
    }
        
    
