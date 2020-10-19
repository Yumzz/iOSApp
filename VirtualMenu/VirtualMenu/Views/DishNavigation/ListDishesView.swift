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
    
    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "")
    
    @State var dishes = [DishFB]()
    
    @State var dishCats = [DishCategory]()
    
    @State var restname = ""
    
    @State var isNavBarHidden = false
        
    @EnvironmentObject var order : OrderModel

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
            } else {
                 view
                    .navigationBarHidden(self.isNavBarHidden)
             }
        }
        .navigationBarHidden(self.isNavBarHidden)
        .onDisappear(){
            self.restname = ""
            self.isNavBarHidden = true
            
        }
        .onAppear(){
            self.isNavBarHidden = false
        }
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
                                            self.dishCategoryClicked = DishCategory(isExpanded: false, dishes: [], name: "")
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
                        VStack(alignment: .leading, spacing: 40) {
                            
                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            
                            VStack(spacing: 20){
                                
                                ForEach(dishCategory.dishes, id: \.id) {
                                    dish in
                                    NavigationLink(destination:
                                        DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                    ) {

                                        DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 80, imageHeight: 80), dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), rest: self.restaurant, dish: dish)
                                            
                                    }
                                }
                                Spacer().frame(height: 20)
                            }
                        }.id(self.dishCats.firstIndex(of: dishCategory))
                    }
                    Spacer()
                }
                }
            }
                .frame(maxWidth: .infinity)
            }
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                self.dishCats = self.listDishVM.dishCategories
                self.restname = self.restaurant.name
                self.isNavBarHidden = false
//                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
//                    self.showingAlert.toggle()
//                }
            }
        }
        .navigationBarTitle("\(self.restname)")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavBarHidden)
        .navigationBarItems(leading: BackButton(mode: self.mode))
//        .onDisappear(){
//            self.restname = ""
//            self.isNavBarHidden = true
//        }
//        .alert(isPresented: $showingAlert){
//            print("added")
//            return Alert(title: Text("Added"))
//        }

    }
}


struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView(restaurant:  RestaurantFB.previewRest())
        }

    }
}
