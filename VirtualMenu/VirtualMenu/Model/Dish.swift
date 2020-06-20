//
//  Dish.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/8/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class Dish: Identifiable {
    
    static let recordType = "Dish"
    let id = UUID()
    let ckId: CKRecord.ID
    let name: String
    let description: String
    let price: Double
    let type: String
    let coverPhoto: CKAsset?
    let photos: [CKAsset]?
    let database: CKDatabase
    var restaurant: CKRecord.Reference? = nil
    var model: CKRecord.Reference? = nil
    var reviews: [CKRecord.Reference]? = nil
    
    init?(record: CKRecord, database: CKDatabase) {
        guard
            let name = record["Name"] as? String
            else { return nil }
        ckId = record.recordID
        self.name = name
        self.database = database
        description = record["Description"] as? String ?? ""
        price = record["Price"] as? Double ?? 0
        type = record["Type"] as? String ?? ""
        coverPhoto = record["CoverPhoto"] as? CKAsset
        photos = record["Photos"] as? [CKAsset]
        
        restaurant = record["Restaurant"] as? CKRecord.Reference
        model = record["Model"] as? CKRecord.Reference
        reviews = record["Reviews"] as? [CKRecord.Reference]
    }
    
}

extension Dish: Hashable {
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func previewDish() -> Dish {
        let dbb = DatabaseRequest()
        let restaurant2 = dbb.fetchRestaurantWithID(id: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
        let fetchDishes = dbb.fetchRestaurantDishes(res: restaurant2)
        return fetchDishes[0]
    }
    
    static func getUIImageFromCKAsset(image: CKAsset?) -> UIImage? {
        let file: CKAsset? = image
        let data = NSData(contentsOf: (file?.fileURL!)!)
        
        return UIImage(data: data! as Data) ?? nil
    }
    
    static func formatPrice(price: Double) -> String {
        return "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
    }
}
