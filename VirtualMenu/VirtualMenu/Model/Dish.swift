//
//  Dish.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/8/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit

class Dish {
  
  static let recordType = "Dish"
  let id: CKRecord.ID
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
    id = record.recordID
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
}
