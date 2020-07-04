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
    let user: ARMUser
}

struct DishDetailsView: View {
    
    let dish: Dish
    
    @State var reviewsusers: [ReviewUser] = []
    
    var body: some View {
        VStack(alignment: .center) {
            Text("\(dish.name)")
                .font(.title)
            Image(uiImage: Dish.getUIImageFromCKAsset(image: dish.coverPhoto)!)
                .resizable()
                .frame(width: 330, height: 210)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            Text("Price: " + Dish.formatPrice(price: dish.price))
                .foregroundColor(.secondary)
                .font(.headline)
            Text(dish.description)
                Text("Reviews")
                    .font(.title)
            if (self.reviewsusers.count == 0) {
                Text("No reviews yet. Add yours!")
                    .frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
            } else {
                List {
                    ForEach(self.reviewsusers) {reviewuser in
                        VStack {
                            HStack {
                                if (reviewuser.user.profilePhoto == nil) {
                                    Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .aspectRatio(contentMode: .fit)
                                } else {
                                    Image(uiImage: reviewuser.user.getProfilePhoto()!)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .aspectRatio(contentMode: .fit)
                                }
                                VStack(alignment: .leading) {
                                    Text(reviewuser.user.userName)
                                    Text(reviewuser.review.headLine)
                                        .foregroundColor(.primary)
                                        .font(.headline)
                                }
                            }.frame(width: 300, height: 50, alignment: .topLeading)
                            Text(reviewuser.review.description)
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
            .padding()
            .onAppear {
                let db = DatabaseRequest()
                let reviews = db.fetchDishReviews(d: self.dish)
                
                
                for review in reviews {
                    let user = db.fetchReviewUser(review: review)
                    self.reviewsusers.append(ReviewUser(review: review, user: user))
                }
                
                print(self.reviewsusers.count)
            }
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: Dish.previewDish())
    }
}
