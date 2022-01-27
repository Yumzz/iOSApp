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
    @EnvironmentObject var order : OrderModel
    
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    
    @State var isNavigationBarHidden: Bool = true
    @State var dishesChosen: Bool = false
    
    @State private var reviewViewShown = false
    @State private var popUpShown = false
    
    @State private var callWaiter = false
    @State private var IoT = false
    @State private var waitButtonClicked = false
    
    var distance: Double
    
    var rating: String = "5.0"
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    init(restaurant: RestaurantFB, distance: Double) {
        print("init called: \(restaurant)")
        self.restaurant = restaurant
        self.menuSelectionVM = MenuSelectionViewModel(restaurant: self.restaurant)
        self.distance = distance
        self.rating = String(format: "%.1f", Float(self.menuSelectionVM.restaurant.ratingSum)/Float(self.menuSelectionVM.restaurant.n_Ratings))
        print("init: \(self.rating)")
    }
    
    var waitButt: some View {
        VStack{
//            EmptyView()
            if(self.dishesChosen || !self.order.buildsChosen.isEmpty){
                Spacer().frame(height: 20)
            }
            
            OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .onTapGesture {
                    self.callWaiter = true
                    self.IoT = true
                    self.waitButtonClicked = true
                }
            if(!self.dishesChosen && self.order.buildsChosen.isEmpty){
                Spacer().frame(height: 20)
            }
        }
    }
    
    var body: some View {
        ZStack{
            Color(colorScheme == .dark ? ColorManager.darkBack : #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical){
                ZStack {
                    VStack{
                        FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 375, imageHeight: 240, circle: false).edgesIgnoringSafeArea(.top)
                        Spacer()
                    }
                    VStack(spacing: 10){
//                        if (self.reviewViewShown) {
////                            #if !APPCLIP
//                            RestaurantReviewView(shown: self.$reviewViewShown, popUpShown: self.$popUpShown, menuSelectionVM: self.menuSelectionVM)
//                                .transition(.slide)
//                                .animation(.default)
////                            #endif
//                        } else {
                        VStack(alignment: .leading){
                            HStack{
                                Text(restaurant.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41).foregroundColor(colorScheme == .dark ? .white : ColorManager.textGray)
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
                                Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.distance.removeZerosFromEnd()) miles | \(self.restaurant.hour)").font(.system(size: 14, weight: .semibold)).foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)): ColorManager.textGray).tracking(-0.41)
                            }
                            
                            HStack{
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
//                                    .frame(width: 45, height: 20)
//                                    Text(String(self.rating)).foregroundColor(.white)
//                                        .font(.system(size: 12, weight: .semibold))
//                                }.frame(width: 45, height: 20)
//                                Button(action: {
////                                    #if !APPCLIP
//                                    self.reviewViewShown.toggle()
////                                    #endif
//                                }){
//                                    Text("(" + String(self.restaurant.n_Ratings) + " reviews)").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.91018188, green: 0.4465283751, blue: 0.2032583952, alpha: 1))).tracking(-0.41).underline()
//                                }
//                                Spacer()
                                
                                NavigationLink(
                                    destination: ListDishesView(restaurant: self.restaurant).navigationBarHidden(false)
                                ) {
                                    SeeMenuButton()
                                        .clipShape(RoundedRectangle(cornerRadius: 40, style: .circular))
                                        
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
                                            .frame(width: 150)
                                    }
                                    .padding()
                                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(colorScheme == .dark ? ColorManager.darkModeOrange : .white ).frame(height: 50))
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
                                                .frame(width: 80, height: 20)
                                        }
                                        .padding()
                                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(colorScheme == .dark ? ColorManager.darkModeOrange : .white).frame(height: 50))
                                    }
                                }
                                
                            }.padding(.top)
                            
                            if(!self.menuSelectionVM.featuredDishes.isEmpty){
                                VStack{
                                    HStack{
                                        Text("Popular").font(.system(size: 24, weight: .semibold)).foregroundColor(colorScheme == .dark ? .white : .black)
                                        Spacer()
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 20) {
                                        ForEach(self.menuSelectionVM.featuredDishes, id: \.id){
                                            dish in
//                                            #if !APPCLIP
                                            NavigationLink(
                                                destination: DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                            ) {
                                                PopularDishCard(dish: dish, dark: colorScheme == .dark)
                                            }
//                                            #endif
                                            
//                                            #if APPCLIP
//                                            PopularDishCard(dish: dish)
//                                            #endif
                                        }
                                    }
                                }.frame(height: 150)
                            }
                            VStack{
                                if(self.dishesChosen || !self.order.buildsChosen.isEmpty){
    //                                #if !APPCLIP
                                    NavigationLink(destination: ReviewOrder()){
                                        ViewCartButton(dishCount: self.order.allDishes)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                    }
    //                                #endif
                                }

//                                NavigationLink(destination: WaiterConnection(rest: self.order.restChosen)){
//
//                                }
                            }
                            
                            
                           
                        }.padding()
//                        }
                    }
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(
                        colorScheme == .dark ? Color(ColorManager.darkBack) : Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))))
                    .offset(y:190)
                    Spacer().frame(width: 0, height: 40)
                }
            }
            #if !APPCLIP
            if self.popUpShown {
                ZStack {
                    Color(colorScheme == .dark ? ColorManager.darkBack : #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))
                    VStack {
                        RatingView(menuSelectionVM: self.menuSelectionVM, isOpen: self.$popUpShown)
                    }.padding()
                }
                .frame(width: 329, height: 374)
                .cornerRadius(20).shadow(radius: 20)
                .transition(.slide)
                .animation(.default)
            }
            #endif
        }
        .overlay(waitButt, alignment: (self.dishesChosen || !self.order.buildsChosen.isEmpty) ? .topTrailing : .bottomLeading)
        .sheet(isPresented: self.$waitButtonClicked){
            WaiterConnection(rest: self.order.restChosen)
        }
//        .background(Color(red: 0.953, green: 0.945, blue: 0.933))
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .navigationBarItems(leading: WhiteBackButton(mode: self.mode).onTapGesture{
            print("self.mode = \(self.mode)")
        })
        .onAppear(){
            print("ask: \(self.distance)")
            self.isNavigationBarHidden = false
            self.dishesChosen = !self.order.dishesChosen.isEmpty
        }
        .onDisappear(){
            self.isNavigationBarHidden = true
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                print("self.mode = \(self.mode)")
                self.mode.wrappedValue.dismiss()
            }
        }))
        
    }
    
}

struct PopularDishCard: View {
    var dish: DishFB
    var dark: Bool = false
//    var p = ""
    var body: some View {
        VStack {
            HStack {
                FBURLImage(url: dish.coverPhotoURL, imageWidth: 175, imageHeight: 88, circle: false)
                    .frame(width: 175, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            HStack{
                Text(dish.name).foregroundColor(dark ? .white : Color.black).font(.system(size: 18, weight: .bold)).tracking(-0.41)
                Spacer()
            }
            HStack{
                if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                    if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                        Text(String(dish.price) + "00").font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                        Spacer()
                    }
                    else{
                        Text(String(dish.price) + "0").font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                        Spacer()
                    }
                }
                else{
                    Text(String(dish.price)).font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                    Spacer()
                }
                
            }
        }.frame(width: 175, height: 150)
        .padding(.leading, 5)
//        .onAppear(){
//            var oh = ""
//            if(String(dish.price).numOfNums() < 4){
//                if(String(dish.price).numOfNums() < 3){
//                    oh = String(dish.price) + "00"
//                }
//                else{
//                    oh = String(dish.price) + "0"
//                }
//            }
//            else{
//                oh = String(dish.price)
//            }
//
//        }
    }
}


struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantHomeView()
        EmptyView()
    }
}

