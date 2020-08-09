//
//  DishReviewsView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishReviewsView: View {
    
    @State var reviews: [DishReviewFB]
    
    var body: some View {
        VStack{
            VStack{
                Text("Reviews")
            }
            VStack{
                ScrollView{
                    Text("No reviews yet. Add yours!")
                }
//                ScrollView{
//                    if (self.reviews.count == 0) {
//                        Text("No reviews yet. Add yours!")
//                                .frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
//
//                    } else {
//                        List {
//                            ForEach(self.reviews) {reviewuser in
//                                VStack {
//                                    HStack {
//                                        if (reviewuser.user.profilePhoto == nil) {
//                                            Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
//                                            .resizable()
//                                            .frame(width: 50, height: 50)
//                                            .aspectRatio(contentMode: .fit)
//                                        } else {
//                                            Image(uiImage: reviewuser.user.getProfilePhoto()!)
//                                                .resizable()
//                                                .frame(width: 50, height: 50)
//                                                .clipShape(Circle())
//                                                .aspectRatio(contentMode: .fit)
//                                        }
//                                        VStack(alignment: .leading) {
//                                            Text(reviewuser.user.userName)
//                                            Text(reviewuser.review.headLine)
//                                                .foregroundColor(.primary)
//                                                .font(.headline)
//                                        }
//                                    }.frame(width: 300, height: 50, alignment: .topLeading)
//                                    Text(reviewuser.review.description)
//                                        .frame(width:300, alignment:.topLeading)
//                                        .font(.body)
//                                }.frame(
//                                    width: 300,
//                                    alignment: .topLeading
//                                )
//                                    .cornerRadius(10)
//                            }
//                        }.frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
//                    }
//                }
            }
            
        }
        
    }
}

struct DishReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        DishReviewsView(reviews: [])
    }
}
