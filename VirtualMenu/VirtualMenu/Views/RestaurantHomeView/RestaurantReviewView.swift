//
//  SwiftUIView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantReviewView: View {
    @Binding var shown: Bool
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Button(action:{
                    self.shown.toggle()
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
                Text("Ratings and Reviews")
                    .frame(maxWidth: .infinity, alignment: .center)
                    
            }
            ForEach(self.menuSelectionVM.reviews, id: \.id){
                review in
                Text(review.text)
            }
            Spacer()
        }.padding()
    }
}

struct RestaurantReviewView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantReviewView()
        EmptyView()
    }
}
