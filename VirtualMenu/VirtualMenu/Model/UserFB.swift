//
//  UserFB.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct UserFB{
    let ref: DatabaseReference?
    let key: String
    let userName: String
    let karma: Int64
    private let id: Int
    //the User UID given by firebase
    var profilePhoto: UIImage?
//    var modelUploaded: [CKRecord.Reference]? = nil
//    var reviews: [CKRecord.Reference]? = nil

    let storage = Storage.storage()
    
    
    init(userName: String, key: String = "") {
         self.ref = nil
         self.key = key
         self.userName = userName
         self.karma = 0
         self.id = 0
         self.profilePhoto = nil
     }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["userName"] as? String else {
            return nil
        }
        self.ref = nil
        self.key = "nil"
        self.userName = name
        self.karma = 0
        self.id = 0
        self.profilePhoto = self.getProfilePhoto(username: name)
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName
        ]
    }
    
    
}

extension UserFB: Hashable {
    static func == (lhs: UserFB, rhs: UserFB) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func getProfilePhoto(username: String) -> UIImage? {
        let name = userName
        var image: UIImage?
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("virtual-menu-profilephotos-/\(name)")
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
          // Uh-oh, an error occurred!
        } else {
          // Data for "virtual-menu-profilephotos/\(name).jpg" is returned
            image = UIImage(data: data!)!
            }
        }
        return image
    }
}
