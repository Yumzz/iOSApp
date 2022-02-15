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
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 10) {
                
                Spacer()
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.rest).bold()
                        .foregroundColor(Color("WhiteOrange"))
                    
                    
                    Text(self.dishesString)
                        .foregroundColor(Color("WhiteTextGrey"))
                        .font(.system(size: 14))
                    
                    Text(dateFormatter.string(from: self.order.time)).foregroundColor(Color("Back"))
                        .font(.system(size: 14))
                    
                    Text(String(self.order.totalPrice))
                        .foregroundColor(Color("GreyWhite"))
                        .font(.system(size: 14))
                    
                    
                }
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 112)
            .background(Color("DarkBack"))
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
