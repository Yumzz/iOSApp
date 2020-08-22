//
//  DishAddReview.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/17/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishAddReview: View {
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @State var headline: String = ""
    @State var description: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State var show = false
    
    @Binding var isPresented: Bool
    @ObservedObject var FirebaseFunctions = FirebaseFunctionsViewModel()
    
    var body: some View {
        VStack{
            if self.show{
                GeometryReader{_ in
                    
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
                VStack{
                    Spacer().frame(height: 10)
                    Text("Add A Review")
                        .font(.custom("Montserrat-Bold", size: 48))
                        .bold()
                }
                Spacer()
                VStack (alignment: .leading) {
                    Text("Title of Review")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    TextField("Headline", text: $headline)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading) {
                    Text("How'd you like the dish?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                Spacer()
                PostReviewButton().onTapGesture{
                    self.show = true
                    let results = self.FirebaseFunctions.addReview(headline: self.headline, body: self.description, dish: self.dish, rest: self.restaurant, starRating: 5, userID: userProfile.userId, username: userProfile.fullName)
                    let result = results[0]
                    let title = results[1]
                    if(result == ""){
                        self.show = false
                        self.isPresented = false
                        return
                    }
                    else{
                        print("did not add review")
                        self.alertTitle = title
                        self.alertMessage = result
                        self.showingAlert.toggle()
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
        }
    }
}

struct DishAddReview_Previews: PreviewProvider {
    static var previews: some View {
        DishAddReview(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest(), isPresented: .constant(true))
    }
}
