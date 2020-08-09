//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by William Bai on 6/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct ReviewUser: Identifiable {
    let id = UUID()
    let review: Review
    let user: UserProfile
}

struct DishDetailsView: View {
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()

    @State var reviews: [DishReviewFB] = []
    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        VStack(alignment: .center) {
            VStack{
                Text("\(dish.name)")
                    .font(.title)
                Image(uiImage: dish.coverPhoto!)
                    .resizable()
                    .frame(width: 330, height: 210)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                Text("Price: " + DishFB.formatPrice(price: dish.price))
                    .foregroundColor(.secondary)
                    .font(.headline)
                Text(dish.description)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 0)
                OrderButton().onTapGesture {
                    //send info to POS
                    print("order tapped")
                }
                ReviewsButton().onTapGesture {
                    //go to reviews view
                    print("review: \(self.reviews[0])")
                }
                
//                ReviewsButton().onTapGesture{
//
//
//
//                }
            
//            Text("Reviews")
//                    .font(.title)
        }
//        ScrollView{
//            if (self.reviewsusers.count == 0) {
//                Text("No reviews yet. Add yours!")
//                        .frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
            
//            } else {
//                List {
//                    ForEach(self.reviewsusers) {reviewuser in
//                        VStack {
//                            HStack {
//                                if (reviewuser.user.profilePhoto == nil) {
//                                    Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
//                                    .resizable()
//                                    .frame(width: 50, height: 50)
//                                    .aspectRatio(contentMode: .fit)
//                                } else {
//                                    Image(uiImage: reviewuser.user.getProfilePhoto()!)
//                                        .resizable()
//                                        .frame(width: 50, height: 50)
//                                        .clipShape(Circle())
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                VStack(alignment: .leading) {
//                                    Text(reviewuser.user.userName)
//                                    Text(reviewuser.review.headLine)
//                                        .foregroundColor(.primary)
//                                        .font(.headline)
//                                }
//                            }.frame(width: 300, height: 50, alignment: .topLeading)
//                            Text(reviewuser.review.description)
//                                .frame(width:300, alignment:.topLeading)
//                                .font(.body)
//                        }.frame(
//                            width: 300,
//                            alignment: .topLeading
//                        )
//                            .cornerRadius(10)
//                    }
//                }.frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
//            }
//        }
        }
            .padding()
            .onAppear {
                
                self.restDishVM.fetchDishReviewsFB(dName: self.dish.name, rName: self.restaurant.name)
                self.reviews = self.restDishVM.dishReviews
                
            }
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
