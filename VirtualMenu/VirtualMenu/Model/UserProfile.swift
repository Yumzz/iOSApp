//
//  UserProfile.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/8/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Firebase
import SwiftUI
import PromiseKit

struct UserProfile {
    var userId: String = ""
    var emailAddress: String = ""
    var fullName: String = ""
    var profilePhotoURL: String = ""
    var profilePhoto: UIImage? = nil
   
    // MARK: - Firebase Keys
    
    var storage = Storage.storage()
    
    enum UserInfoKey {
        static let email = "email"
        static let name = "name"
        static let profilePhotoURL = "profilePhotoURL"
        static let age = "age"
        static let photo = "photo"
    }
    
    
    init(userId: String, fullName: String, emailAddress: String, profilePicture: String, profPhoto: UIImage?) {
        self.userId = userId
        self.emailAddress = emailAddress
        self.fullName = fullName
        self.profilePhotoURL = profilePicture
        self.profilePhoto = profPhoto
    }
    
    init?(userId: String, userInfo: [String: Any]) {
        let fullname = userInfo[UserInfoKey.name] as? String ?? ""
        let photoURL = userInfo[UserInfoKey.profilePhotoURL] as? String ?? ""
        let emailAddress = userInfo[UserInfoKey.email] as? String ?? ""
        self = UserProfile(userId: userId, fullName: fullname, emailAddress: emailAddress, profilePicture: photoURL, profPhoto: self.profilePhoto!)
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard let name = snapshot.data()["username"] as? String else {
            return nil
        }
        guard let id = snapshot.data()["id"] as? String else {
            return nil
        }
        guard let email = snapshot.data()["email"] as? String else {
            return nil
        }
        guard let profPhotoURL = snapshot.data()["profilePhotoURL"] as? String else {
            return nil
        }
        guard let profPhoto = snapshot.data()["profilePhoto"] as? UIImage else {
            return nil
        }
        self.fullName = name
        self.userId = id
        self.emailAddress = email
        self.profilePhotoURL = profPhotoURL
        self.profilePhoto = profPhoto
    }
}

extension UserProfile: Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.userId == rhs.userId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    func getProfilePhoto() {
        var dispatch = DispatchGroup()
        dispatch.enter()
        var image: UIImage?
        let imagesRef = storage.reference().child("profilephotos/\(self.userId)")
        imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
        if let error = error {
            print(error.localizedDescription)
            dispatch.leave()
        } else {
          // Data for "profilephotos/\(id).jpg" is returned
            image = UIImage(data: data!)!
            dispatch.leave()
            }
        }
        dispatch.notify(queue: .main) {
            userProfile.profilePhoto = image
            return
        }
    }
}
