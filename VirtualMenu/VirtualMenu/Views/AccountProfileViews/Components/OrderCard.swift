//
//  OrderCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/16/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderCard: View {
    
    var order: Order
    @State var dishesString = ""
    let dateFormatter = DateFormatter()
    var dark : Bool = false
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 10) {
                
                Spacer()
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.rest).bold()
                        .foregroundColor(dark ? .white : ColorManager.yumzzOrange)
                    
                    
                    Text(self.dishesString)
                        .foregroundColor(dark ? .white : ColorManager.textGray)
                        .font(.system(size: 14))
                    
                    Text(dateFormatter.string(from: self.order.time)).foregroundColor(dark ? .white : .black)
                        .font(.system(size: 14))
                    
                    Text(String(self.order.totalPrice))
                        .foregroundColor(dark ? .white : Color(UIColor().colorFromHex("#C4C4C4", 1)))
                        .font(.system(size: 14))
                    
                    
                }
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 112)
            .background(dark ? Color(ColorManager.darkBack) : Color(.white))
            .cornerRadius(10)
            .onAppear(){
                dateFormatter.dateStyle = .medium
                for d in self.order.dishes {
                    print("alldishes: \(self.order.dishes)")
                    print("when order card appears: \(d.name)")
                    if self.dishesString.isEmpty {
                        print("f dish: \(d.name)")
                        self.dishesString += d.name
                    }
                    else{
                        print("s dish: \(d.name)")
                        self.dishesString += ", " + d.name
                    }
                    if d == self.order.dishes.last {
                        print("dishstring: \(self.dishesString)")
                    }
                }
//                let dateFormatter = DateFormatter()

                // Convert Date to String
//                dateFormatter.string(from: date)
            }
        }.padding(.horizontal)
    }
    
    
}
