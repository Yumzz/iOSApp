//
//  SwiftUIView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import PromiseKit

struct RestaurantReviewView: View {
    @Binding var shown: Bool
    @Binding var popUpShown: Bool
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    @State var reviewPhotos: [String: Bool] = [String: Bool]()

    
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
                    .foregroundColor(.black)
                    
            }
            .padding(.bottom)
            
            HStack{
                Text(String(format: "%.2f", Float(self.menuSelectionVM.restaurant.ratingSum)/Float(self.menuSelectionVM.restaurant.n_Ratings)))
                    .font(.system(size: 48,weight: .bold)).foregroundColor(.black)
                Spacer()
                Button(action: {
                    self.popUpShown = true
                }){
                    Text("+ Add Reviews").font(.system(size: 18, weight: .medium)).tracking(-0.41)
                }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
            }
            
            StarView(rating: Float(self.menuSelectionVM.restaurant.ratingSum)/Float(self.menuSelectionVM.restaurant.n_Ratings), fontSize: 20)
            Text("(Based on " + String( self.menuSelectionVM.restaurant.n_Ratings) + " reviews)")
                .foregroundColor(.gray)
            
            .padding(.bottom)
            if (self.menuSelectionVM.reviews.isEmpty) {
                Text("No reviews yet. Add yours!")
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.black)
            } else {
                ForEach(self.menuSelectionVM.reviews, id: \.id){
                    review in
                    VStack{
                        HStack{
                            if(review.photoURL != ""){
                                FBURLImage(url: review.photoURL, imageAspectRatio: .fill, imageWidth: 20, imageHeight: 20, circle: true)
                            }   
                            else{
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .frame(width: 10, height: 10)
                            }

//                            if (self.reviewPhotos[review.userID] != nil){
//                                Image(uiImage: self.reviewPhotos[review.userID]!)
//                                    .resizable()
//                                    .frame(width: 20, height: 20 )
//                            }
//                            else {
//                                Image(systemName: "person.circle.fill")
//                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
//                                    .frame(width: 10, height: 10)
//                            }
                            VStack {
                                HStack {
                                    if(review.name != ""){
                                        Text("\(review.name)")
                                        .font(.system(size: 14, weight: .semibold ))
                                        .foregroundColor(.black)
                                        Spacer()
                                    }
                                    else{
                                        Text("Anonymous")
                                        .font(.system(size: 14, weight: .semibold ))
                                        .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                HStack {
                                    StarView(rating: Float(review.rating))
                                    Spacer()
                                    //current day - when posted
                                    Text("\(review.date)")
                                        .font(.system(size: 14, weight: .semibold ))
                                        .foregroundColor(.gray)
                                }
                            }
                        }.padding(.bottom, 10)
//                        .onAppear(){
//                        }
                        HStack{
                            Text(review.text)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 25)
                }
            }
            Spacer()
        }.padding()
        .onAppear(){
//            let disp = DispatchGroup()
//            for x in self.menuSelectionVM.reviews{
//                disp.enter()
//                self.menuSelectionVM.getPhoto(dispatch: disp , id: x.userID)
//                print("got")
//                disp.notify(queue: .main){
//                    print("put in: \(self.menuSelectionVM.reviewPhoto.debugDescription)")
//                    if(self.menuSelectionVM.reviewPhoto == nil){
//                        print("no photo: \(x.name)")
//                        self.reviewPhotos[x.userID] = nil
//                    }
//                    else{
//                        self.reviewPhotos[x.userID] = self.menuSelectionVM.reviewPhoto?.circle
//                        self.menuSelectionVM.reviewPhoto = nil
//                    }
//                    print("name \(x.name): size \(self.reviewPhotos.capacity)")
//                }
//            }
        }
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
            if Float(number) - rating <= 0.5 && Float(number) - rating < 1 {
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
