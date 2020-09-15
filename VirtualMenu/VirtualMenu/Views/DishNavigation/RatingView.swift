//
//  RatingView.swift
//  VirtualMenu
//
//  Created by William Bai on 9/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct RatingView: View {
    var restaurant: RestaurantFB
    @Environment(\.presentationMode) var presentation
    @Binding var isOpen: Bool
    @State var rating: Int = 0
    
    func submitRating() {
        let db = Firestore.firestore()
        db.collection("Restaurant").document(self.restaurant.key).updateData([
            "RatingSum": FieldValue.increment(Int64(self.rating)),
            "N_Ratings": FieldValue.increment(Int64(1))
        ]) {(err) in
            if let err = err {
                print(err.localizedDescription)
            }
            print("Rating Successfully submitted")
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            FBURLImage(url: self.restaurant.coverPhotoURL, imageWidth: 220, imageHeight: 160)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            HStack{
                Text(self.restaurant.name)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.custom("Montserrat", size: 26))
            }.frame(alignment: .center)
            Text(self.restaurant.ethnicity)
                .foregroundColor(Color.secondary)
                .font(.footnote)
            Divider()
            StarRatingView(rating: $rating).padding()
            Button(action: {
                self.submitRating()
                self.isOpen = false
            }) {
                VStack {
                    Text("Submit")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                }
                .padding()
                .foregroundColor(.red)
                .background(Color.white)
                .cornerRadius(30)
            }
            Spacer()
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var fontSize: CGFloat = 30
    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .font(.system(size: self.fontSize))
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
}
