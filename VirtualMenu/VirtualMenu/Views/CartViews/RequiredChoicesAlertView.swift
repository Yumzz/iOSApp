//
//  RequiredChoicesAlertView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/18/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct RequiredChoicesAlertView: View {
//    @Binding var shown: Bool
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var choicesSpecInstruct: String = ""
    var order : OrderModel = OrderModel.init()
    @State var reqDishesNotInstructed: [DishFB] = []
    @State var reqInstructions: String = ""
    
    var body: some View {
        ZStack{
            Color("DarkBack").edgesIgnoringSafeArea(.all)
            VStack{
                Text("Required Choices")
                    .foregroundColor(Color("Blackest"))
                Spacer().frame(height: 10)
                RequiredChoicesCard(dishes: self.reqDishesNotInstructed)
//                Text("\(choicesSpecInstruct) need\(choicesSpecInstruct.contains(",") ? "s" : "") instructions before order can be sent. Please edit these instructions by clicking on the pencil and read the alert carefully. \(reqInstructions)")
//                    .foregroundColor(Color("Blackest"))
//                Divider()
            }
            .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height)
            .background(Color("BlackestOffWhite"))
            .cornerRadius(10)
            .shadow(radius: 2)
            .clipped()
//            .onAppear(){
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    self.mode.wrappedValue.dismiss()
//                }
//            }
        }.onAppear(){
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "RequiredChoicesMet"), object: nil, queue: .main) { (Notification) in
//                self.order.orderSent()
                var dish = Notification.object! as! DishFB
                self.choicesSpecInstruct = choicesSpecInstruct.replacingOccurrences(of: dish.name, with: "")
                let dishnames = choicesSpecInstruct.split(separator: ",")
                if let index = reqDishesNotInstructed.firstIndex(of: dish) {
                    reqDishesNotInstructed.remove(at: index)
                }
                
                
            }
            let dishnames = choicesSpecInstruct.split(separator: ",")
            
            for ddname in dishnames{
                let dish = order.dishesChosen.filter{ $0.name == ddname.trimmingCharacters(in: .whitespacesAndNewlines) }
//                if(reqDishesNotInstructed.count == 0){
//                    reqDishesNotInstructed.insert(contentsOf: dish, at: 0)
//                }
//                else{
                reqDishesNotInstructed.insert(contentsOf: dish, at: reqDishesNotInstructed.count)
//                }
//                reqDishesNotInstructed.append(dish[0])
//                reqInstructions = reqInstructions + "For \(ddname) " + dish[0].requiredChoices.lowercased() + "."
            }
            
        }
    }
    
    
    
    
}
