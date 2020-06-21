//
//  Review.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/9/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit

class Review: Identifiable {
    
  let id = UUID()
  static let recordType = "Model"
  private let ckid: CKRecord.ID
  let headLine: String
  let description: String
  let time: NSDate
  var userID: String
  var restaurant: CKRecord.Reference? = nil

  init?(record: CKRecord, database: CKDatabase) {
    ckid = record.recordID
    headLine = record["Headline"] as? String ?? ""
    description = record["Description"] as? String ?? ""
    time = record["Time"] as? NSDate ?? NSDate.init()
        
    userID = record["UserID"] as? String ?? ""
    restaurant = record["Restaurant"] as? CKRecord.Reference

  }
  
}

extension Review: Hashable {
  static func == (lhs: Review, rhs: Review) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
