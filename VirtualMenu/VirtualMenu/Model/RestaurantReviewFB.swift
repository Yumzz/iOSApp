//
//  RestaurantReviewFB.swift
//  VirtualMenu
//
//  Created by William Bai on 10/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI

struct RestaurantReviewFB{
    let id = UUID()
    let rating: Int
    var restaurant: DocumentReference? = nil
    var userID: String = ""
    let text: String
    let date: String
    var name: String = ""
    var photoURL: String = ""
    
    init?(snapshot: DocumentSnapshot) {
        guard let rating = snapshot.data()?["Rating"] as? Int else {
            print("no rating")
            return nil
        }
        guard let text = snapshot.data()?["Text"] as? String else {
            print("no text")
            return nil
        }
        guard let date = snapshot.data()?["Date"] as? Timestamp else {
            print("no date")
            return nil
        }
        
        self.rating = rating
        self.text = text
        let d = Date(timeIntervalSince1970: TimeInterval(date.seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "PST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yy" //Specify your format that you want
        let strDate = dateFormatter.string(from: d)
        self.date = strDate
        if (snapshot.get("UserID") != nil) {
            if let user = snapshot.data()?["UserID"] as? String {
                print("reviewer: \(user) text: \(text)")
                self.userID = user
                self.photoURL = "profilephotos/\(user)"
            }
        }
        if (snapshot.get("Restaurant") != nil) {
            if let restaurant = snapshot.data()?["Restaurant"] as? DocumentReference {
                self.restaurant = restaurant
            }
        }
        if (snapshot.get("Name") != nil) {
            if let name = snapshot.data()?["Name"] as? String {
                self.name = name
            }
        }
    }
    
}
