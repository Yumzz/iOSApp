//
//  DishReviewsView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI


struct DishReviewsView: View {
    
    @State var reviews: [DishReviewFB] = [DishReviewFB]()
    
    @State var show = false
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    var body: some View {
        VStack{
            VStack{
                Text("Reviews")
            }
            VStack{
                ScrollView{
                    if (self.reviews.count == 0) {
                        Text("No reviews yet. Add yours!")
                                .frame(width: 330, height: 320, alignment: .center).cornerRadius(10)

                    } else {
                        List {
                            ForEach(self.reviews, id: \.id) {
                                reviewuser in
                                VStack {
                                    HStack {
                                        if (reviewuser.userPhoto == nil) {
                                            Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .aspectRatio(contentMode: .fit)
                                        } else {
                                            Image(uiImage: reviewuser.userPhoto!)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(reviewuser.headline)
//                                            Text(reviewuser.username)
                                                .foregroundColor(.primary)
                                                .font(.headline)
                                        }
                                    }.frame(width: 300, height: 50, alignment: .topLeading)
                                    Text(reviewuser.body)
                                        .frame(width:300, alignment:.topLeading)
                                        .font(.body)
                                }.frame(
                                    width: 300,
                                    alignment: .topLeading
                                )
                                    .cornerRadius(10)
                            }
                        }.frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
                    }
                }
            }
            if self.show{
                GeometryReader{_ in
                    
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
        }
        .onAppear {
            self.show.toggle()
            print("here at reviews")
            self.restDishVM.fetchDishReviewsFB(dishID: self.dish.key, restId: self.restaurant.key)
            self.restDishVM.fillReviewInfo()
            self.restDishVM.dispatchGroup2.notify(queue: .main){
                print("notified")
                self.reviews = self.restDishVM.dishReviewsWithPhoto
                self.show.toggle()
            }
        }
    }
}

struct DishReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        DishReviewsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
