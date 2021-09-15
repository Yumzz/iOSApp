//
//  UserProfile.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/8/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

#if !APPCLIP
import Firebase
import PromiseKit
#endif
import SwiftUI

struct UserProfile {
    var userId: String = ""
    var emailAddress: String = ""
    var fullName: String = ""
    var profilePhotoURL: String = ""
    var profilePhoto: UIImage? = nil
    var favRests: [String:DishFB] = [String:DishFB]()
   
    // MARK: - Firebase Keys
    #if !APPCLIP
    var storage = Storage.storage()
    #endif
    
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
    
    
    #if !APPCLIP
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
    #endif
}

extension UserProfile: Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.userId == rhs.userId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
    
    #if !APPCLIP
    func getProfilePhoto(dispatch: DispatchGroup) {
        var image: UIImage?
        let imagesRef = storage.reference().child("profilephotos/\(self.userId)")
        imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
        if let error = error {
            print("error getting photo")
            print(error.localizedDescription)
            dispatch.leave()
        } else {
          // Data for "profilephotos/\(id).jpg" is returned
            print("photo got")
            image = UIImage(data: data!)!
            dispatch.leave()
            }
        }
        dispatch.notify(queue: .main) {
            userProfile.profilePhoto = image
            return
        }
    }
    
    func downloadPhoto(url:URL){
        let session = URLSession(configuration: .default)
        print("here")
        let dispatch = DispatchGroup()

        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        dispatch.enter()
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            print("downloading")
            if let e = error {
                print("Error downloading this picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        userProfile.profilePhoto = UIImage(data: imageData)
                        let prom = Utils.uploadUserProfileImage(profileImage: userProfile.profilePhoto!)
                        if(prom.error != nil){
                            return
                        }
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        dispatch.leave()
        dispatch.notify(queue: .main){
        }
    }
    
    mutating func getFaveDishes(){
        //decode favorites mapping from FB
        let db = Firestore.firestore()
        var map: [String: DishFB] = [String: DishFB]()
        let docRef = db.collection("User").whereField("id", isEqualTo: self.userId)
        docRef.getDocuments { (snap, err) in
            if let error = err {
                print("Error getting documents: \(error)")
            } else {
                for document in snap!.documents {
                guard
                    let ds = document.data()["FavDishes"] as? [String:[DocumentReference?]] else {
                        print("dishes messed up")
                        return
                    }
                    ds.forEach { (arg0) in
                        let (_, dish) = arg0
                        dish.forEach { (arg1) in
                            let d = arg1
                            d!.getDocument(completion: { (s, err) in
                                if let error = err {
                                    print("Error getting documents: \(error)")
                                } else {
                                    let dname = s?.data()!["Name"] as! String
                                    let description = s?.data()!["Description"] as! String
                                    let price = s?.data()!["Price"] as! Double
                                    let rest = s?.data()!["Restaurant"] as! String
                                    let type = s?.data()!["Type"] as! String
                                    map[rest] = DishFB(name: dname, description: description, price: price, type: type, restaurant: rest)
                                }
                            })
                        }
                        
                    }
                }
            }
    
        }
        self.favRests = map
    }
    
    #endif
    
}
    
