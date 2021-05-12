//
//  ListDishesView.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct ListDishesView: View {
        
    var restaurant: RestaurantFB
    
    @ObservedObject var listDishVM: ListDishesViewModel
            
    @State var isLoading = false
    
    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
        
    @State var builds = [BuildFB]()
    
    @State var dishCats = [DishCategory]()
    
    @State var restname = ""
     
    @State var addtapped = false
    @State var addWOSize = false
    @State var showingAlert = false
    @State var isNavBarHidden = false
            

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
                 view
                    .navigationBarHidden(self.isNavBarHidden)
        }
        .navigationBarHidden(self.isNavBarHidden)
    }

    
    
    var view: some View {
//        EmptyView()
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                ScrollViewReader{ scrollView in
//                VStack {
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
                                            scrollView.scrollTo(self.dishCats.firstIndex(of: dishCategory), anchor: .top)
                                        }
                                    }
                                }

                            }

                    }
////
                    Spacer().frame(height: 20)
////
                    ForEach(self.dishCats, id: \.name){ dishCategory in
                        VStack(alignment: .leading, spacing: 20) {
//
                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
////
                            if(dishCategory.description != ""){
                                Text("\(dishCategory.description)")
                                    .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                            }
//////
                            VStack(spacing: 20){
                                if dishCategory.dishes.isEmpty {
                                    ForEach(dishCategory.builds, id: \.id) {
                                        build in
                                        Text("\(build.name)")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .padding(.leading)
                                        Text("\(build.description)")
                                            .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                                        BuildCard(build: build, rest: self.restaurant)
                                    }
                                    Spacer().frame(height: 20)
                                }
                                ForEach(dishCategory.dishes, id: \.id) {
                                    dish in
                                    Text(dish.name)
                                    DishCard(dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), singPrice: dish.options.isEmpty, rest: self.restaurant, dish: dish)
                                }
                                Spacer().frame(height: 20)
                            }
                        }.id(self.dishCats.firstIndex(of: dishCategory))
                    }
                    Spacer()
//                }
                }
            }.navigationBarTitleDisplayMode(self.addtapped ? .inline : .automatic)
                .frame(maxWidth: .infinity)
            }
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                self.dishCats = self.listDishVM.dishCategories
                self.builds = self.restaurant.builds!
                //must make build for each under build category
                self.restname = self.restaurant.name
                self.isNavBarHidden = false
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
                    print("added")
                    self.addWOSize = Notification.object! as! Bool
                    self.addtapped = true
                }
                self.addWOSize = false
                self.addtapped = false
            }
        }
        .navigationBarTitle("\(self.restname)")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavBarHidden)
        .onDisappear(){
            self.restname = ""
            self.isNavBarHidden = true
        }
        .alert(isPresented: self.$addtapped){
            print("added")
            if(self.addWOSize){
                return Alert(title: Text("Dish Added"))
            }
            else{
                return Alert(title: Text("Please choose Size"))
            }
        }
        .gesture(
            DragGesture().updating($dragOffset, body: { (value, state, transaction) in
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
