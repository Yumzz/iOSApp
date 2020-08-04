//
//  OrderView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    
    @State private var selectorIndex = 0
    @State private var numbers = ["Upcoming","Past Orders"]
    
    var body: some View {
        VStack() {
            Picker("Numbers", selection: self.$selectorIndex) {
                ForEach(0 ..< self.numbers.count) { index in
                    Text(self.numbers[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            Text("See: \(self.numbers[self.selectorIndex])").padding()
            
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("My Orders")
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderView()
        }
        
    }
}
