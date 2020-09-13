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

    @State var review: String = ""
    @Binding var isPresented: Bool
    @State private var textStyle = UIFont.TextStyle.body
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @ObservedObject var dishReviewVM = DishReviewsViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    let dish: DishFB
    
    let restaurant: RestaurantFB
        
    var body: some View {
        ZStack{
        VStack{
            if self.show{
                GeometryReader{_ in
                    
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
                HStack{
                    FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 200, imageHeight: 100, owndimen: true)
                        .cornerRadius(10)
                    Text("\(self.dish.name)")
                        .font(.custom("Open Sans", size: 32))
                }

                Spacer().frame(height: 30)
                
                VStack{
                    ScrollView{
                        if (self.reviews.count == 0) {
                            Text("No reviews yet. Add yours!")
                                    .frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
                        } else {
                            ScrollView {
                                ForEach(self.reviews, id: \.id) {
                                    reviewuser in
                                    VStack {

                                            if(reviewuser.userPhotoURL == ""){
                                                ReviewCard(urlImage: nil, review: reviewuser.body)
                                            }
                                            else{
                                                ReviewCard(urlImage: FBURLImage(url: reviewuser.userPhotoURL, imageAspectRatio: .fill), review: reviewuser.body)
                                            }
                                    }
                                    .frame(
                                        width: 300,
                                        alignment: .topLeading
                                    )
                                        .cornerRadius(10)
                                }
                            }.frame(width: 330, height: 320, alignment: .center).cornerRadius(10)
                            
                        }
                    }
                    HStack{
                        DishNavButton(strLabel: "Submit a Review").onTapGesture{
                            self.reviewClicked = true
                        }
                    }.overlay(BottomSheetModal(display: self.$reviewClicked, backgroundColor: .constant(Color(UIColor().colorFromHex("#FFFFFF", 1))), rectangleColor: .constant(Color(UIColor().colorFromHex("#656565", 1)))) {
                                ZStack{
                                    VStack(spacing: 20) {
                                        HStack{
                                            Text("Write your review:")
                                            .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
                                            Spacer()
                                        }

                                        TextView(text: self.$review, textStyle: self.$textStyle)
                                        .padding(.horizontal)
                                        

                    //                        VStack(alignment: .leading){
                                        HStack{
                                            Spacer().frame(width: UIScreen.main.bounds.width/3)
                                            PostReviewButton().onTapGesture {
                                                self.show = true
                                                let results = self.dishReviewVM.addReview(body: self.review, dish: self.dish, rest: self.restaurant, starRating: 5, userID: userProfile.userId, username: userProfile.fullName)
                                                let result = results[0]
                                                let title = results[1]
                                                if(result == ""){
                                                    print("here: ")
                                                    self.alertTitle = "Review Sent"
                                                    self.alertMessage = "Review has been updated"
                                                    self.showingAlert.toggle()
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
                        //                    .frame(width: UIScreen.main.bounds.width/6, height: 40, alignment: .trailing)
                                            .alert(isPresented: self.$showingAlert) {
                                                Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                                            }
                                        }
                    //                        }
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                    }
                                    }
                                }
                            )

                    
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 25)
                }
                
            }
        }.onAppear {
            self.show = true
            self.restDishVM.fetchDishReviewsFB(dishID: self.dish.key, restId: self.restaurant.key)
            self.restDishVM.dispatchGroup2.notify(queue: .main){
                self.reviews = self.restDishVM.dishReviews
                self.restDishVM.resetReviews()
                self.show = false
            }
        }
            
        }.background(GradientView().edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
        
    }
}

struct DishReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        DishReviewsView(isPresented: .constant(true), dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}


