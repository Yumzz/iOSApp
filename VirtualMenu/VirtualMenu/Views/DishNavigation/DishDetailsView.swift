//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by Sally Gao on 10/12/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

//struct ReviewUser: Identifiable {
//    let id = UUID()
//    let review: Review
//    let user: UserProfile
//}

struct DishDetailsView: View {
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @EnvironmentObject var order : OrderModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 10){
                    ZStack{
                        FBURLImage(url: dish.coverPhotoURL, imageWidth: 375, imageHeight: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                }) {
                            Image(systemName: "arrow.left").foregroundColor(.black)
                        }
                    }
                    Spacer()
                    ScrollView{
                        VStack{
                            HStack{
                                Text(dish.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41).padding(.leading, 40)
                                Spacer()
                                
                            }
                            HStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
                                .frame(width: 45, height: 20)
                                    .padding(.leading,40)
                                Text("(298 reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41)
                                Spacer()
                            }
                            HStack{
                                Text("Salmon, Rice, soy sauce, wasabi, sesame seeds").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41).padding(.leading, 40)
                                Spacer()
                            }
                           
                        }.padding()
                        Spacer()
                        HStack{
                            HStack{
                                Image(systemName: "minus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                Text("1")
                                    .font(.system(size: 16, weight: .semibold))
                                    .font(.footnote)
                                    .foregroundColor(Color.black)
                                    .frame(width: 30)
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: 122, height: 48)
                            HStack{
                                Text("$17")
                                    .font(.system(size: 16, weight: .semibold))
                                    .font(.footnote)
                                    .frame(width: 40)
                                Image(systemName: "cart.fill.badge.plus")
                                    .font(.system(size: 18))
                                Text("Add to Cart")
                                    .font(.system(size: 16, weight: .semibold))
                                    .font(.footnote)
                                    .frame(width: 100)
                            }
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                            .cornerRadius(10)
                            .frame(width: 195, height: 48)
                        }
                    }
                }
            }
        }
        .background(Color(red: 0.953, green: 0.945, blue: 0.933))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
