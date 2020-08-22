//
//  DishReviewsView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI


struct DishReviewsView: View {
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    @State var reviews: [DishReviewFB] = []
    
    @State var show = false
    @State var reviewClicked = false
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
        
    var body: some View {
        VStack{
            if self.show{
                GeometryReader{_ in
                    
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
                VStack{
//                    navigationBarTitle("Reviews")
                    Spacer().frame(height: 10)
                    Text("\(self.dish.name)'s Reviews")
                        .font(.custom("Montserrat-Bold", size: 32))
                        .bold()

                }

                Spacer().frame(height: 30)
                
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
                                            if (reviewuser.userPhotoURL == "") {
                                                Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .aspectRatio(contentMode: .fit)
                                            } else {
                                                FBURLImage(url: reviewuser.userPhotoURL)
    //                                                .resizable()
//                                                    .frame(width: 80, height: 50)
                                                    .clipShape(Circle())
                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            VStack(alignment: .leading) {
                                                Text(reviewuser.headline)
                                                    .foregroundColor(.primary)
                                                    .font(.headline)
                                                Text(reviewuser.username)
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
                    AddReviewButton().onTapGesture {
                        //go to reviews view
                        self.reviewClicked = true
                        print("Add Review")
                    }
                    Spacer().frame(height: 10)
                }
                
            }
        }
        .onAppear {
            self.show = true
            print("here at reviews")
            self.restDishVM.fetchDishReviewsFB(dishID: self.dish.key, restId: self.restaurant.key)
            self.restDishVM.dispatchGroup2.notify(queue: .main){
                print("notified")
                self.reviews = self.restDishVM.dishReviews
                self.show = false
            }
        }
        .sheet(isPresented: self.$reviewClicked){
            DishAddReview(dish: self.dish, restaurant: self.restaurant, isPresented: self.$reviewClicked)
        }
    }
}

struct DishReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        DishReviewsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
