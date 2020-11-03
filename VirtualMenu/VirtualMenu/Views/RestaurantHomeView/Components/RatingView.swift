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
    @State var reviewText: String = ""
    @State var textStyle: UIFont.TextStyle = UIFont.TextStyle.body
    
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
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).ignoresSafeArea(.all)
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Button(action:{
                        self.isOpen = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                HStack {
                    if (userProfile.profilePhoto == nil){
                    Image(systemName: "person.crop.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    else{
                        Image(uiImage: userProfile.profilePhoto!.circle!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Text("USERNAME")
                    Spacer()
                }
                HStack{
                    StarRatingView(rating: $rating)
                    Spacer()
                }
                TextView(text: self.$reviewText, textStyle: self.$textStyle)
                    .cornerRadius(20)
                    .border(Color.gray, width: 0.5)
                    
                HStack {
                    Spacer()
                    Button(action: {
                        self.isOpen = false
                    }) {
                        VStack {
                            Text ("Cancel")
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                        }
                        .padding()
                        .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white).frame(width: 90, height: 30))
                    }
                    Button(action: {
                        self.submitRating()
                        self.isOpen = false
                    }) {
                        VStack {
                            Text("Post")
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1))).frame(width: 90, height: 30))
                        .frame(width: 100, height: 30)
                    }
                }
                Spacer()
            }.padding()
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var fontSize: CGFloat = 30
    var label = ""

    var maximumRating = 5

    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.yellow
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
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
