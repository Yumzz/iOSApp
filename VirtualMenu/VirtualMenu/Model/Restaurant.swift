//
//  Restaurant.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 2/8/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

class Restaurant {
  
    static let recordType = "Restaurant"
    private let id: CKRecord.ID
    let name: String
    let location: CLLocation
    let description: String
    let coverPhoto: CKAsset?
    let photos: [CKAsset]?
    let menuPhotos: [CKAsset]?
    let database: CKDatabase
    var dishes: [CKRecord.Reference]? = nil
    var reviews: [CKRecord.Reference]? = nil
    
    init?(record: CKRecord, database: CKDatabase) {
        guard
          let name = record["Name"] as? String,
          let location = record["Location"] as? CLLocation
          else { return nil }
        id = record.recordID
        self.name = name
        self.location = location
        self.database = database
        description = record["Description"] as? String ?? ""
        coverPhoto = record["CoverPhoto"] as? CKAsset
        photos = record["Photos"] as? [CKAsset]
        menuPhotos = record["MenuPhotos"] as? [CKAsset]
    
        dishes = record["Dishes"] as? [CKRecord.Reference]
        reviews = record["Reviews"] as? [CKRecord.Reference]
   
    }
    
  static func fetchRestaurant(reference: CKRecord.Reference) {
//    let refRecordID = reference.recordID
//    let operation = CKFetchRecordsOperation(recordIDs: [refRecordID])
//    operation.qualityOfService = .utility
//
//    operation.fetchRecordsCompletionBlock = { records, error in
//      let notes = records?.values.map(Restaurant .init) ?? []
//      DispatchQueue.main.async {
//        completion(notes)
//      }
//    }
//
//    DBModel.currentModel.privateDB.add(operation)
//
//    return r_temp
    
    }
  }

extension Restaurant: Hashable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
        
    }
  
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
