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
                Text(String(format: "%.2f", Float(self.menuSelectionVM.restaurant.ratingSum)/Float(self.menuSelectionVM.restaurant.n_Ratings)))
                    .font(.system(size: 48,weight: .bold))
                Spacer()
                Button(action: {
                    self.popUpShown = true
                }){
                    Text("+ Add Reviews").font(.system(size: 18, weight: .medium)).tracking(-0.41)
                }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                
            }
            
            StarView(rating: Float(self.menuSelectionVM.restaurant.ratingSum)/Float(self.menuSelectionVM.restaurant.n_Ratings), fontSize: 20)
            Text("(Based on " + String( self.menuSelectionVM.restaurant.n_Ratings) + " reviews)")
                .foregroundColor(.secondary)
            
            .padding(.bottom)
            if (self.menuSelectionVM.reviews.isEmpty) {
                Text("No reviews yet. Add yours!")
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            } else {
                ForEach(self.menuSelectionVM.reviews, id: \.id){
                    review in
                    VStack{
                        HStack{
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                            VStack {
                                HStack {
                                    Text("USERNAME")
                                    .font(.system(size: 14, weight: .semibold ))
                                    Spacer()
                                }
                                HStack {
                                    StarView(rating: Float(review.rating))
                                    Spacer()
                                    Text("1 day ago")
                                        .font(.system(size: 14, weight: .semibold ))
                                        .foregroundColor(.gray)
                                }
                            }
                        }.padding(.bottom, 10)
                        HStack{
                            Text(review.text)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 25)
                }
            }
            Spacer()
        }.padding()
    }
}

struct StarView: View {
    var rating: Float
    
    var fontSize: CGFloat = 16

    var maximumRating = 5

    var offImage = Image(systemName: "star")
    var halfImage = Image(systemName: "star.lefthalf.fill")
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.yellow
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > Int(rating) {
            if Float(number) - rating >= 0.5 && Float(number) - rating < 1 {
                return halfImage
            }
            return offImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .font(.system(size: self.fontSize))
                    .foregroundColor(number > Int(self.rating) ? self.offColor : self.onColor)
            }
        }
    }
}

struct RestaurantReviewView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantReviewView()
        EmptyView()
    }
}
