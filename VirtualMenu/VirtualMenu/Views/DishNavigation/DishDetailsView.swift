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
    
    @State var count: Int = 1
    
    @EnvironmentObject var order : OrderModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var addtapped = false
    @State var isNavigationBarHidden: Bool = true
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).ignoresSafeArea(.all)
            ScrollView(.vertical){
                ZStack {
                    VStack{
                        FBURLImage(url:  dish.coverPhotoURL, imageWidth: 375, imageHeight: 240)
                        Spacer()
                    }
                    VStack(spacing: 0){
                        VStack{
                            HStack{
                                Text(dish.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41)
                                Spacer()
                                
                            }
                            HStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
                                    .overlay(Text("4.5"))
                                    
                                .frame(width: 45, height: 20)
                                Text("(298 reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41)
                                Spacer()
                            }
                            HStack{
                                Text("\(dish.description)").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)

                                Spacer()
                            }
                           
                        }.padding()
                        Spacer()
                        //options
                        if(!dish.options.isEmpty){
                            VStack(spacing: 0){
                                HStack{
                                    Text("Options")
                                        .font(.system(size: 24))
                                }
                                VStack{
                                    OptionsCard(options: dish.options, exclusive: dish.exclusive, dish: dish)
                                }
                            }
                        }
                        if(!dish.buildOpts.isEmpty){
                            HStack{
                                Text("Build Your Own")
                                    .font(.system(size: 24))
                            }
                            VStack{
                                BuildCard(buildPrices: dish.buildPrice, typetoOpts: dish.buildOpts, exclusive: dish.buildExclusive, dish: dish)
                            }
                            
                        }
                        HStack{
                            HStack{
                                Image(systemName: "minus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .onTapGesture {
                                        print("tapped")
                                        if(self.count > 1){
                                            self.count -= 1
                                        }
                                    }
                                Text("\(self.count)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .font(.footnote)
                                    .foregroundColor(Color.black)
                                    .frame(width: 30)
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .onTapGesture {
                                        self.count = self.count + 1
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: 122, height: 48)
//                            NavigationLink(destination: ReviewOrder()){

                                HStack{
                                    Text("$\(dish.price.removeZerosFromEnd())")
                                        .font(.system(size: 16, weight: .semibold))
                                        .font(.footnote)
                                        .frame(width: 100)
//                                    Image(systemName: "cart.fill.badge.plus")
//                                        .font(.system(size: 18))
                                    Text("Add to Cart")
                                        .font(.system(size: 16, weight: .semibold))
                                        .font(.footnote)
                                        .frame(width: 100)
                                }
                                .padding()
                                .foregroundColor(Color.white)
                                .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                .cornerRadius(10)
                                .scaledToFit()
//                                .frame(width: UIScreen.main.bounds.width/2, height: 48)
                                .onTapGesture {
                                    print("here")
                                    var i = 0
                                    while i < self.count{
                                        let d = DispatchGroup()
                                        d.enter()
                                        self.order.addDish(dish: self.dish, rest: self.restaurant, dis: d)
                                        i += 1
                                    }
                                    self.addtapped = true
                                }
                            
                        }
//                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))))
                    .offset(y:200)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarItems(leading: WhiteBackButton(mode: self.presentationMode))
            .onAppear(){
                self.isNavigationBarHidden = false
            }
            .onDisappear(){
                self.isNavigationBarHidden = true
            }
        .alert(isPresented: self.$addtapped){
            print("added")
//            self.addtapped = false
            
            return Alert(title: Text("Dish Added"))
        }
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
