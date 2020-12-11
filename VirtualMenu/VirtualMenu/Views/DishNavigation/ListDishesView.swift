//
//  ListDishesView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 10/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct ListDishesView: View {
        
    var restaurant: RestaurantFB
    
    @ObservedObject var listDishVM: ListDishesViewModel
            
    @State var isLoading = false
    
    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
        
    @State var builds = [BuildFB]()
    
    @State var dishCats = [DishCategory]()
    
    @State var restname = ""
     
    @State var addtapped = false
    @State var showingAlert = false
    @State var isNavBarHidden = false
        
    @EnvironmentObject var order : OrderModel

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    let dispatchGroup = DispatchGroup()

    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        print("List Dish Vm created")
        
        
        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant, dispatch: dispatchGroup)
        
    }
    
    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty){
                view.overlay(overlay, alignment: .bottom)
                    .navigationBarTitle("\(self.restname)")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: BackButton(mode: self.mode))
                    .navigationBarHidden(self.isNavBarHidden)
                    .onAppear(){
//                        self.order.addtapped = true
                        
                    }
                    .onDisappear(){
                        print("disappear")
                        self.restname = ""
                        self.isNavBarHidden = true
                        self.addtapped = false
                        print("disappear, restname: \(self.restname), navbarhidden: \(self.isNavBarHidden)")
                    }
            } else {
                 view
                    .navigationBarHidden(self.isNavBarHidden)
             }
        }
        .navigationBarHidden(self.isNavBarHidden)
    }
    
    var overlay: some View {
        VStack{
            NavigationLink(destination: ReviewOrder().navigationTitle("").navigationBarHidden(true)){
                ViewCartButton(dishCount: self.order.allDishes)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            Spacer().frame(width: 0, height: 10)
        }
    }
    
    var view: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                ScrollViewReader{ scrollView in
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            ForEach(self.dishCats, id: \.name){ dishCategory in
                                Text("\(dishCategory.name)")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 12))
                                    .scaledToFit()
                                    .background((self.dishCategoryClicked == dishCategory) ?
                                                    ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) : ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
                                    .foregroundColor((self.dishCategoryClicked == dishCategory) ?
                                                        Color(UIColor().colorFromHex("#FFFFFF", 1)) : ColorManager.textGray)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if((self.dishCategoryClicked == dishCategory)){
                                            self.dishCategoryClicked = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
                                        }
                                        else{
                                            self.dishCategoryClicked = dishCategory
                                            print(self.dishCats.firstIndex(of: dishCategory))
                                            scrollView.scrollTo(self.dishCats.firstIndex(of: dishCategory), anchor: .top)
                                        }
                                    }
                                }
                                    
                            }
                        
                    }
                    
                    Spacer().frame(height: 20)
                    
                    ForEach(self.dishCats, id: \.name){ dishCategory in
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            
                            if(dishCategory.description != ""){
                                Text("\(dishCategory.description)")
                                    .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                            }
                            
                            VStack(spacing: 20){
                                if dishCategory.dishes == nil {
                                    ForEach(dishCategory.builds, id: \.id) {
                                        build in
//                                        NavigationLink(destination:
//                                            DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
//                                        ) {
//
//                                            DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 80, imageHeight: 80), dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), rest: self.restaurant, dish: dish)
//
//                                        }
                                    }
                                    Spacer().frame(height: 20)
                                }
                                else {
                                    ForEach(dishCategory.dishes, id: \.id) {
                                        dish in
                                        NavigationLink(destination:
                                            DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                        ) {

                                            DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 80, imageHeight: 80, circle: false), dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), rest: self.restaurant, dish: dish)
                                                
                                        }
                                    }
                                    Spacer().frame(height: 20)
                                }
                            }
                        }.id(self.dishCats.firstIndex(of: dishCategory))
                    }
                    Spacer()
                }
                }
            }.navigationBarTitleDisplayMode(self.addtapped ? .inline : .automatic)
                .frame(maxWidth: .infinity)
            }
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                self.dishCats = self.listDishVM.dishCategories
                self.builds = self.listDishVM.builds
                //must make build for each under build category
                self.restname = self.restaurant.name
                self.isNavBarHidden = false
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
                    self.addtapped = true
                }
                self.addtapped = false
            }
        }
        .navigationBarTitle("\(self.restname)")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavBarHidden)
        .navigationBarItems(leading: BackButton(mode: self.mode))
        .onDisappear(){
            self.restname = ""
            self.isNavBarHidden = true
        }
        
        .alert(isPresented: self.$addtapped){
            print("added")
//            self.addtapped = false
            
            return Alert(title: Text("Dish Added"))
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
        
    }
}


struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView(restaurant:  RestaurantFB.previewRest())
        }

    }
}
