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
    @Binding var popUpShown: Bool
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
                    .font(.system(size: 24,weight: .semibold))
                    
            }
            .padding(.bottom)
            
            HStack{
                Text("4.44")
                    .font(.system(size: 48,weight: .bold))
                    .frame(width:  120)
                Spacer()
                Button(action: {
                    self.popUpShown = true
                }){
                    Text("+ Add Reviews").font(.system(size: 18, weight: .medium)).tracking(-0.41)
                }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                
            }
            .padding()
            
            ForEach(self.menuSelectionVM.reviews, id: \.id){
                review in
                VStack{
                    HStack{
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                        Text("USERNAME")
                        Spacer()
                    }
                    Text(review.text)
                }
                .padding()
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
