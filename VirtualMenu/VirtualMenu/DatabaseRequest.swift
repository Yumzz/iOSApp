//
//  DatabaseRequest.swift
//  CloudKitDemo
//
//  Created by EageRAssassin on 3/6/20.
//  Copyright © 2020 ARMenu. All rights reserved.
//

import Foundation
import CloudKit

class DatabaseRequest {
    
    //need to change with new database
    
    let container: CKContainer
    let db: CKDatabase
    
    init() {
        container = CKContainer.default()
        db = container.publicCloudDatabase
    }
    
    /// fetchAllRestaurants() will fetch the list of restaurants in the database
    /// - Returns: list of restaurants in the database
    func fetchAllRestaurants() -> [Restaurant] {
        var restaurants : [Restaurant] = [Restaurant]()
        // we use a semaphore to signal the completion of database fetch
        let semaphore = DispatchSemaphore(value: 0)
        let query = CKQuery(recordType: "Restaurant", predicate: NSPredicate(value: true))
        
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            let res_temp = Restaurant(record: record, database: self.db)
            restaurants.append(res_temp!)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            print("restaurant fetch completed")
            semaphore.signal()
        }
        db.add(operation)
        //wait for the operation to finish
        _ = semaphore.wait(timeout: .now()+3)
        return restaurants
    }
    
    
    ///fetchRestaurantWithID() will fetch the restaurants in the database with the given id
    ///- Parameters:
    ///     - id : the id which the restaurant has
    ///- Returns: the restaurant with the given id in the database
    func fetchRestaurantWithID(id : String) -> Restaurant {
        var restaurant : Restaurant? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let restaurantID = CKRecord.ID(recordName: id)
        db.fetch(withRecordID: restaurantID) { record, error in
            guard error == nil else { return }
            restaurant = Restaurant(record: record!, database: self.db)!
            semaphore.signal()
        }
        //wait for the operation to finish
        _ = semaphore.wait(timeout: .now()+3)
        return restaurant!
    }
    
    ///fetchRestaurantDishes() will fetch dishes in a restaurant
    ///- Parameters:
    ///     - res : the restaurant object
    ///- Returns: the list of dishes
    func fetchRestaurantDishes(res : Restaurant) -> [Dish] {
        var dishes : [Dish] = [Dish]()
        let semaphore = DispatchSemaphore(value: 0)
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Dish", predicate: pred)
        let operation = CKQueryOperation(query: query)
        
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            let dish = Dish(record: record, database: self.db)
            dishes.append(dish!)
            print(dish!.name)
        }
        
        operation.queryCompletionBlock = { (cursor, err) in
            guard err == nil, let _ = cursor else {
                semaphore.signal()
                return
            }
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)
        return dishes
    }
    
    
    ///fetchDish() will fetch the dish given id in the database
    ///- Parameters:
    ///     - id : the id of the dish
    ///- Returns: the Dish in the database
    func fetchDish(recordID : String) -> Dish {
        let dishID = CKRecord.ID(recordName: recordID)
        let semaphore = DispatchSemaphore(value: 0)
        var dish : Dish? = nil
        db.fetch(withRecordID: dishID) { record, error in
            guard error == nil else { return }
            dish = Dish(record: record!, database: self.db)
            semaphore.signal()
        }
        //wait for the operation to finish
        _ = semaphore.wait(timeout: .now()+3)
        return dish!
    }
    
    
    ///fetchUser() will fetch the user given id in the database
    ///- Parameters:
    ///     - id : the id of the ARMUser
    ///- Returns: the ARMUser in the database
    func fetchUser(recordID : String) -> ARMUser {
        let userID = CKRecord.ID(recordName: recordID)
        let semaphore = DispatchSemaphore(value: 0)
        var user : ARMUser? = nil
        db.fetch(withRecordID: userID) { record, error in
            guard error == nil else { return }
            user = ARMUser(record: record!, database: self.db)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now()+3)
        return user!
    }
    
    
    ///fetchUserWithCloudID() will fetch the user given cloud id in the database
    ///- Parameters:
    ///     - id : the id of the ARMUser
    ///- Returns: the ARMUser in the database
    func fetchUserWithCloudID(cloudID : String) -> ARMUser {
        var user : ARMUser? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(format: "CloudIdentifier = %@", cloudID))
        
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            user = ARMUser(record: record, database: self.db)!
        }
        operation.queryCompletionBlock = { (cursor, error) in
            print("user fetch completed")
            semaphore.signal()
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)
        return user!
    }
    
    ///fetchReview() will information of a review given review id
    ///- Parameters:
    ///     - id : the id of the review
    ///- Returns: the review object
    func fetchReview(id : String) -> Review {
        var review : Review? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let reviewID = CKRecord.ID(recordName: id)
        db.fetch(withRecordID: reviewID) { record, error in
            guard error == nil else { return }
            review = Review(record: record!, database: self.db)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now()+3)
        return review!
    }
    
    ///fetchDishReviews() will fetch the reviews in a dish
    ///- Parameters:
    ///     - d : the Dish object
    ///- Returns: the list of reviews
    func fetchDishReviews(d : Dish) -> [Review] {
        var reviews : [Review] = [Review]()
//        let semaphore = DispatchSemaphore(value: 0)
        
        // prevent empty reviews
        if (d.reviews == nil) {
            return reviews
        }
        
        for i in 0..<d.reviews!.count {
            let reviewRecord = d.reviews![i]
//            db.fetch(withRecordID: reviewRecord.recordID) { record, error in
//                guard error == nil else { return }
//                let review_temp = Review(record: record!, database: self.db)
//                if (i == d.reviews!.count - 1) {
//                    // signal the semaphore to release lock
//                    semaphore.signal()
//                }
//                reviews.append(review_temp!)
//            }
            let review = fetchReview(id: reviewRecord.recordID.recordName)
            reviews.append(review)
        }
//        _ = semaphore.wait(timeout: .now()+3)
        return reviews
    }
    
    ///fetchUserReviews() will fetch the reviews from a user
    ///- Parameters:
    ///     - user : the user object
    ///- Returns: the list of reviews
    func fetchUserReviews(user : ARMUser) -> [Review] {
        var reviews : [Review] = [Review]()
        let semaphore = DispatchSemaphore(value: 0)
        
        // prevent empty reviews
        if (user.reviews == nil) {
            return reviews
        }
        
        for i in 0..<user.reviews!.count {
            let reviewRecord = user.reviews![i]
            db.fetch(withRecordID: reviewRecord.recordID) { record, error in
                guard error == nil else { return }
                let review_temp = Review(record: record!, database: self.db)
                if (i == user.reviews!.count - 1) {
                    // signal the semaphore to release lock
                    semaphore.signal()
                }
                reviews.append(review_temp!)
            }
        }
        _ = semaphore.wait(timeout: .now()+3)
        return reviews
    }
    
    ///fetchReviewUser() will fetch the user from a review
    ///- Parameters:
    ///     - user : the user object
    ///- Returns: the list of reviews
    func fetchReviewUser(review : Review) -> ARMUser {
        var user : ARMUser? = nil
        
        // prevent empty user
        if (review.userID == "") {
            return user!
        }
        
        user = fetchUserWithCloudID(cloudID: review.userID)
        
        return user!
    }
    
    ///searchRestaurant() will search for restaurants by keyword
    ///- Parameters:
    ///     - user : the user object
    ///- Returns: the restaurant with the closest match
    func searchRestaurant(keyword : String) -> [Restaurant] {
        var restaurants : [Restaurant] = [Restaurant]()
        let semaphore = DispatchSemaphore(value: 0)
        let query = CKQuery(recordType: "Restaurant", predicate: NSPredicate(format: "Name BEGINSWITH %@", keyword))
        
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            let restaurant = Restaurant(record: record, database: self.db)!
            restaurants.append(restaurant)
        }
        operation.queryCompletionBlock = { (cursor, error) in
            print("restaurant fetch completed")
            semaphore.signal()
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)
        return restaurants
    }
    
    ///fetchDishModel() will fetch the model from a dish
    ///- Parameters:
    ///     - user : the user object
    ///- Returns: the list of reviews
    func fetchDishModel(dish : Dish) -> CKAsset? {
        var model_mesh : CKAsset? = nil
        let semaphore = DispatchSemaphore(value: 0)

        // prevent empty reviews
        if (dish.model == nil) {
            return nil
        }
        
        db.fetch(withRecordID: dish.model!.recordID) { record, error in
            guard error == nil else { return }
            let model = Model(record: record!, database: self.db)
            model_mesh = model?.modelMesh!
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now()+10)
        return model_mesh!
    }
    
    // *************** Review Function *****************
    
    ///addReview() will add a review to the database based on the information given
    ///- Parameters:
    ///     - description : the description as a string
    ///     - headline : the headline as a string
    ///     - rating : the rating as a Double object in range 0 to 5
    ///     - dishRef : the dish reference object to post the review to
    ///     - cloudID : the user cloud id as a string
    func addReview(description : String, headline: String, dishRef: CKRecord.Reference, cloudID : String) -> String {
        // semaphore for uploading review
        let semaphore = DispatchSemaphore(value: 0)
        var result = ""
        
        // create review Record object to save to the Review schema
        let reviewRecord = CKRecord(recordType: "Review")
        reviewRecord.setValue(description, forKey: "Description")
        reviewRecord.setValue(headline, forKey: "Headline")
        reviewRecord.setValue(dishRef, forKey: "Dish")
        reviewRecord.setValue(Date(), forKey: "Time")
        reviewRecord.setValue(cloudID, forKey: "UserID")
        db.save(reviewRecord){ (record, error) -> Void in
            DispatchQueue.main.sync {
                if (error != nil){
                    print("Error in addReview, unable to save review", error as Any)
                    result = "Error in addReview, unable to save review"
                }
            }
        }
        
        // modify the dish review to add review on dish
        var dishRecord = CKRecord(recordType: "Dish")
        db.fetch(withRecordID: dishRef.recordID) { record, error in
            guard error == nil else { return }
            dishRecord = record!
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now()+3)

        var dishReview = [CKRecord.Reference]()
        if (dishRecord.value(forKey: "Reviews") != nil) {
            dishReview = dishRecord.value(forKey: "Reviews") as! [CKRecord.Reference]
        }
        dishReview.append(CKRecord.Reference(recordID: reviewRecord.recordID, action: .deleteSelf))
        dishRecord.setValue(dishReview, forKey: "Reviews")
        
        let saveOper = CKModifyRecordsOperation()
        saveOper.recordsToSave = [dishRecord]
        saveOper.savePolicy = .ifServerRecordUnchanged
        saveOper.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if (error != nil) {
                print("Error in addReview for dish", error as Any)
                result += "Error in addReview for dish"
            }
            if saveOper.isFinished == true {
                print("Review saved in dish")
            }
            semaphore.signal()
        }
        db.add(saveOper)
        _ = semaphore.wait(timeout: .now()+3)

        // modify the user to add review on user
        var ARMUserRecord = CKRecord(recordType: "ARMUser")
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(format: "CloudIdentifier = %@", cloudID))
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            ARMUserRecord = record
        }
        operation.queryCompletionBlock = { (cursor, error) in
            semaphore.signal()
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)

        var UserReview = ARMUserRecord.value(forKey: "Reviews") as! [CKRecord.Reference]
        UserReview.append(CKRecord.Reference(recordID: reviewRecord.recordID, action: .deleteSelf))
        ARMUserRecord.setValue(dishReview, forKey: "Reviews")
        
        let saveOper2 = CKModifyRecordsOperation()
        saveOper2.recordsToSave = [ARMUserRecord]
        saveOper2.savePolicy = .ifServerRecordUnchanged
        saveOper2.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if (error != nil) {
                print("Error in addReview for user", error as Any)
                result += "Error in addReview for user"
            }
            if saveOper.isFinished == true {
                print("Review saved in user")
            }
            semaphore.signal()
        }
        db.add(saveOper2)
        _ = semaphore.wait(timeout: .now()+3)
        // let the user know that the user successfully added the review"
        if (result == "") {
            result = "Review Successfully Added"
        }
        return result
    }
    
    ///editUserName() will edit the user's username given cloud identifier
    ///- Parameters:
    ///     - cloudID : the user's cloudID
    ///- Returns: True if successfully modified, False if not.
    func editUserName(cloudID : String, name : String) -> Bool {
        var status = true
        var user_record = CKRecord(recordType: "ARMUser")
        let semaphore = DispatchSemaphore(value: 0)
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(format: "CloudIdentifier = %@", cloudID))
        
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            user_record = record
        }
        operation.queryCompletionBlock = { (cursor, error) in
            if (error != nil) {
                print("Error in fetching user", error as Any)
                status = false
            }
            print("user fetch completed")
            semaphore.signal()
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)
        
        // If we cannot fetch user, we just return false
        if (status == false) {
            return status
        }

        user_record.setValue(name, forKey: "UserName")
        
        let saveOper = CKModifyRecordsOperation()
        saveOper.recordsToSave = [user_record]
        saveOper.savePolicy = .ifServerRecordUnchanged
        saveOper.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if (error != nil) {
                print("Error in setting name for user", error as Any)
                status = false
            }
            if saveOper.isFinished == true {
                print("Name modifed in user")
            }
            semaphore.signal()
        }
        db.add(saveOper)
        _ = semaphore.wait(timeout: .now()+3)
        
        return status
    }
    
    ///editUsePhoto() will edit the user's photo given cloud identifier
    ///- Parameters:
    ///     - cloudID : the user's cloudID
    ///- Returns: True if successfully modified, False if not.
    func editUsePhoto(cloudID : String, photo : CKAsset) -> Bool {
        var status = true
        var user_record = CKRecord(recordType: "ARMUser")
        let semaphore = DispatchSemaphore(value: 0)
        let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(format: "CloudIdentifier = %@", cloudID))
        
        let operation = CKQueryOperation(query: query)
        operation.queuePriority = .veryHigh
        operation.recordFetchedBlock = { record in
            user_record = record
        }
        operation.queryCompletionBlock = { (cursor, error) in
            if (error != nil) {
                print("Error in fetching user", error as Any)
                status = false
            }
            print("user fetch completed")
            semaphore.signal()
        }
        db.add(operation)
        _ = semaphore.wait(timeout: .now()+3)
        
        // If we cannot fetch user, we just return false
        if (status == false) {
            return status
        }
        
        user_record.setValue(photo, forKey: "ProfilePhoto")
        
        let saveOper = CKModifyRecordsOperation()
        saveOper.recordsToSave = [user_record]
        saveOper.savePolicy = .ifServerRecordUnchanged
        saveOper.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if (error != nil) {
                print("Error in setting profile photo for user", error as Any)
                status = false
            }
            if saveOper.isFinished == true {
                print("Photo modifed in user")
            }
            semaphore.signal()
        }
        db.add(saveOper)
        _ = semaphore.wait(timeout: .now()+3)
        return status
    }
}
