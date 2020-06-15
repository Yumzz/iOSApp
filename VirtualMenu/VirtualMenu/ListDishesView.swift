//
//  ListDishesView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 10/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit


struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
}

class ListDishesViewModel: ObservableObject {
    
    @Published var dishes = [Dish]()
    
    @Published var courses : [Course] = [
        .init(name: "Bla"),
        .init(name: "Bla Bla")
    ]
    
    @Published var restaurant2 : Restaurant? = nil
    
    let dbb = DatabaseRequest()
    
    func fetchDishes(){
        var fetchDishes = [Dish]()
        
        DispatchQueue.main.async {
            self.restaurant2 = self.dbb.fetchRestaurantWithID(id: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
            print((self.restaurant2?.name ?? "nil") as String)
            fetchDishes = self.dbb.fetchRestaurantDishes(res: self.restaurant2!)
            self.dishes = fetchDishes
            print(self.dishes)
            self.dishes.sort {
                $0.name < $1.name
            }
        }
    }
    
    func formatPrice(price: Double) -> String {
        return "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
    }
    
    func getUIImageFromCKAsset(image: CKAsset?) -> UIImage? {
        let file: CKAsset? = image
        let data = NSData(contentsOf: (file?.fileURL!)!)
        
        return UIImage(data: data! as Data) ?? nil
    }
}

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
                        VStack(alignment: .leading) {
                            Image(uiImage: self.listDishesVM.getUIImageFromCKAsset(image: dish.coverPhoto)!)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .aspectRatio(contentMode: .fit)
                            Text("Details for \(dish.name)")
                        }
                        
                    ) {
                        HStack {
                            Image(uiImage: self.listDishesVM.getUIImageFromCKAsset(image: dish.coverPhoto)!)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .aspectRatio(contentMode: .fit)
                            
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
            .navigationBarItems(trailing: Button(action: {
                self.listDishesVM.fetchDishes()
                print(self.listDishesVM.$dishes)
            }, label: {
                Text("Fetch Data")
                
            }))
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
