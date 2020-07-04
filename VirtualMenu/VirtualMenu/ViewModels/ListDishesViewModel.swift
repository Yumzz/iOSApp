//
//  ListDishesViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit

class ListDishesViewModel: ObservableObject {
    
    @Published var dishes = [Dish]()
    
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
