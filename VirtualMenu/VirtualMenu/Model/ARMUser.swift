//
//  ARMUser.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/10/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit

class ARMUser {
  
  static let recordType = "Model"
  private let id: CKRecord.ID
  let userName: String
  let cloudIdentifier: String
  let karma: Int64
  let profilePhoto: CKAsset?
  var modelUploaded: [CKRecord.Reference]? = nil
  var reviews: [CKRecord.Reference]? = nil

  init?(record: CKRecord, database: CKDatabase) {
    id = record.recordID
    
    userName = record["UserName"] as? String ?? ""
    cloudIdentifier = record["CloudIdentifier"] as? String ?? ""
    karma = record["Karma"] as? Int64 ?? 0
    profilePhoto = record["ProfilePhoto"] as? CKAsset
    
    modelUploaded = record["User"] as? [CKRecord.Reference]
    reviews = record["Dish"] as? [CKRecord.Reference]
  }
  
}

extension ARMUser: Hashable {
  static func == (lhs: ARMUser, rhs: ARMUser) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
