//
//  ListDishesView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 10/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit

struct ListDishesView: View {
    
    @ObservedObject var listDishesVM = ListDishesViewModel()
    
    var body: some View {
        GeometryReader { geometryProxy in
            List {
                
                Button(action: {
                    print(self.listDishesVM.dishes)
                }, label: {
                    Text("Print dishes")
                })
                ForEach(self.listDishesVM.dishes) {
                    dish in
                    NavigationLink(destination:
                        DishDetailsView(dish: dish)
                    ) {
                        HStack {
                            Image(uiImage: self.listDishesVM.getUIImageFromCKAsset(image: dish.coverPhoto)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .layoutPriority(-1)
                                .frame(width: 100, height: 100)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(dish.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(self.listDishesVM.formatPrice(price: dish.price))
                                    .foregroundColor(.secondary)
                            }
                            
                        }.frame(
                            width: geometryProxy.size.width - 16,
                            alignment: .topLeading
                        )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
                        )
                    }
                }
            }
        }.navigationBarTitle("Dishes")
            .navigationBarItems(trailing:
                NavigationLink(destination: AccountProfileView()){
                    Text("Edit Account Profile")
                    //make this into profile pic in corner
            })
            .padding(.trailing)
            .onAppear { UITableView.appearance().separatorStyle = .none
                if self.listDishesVM.dishes.isEmpty {
                    self.listDishesVM.fetchDishes()
                }
        }
    }
}

struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView()
        }
        
    }
}
