//
//  RestaurantHomeView.swift
//  VirtualMenu
//
//  Created by Sally Gao on 10/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

struct RestaurantHomeView: View {
    var restaurant: RestaurantFB
    
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var order : OrderModel
    
    @State var isNavigationBarHidden: Bool = true
    @State var dishesChosen: Bool = false
    
    @State private var reviewViewShown = false
    
    var distance: Double
    
    var rating: Float

    
    init(restaurant: RestaurantFB, distance: Double) {
        self.restaurant = restaurant
        self.menuSelectionVM = MenuSelectionViewModel(restaurant: self.restaurant)
        self.distance = distance
        self.rating = Float(self.restaurant.ratingSum) / Float(self.restaurant.n_Ratings)
    }
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).ignoresSafeArea(.all)
            ScrollView(.vertical){
                ZStack {
                    VStack{
                        FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 375, imageHeight: 240).edgesIgnoringSafeArea(.top)
                        Spacer()
                    }
                    VStack(spacing: 10){
                        if (self.reviewViewShown) {
                            RestaurantReviewView(shown: self.$reviewViewShown, menuSelectionVM: self.menuSelectionVM)
                                .transition(.slide)
                                .animation(.default)
                        } else {
                        VStack(alignment: .leading){
                            HStack{
                                Text(restaurant.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41)
                                Spacer()
//                                Button(action: {
//                                    
//                                }) {
//                                    HStack {
//                                        Image(systemName: "qrcode.viewfinder")
//                                            .font(.system(size: 18, weight: .bold))
//                                    }
//                                    .padding()
//                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
//                                    .background(Color.white)
//                                    .cornerRadius(5)
//                                }
                            }
                            HStack{
                                Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.distance.removeZerosFromEnd()) miles | \(self.restaurant.hour)").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.77, green: 0.77, blue: 0.77, alpha: 1))).tracking(-0.41)
                            }
                            
                            HStack{
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
                                    .frame(width: 45, height: 20)
                                    Text(String(self.rating)).foregroundColor(.white)
                                        .font(.system(size: 12, weight: .semibold))
                                }.frame(width: 45, height: 20)
                                Button(action: {
                                    self.reviewViewShown.toggle()
                                }){
                                    Text("(" + String(self.restaurant.n_Ratings) + " reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41).underline()
                                }
                                Spacer()
                                
                                NavigationLink(
                                    destination: ListDishesView(restaurant: self.restaurant).navigationBarHidden(false)
                                ) {
                                    SeeMenuButton()
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                }
                            }

                            HStack(spacing: 10){
                                Button(action: {
                                    guard let number = URL(string: "tel://" + restaurant.phone) else { return }
                                UIApplication.shared.open(number)
                                }) {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 18, weight: .bold))
                                        Text("Call Restaurant")
                                            .font(.system(size: 18,weight: .bold))
                                            .font(.footnote)
                                            .frame(width: 150)
                                    }
                                    .padding()
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color.white).frame(height: 50))
                                }
                                Spacer()
                                HStack{
                                    Button(action: {
                                        let regionDistance:CLLocationDistance = 10000
                                        let coordinates = CLLocationCoordinate2DMake(restaurant.coordinate.latitude, restaurant.coordinate.longitude)
                                        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                                        let options = [
                                            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                                            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                                        ]
                                        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                                        let mapItem = MKMapItem(placemark: placemark)
                                        mapItem.name=restaurant.name
                                        mapItem.openInMaps(launchOptions: options)
                                    }) {
                                        VStack {
                                            Image(systemName: "arrow.uturn.right")
                                                .font(.system(size: 18))
                                            Text("Direction")
                                                .fontWeight(.bold)
                                                .font(.system(size: 18, weight: .bold))
                                                .frame(width: 50, height: 20)
                                        }
                                        .padding()
                                        .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color.white).frame(height: 50))
                                    }
                                }
                                
                            }.padding(.top)
                            
                            VStack{
                                HStack{
                                    Text("Popular").font(.system(size: 24, weight: .semibold))
                                    Spacer()
                                }
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach(self.menuSelectionVM.featuredDishes, id: \.id){
                                        dish in
                                        NavigationLink(
                                            destination: DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                        ) {
                                            PopularDishCard(dish: dish)
                                        }
                                    }
                                }
                            }.frame(height: 150)
                            
                            if(self.dishesChosen){
                                NavigationLink(destination: ReviewOrder()){
                                    ViewCartButton(dishCount: self.order.dishesChosen.count)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                }
                            }
                           
                        }.padding()
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))))
                    .offset(y:190)
                    Spacer().frame(width: 0, height: 40)
                }
            }
        }
//        .background(Color(red: 0.953, green: 0.945, blue: 0.933))
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarItems(leading: WhiteBackButton(mode: self.presentationMode))
        .onAppear(){
            self.isNavigationBarHidden = false
            self.dishesChosen = !self.order.dishesChosen.isEmpty
        }
        .onDisappear(){
            self.isNavigationBarHidden = true
        }
    }
    
}

struct PopularDishCard: View {
    var dish: DishFB
    
    var body: some View {
        VStack {
            HStack {
                FBURLImage(url: dish.coverPhotoURL, imageWidth: 175, imageHeight: 88)
                    .frame(width: 175, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            HStack{
                Text(dish.name).foregroundColor(Color.black).font(.system(size: 18, weight: .bold)).tracking(-0.41)
                Spacer()
            }
            HStack{
                Text(String(dish.price)).font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                Spacer()
            }
        }.frame(width: 175, height: 150)
        .padding(.leading, 5)
    }
}


struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantHomeView()
        EmptyView()
    }
}

