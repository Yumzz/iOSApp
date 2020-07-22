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
        GeometryReader { geometry in
            VStack() {
                Picker("Numbers", selection: self.$selectorIndex) {
                    ForEach(0 ..< self.numbers.count) { index in
                        Text(self.numbers[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: geometry.size.width - 100)
                Spacer()
                Text("See: \(self.numbers[self.selectorIndex])").padding()
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }

    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
