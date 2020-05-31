//
//  Model.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/9/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit

class Model {
  
  static let recordType = "Model"
  private let id: CKRecord.ID
  let modelMesh: CKAsset?
  var user: CKRecord.Reference? = nil
  var dish: CKRecord.Reference? = nil

  init?(record: CKRecord, database: CKDatabase) {
    id = record.recordID
    modelMesh = record["ModelMesh"] as? CKAsset

    user = record["User"] as? CKRecord.Reference
    dish = record["Dish"] as? CKRecord.Reference

  }
  
}

extension Model: Hashable {
  static func == (lhs: Model, rhs: Model) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
