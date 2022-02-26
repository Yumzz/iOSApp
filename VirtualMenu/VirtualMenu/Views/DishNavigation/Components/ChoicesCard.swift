//
//  ChoicesCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/21/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct ChoicesCard: View {
    var types = ["Substitute", "Choice of", "Add"]
    //incoming data - ["choice of" - ["", "", ""] , "add" - [["", "",""]:"price"], "substitute" - [["", "",""]:"price"]
    var choices : [String:[String:[String]]]
    let choiceSelect = ["substitute", "choice of", "add", "required"]
    var choiceSelected = ["", "", ""]
    var dish : DishFB
    
    @EnvironmentObject var order : OrderModel
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView{
                    ForEach(self.types, id:\.self){ type in
                        HStack(spacing: 10){
                            VStack(alignment: .leading){
//                                Text("\(type)")
//                                    .font(.system(size: 18))
//                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10){
                                        ForEach(0 ... choices.count, id:\.self){ choice in
                                            var x = String(choice)
                                            let y = choices[x]
                                            ForEach(choiceSelect, id:\.self) { chIndex in
//                                                choices[x]
//                                                y[chIndex]
                                            }
                                            
//                                        Text((choices[String(choice)]))
//                                            .background((self.choiceSelected[choiceSelectIndex[type]] == choice) ? ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) : ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
//                                            .foregroundColor((self.choiceSelected[choiceSelectIndex[type]] == choice) ? Color(UIColor().colorFromHex("#FFFFFF", 1)) : ColorManager.textGray)
//                                            .cornerRadius(5)
//                                            .onTapGesture {
//                                                if((self.choiceSelected[choiceSelectIndex[type]] == choice)){
//                                                    self.choiceSelected[choiceSelectIndex[type]] = ""
//                                                    self.order.dishChoice[dish][choiceSelectIndex[type]] = ""
//                                                }
//                                                else{
//                                                    self.choiceSelected[choiceSelectIndex[type]] = choice
//                                                    self.order.dishChoice[dish][choiceSelectIndex[type]] = choice
//                                                }
//                                            }
//
//                                        }
                                    }
                                }
                            }
                        }
                    
                    }
                }
            }
        }
    }
    
    
    
    
}
