//
//  Utils.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/23/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import PromiseKit

class Utils {
    
    static func uploadUserProfileImage(profileImage: UIImage, dispatch: DispatchGroup? = nil) -> Promise<()> {
        return Promise<()> { seal -> Void in
            
            // Use the auto id for the image name
            // Generate a unique ID for the post and prepare the post database reference
            
            //what to do:
            //1) get user's id
            //2) post the image into profilephotos folder in DB bucket with their id as identifier
            //3) retrieve that for user
//            let name = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).username
            
            
            let storage = Storage.storage()
            
            
            let imagesRef = storage.reference().child("profilephotos/\(Auth.auth().currentUser!.uid)")
            
            print(imagesRef.storage)
            print(imagesRef.bucket)
            print(imagesRef.name)
    //        PROFILE_IMGS_STORAGE_REF.child(Utilities.getCurrentUserId()).child("default.jpg")
            
            // Resize the image
            //        let scaledImage = image.scale(newWidth: 640.0)
            guard let imageData = profileImage.jpegData(compressionQuality: 0.9) else {
                return
            }
            

            
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            // Upload the image to the userProfileImages storage
            let uploadTask = imagesRef.putData(imageData, metadata: metadata, completion: {
                (data, error) in
                imagesRef.downloadURL(completion: { (url, error) in
                    if let uploadedImageURL = url?.absoluteString {
                        
                        // Get the image url and assign to photoUrl for the current user and update
                        
                        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            
                            changeRequest.photoURL = URL(string: uploadedImageURL)
                            changeRequest.commitChanges(completion: { (error) in

                            if let error = error {
                                print("Failed to change the profile image: \(error.localizedDescription)")
                            }else {
                                print("Changed user profile image")
                                
                                guard let userId = Auth.auth().currentUser?.uid else {
                                    return
                                }
                                
                                // Save the profile of the user
                                let values = [UserProfile.UserInfoKey.profilePhotoURL: uploadedImageURL]
                                Database.database().reference().child("User").child(userId).updateChildValues(values, withCompletionBlock: {
                                    (error, ref) in
                                    if error != nil {
                                        print(error!)
                                        return
                                    }
                                })
                                    print("Updated user photoUrl")
                                    // Update cache
//                                CacheManager.shared.cache(object: profileImage, key: userId)
                                    seal.fulfill(())
                                }
                            })
                        }
                    }
                })
            })
        
            uploadTask.observe(.failure) { (snapshot) in
                        
                        if let error = snapshot.error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // Observe the upload status
                    uploadTask.observe(.success) { (snapshot) in
                        print("uploaded")
                        if(dispatch != nil){
                            dispatch!.leave()
                        }
                    }
            }
        }
        
        
    static func getUserProfileImgURL(userId: String, completionHandler: @escaping (String) -> Void) {
            
            // Get the rest of the user data
//        DispatchQueue.main.async {
        Database.database().reference().child("User").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let userValues = snapshot.value as? NSDictionary {
                if let userPhotoURL = userValues[UserProfile.UserInfoKey.profilePhotoURL] as? String {
                    completionHandler(userPhotoURL)
                }
            }
        })
//        }
    }
    
    func loadName(userId: String) -> String{
        var name = ""
        Firestore.firestore().collection("User").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if(document.get("uid") as! String == userId){
                        name = document.get("username") as! String
                        return
                    }
                }
            }
        }
        return name
    }
    
    
    static func loadUserProfilePhoto(userId: String) -> UIImage? {
        print("loadcalled")
        var retImage: UIImage? = nil
        
        Utils.getUserProfileImgURL(userId: userId) { (profileImgURL) in
        if let url = URL(string: profileImgURL) {
            
            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if(error != nil){
                    print(error?.localizedDescription ?? "error")
                    
                }
                
                guard let imageData = data else {
                    return
                }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else { print("no image")
                        return }
                    retImage = image
                    
                }
                
            })
            downloadTask.resume()
            }
//                  }
          }
        return retImage
      }
    
    
}

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isBlank: Bool {
        return self.trim.isEmpty
    }
    
    var isAlphanumeric: Bool {
        if self.count < 8 {
            return true
        }
        return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
//        let regex = "^[a-zA-Z0-9]$"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
//        return predicate.evaluate(with:self)
    }
    
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self)
    }
    
    var isValidPhoneNo: Bool {
        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = self.components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[@$!%*#?&])[0-9a-zA-Z@$!%*#?&]{8,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with:self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{4,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidURL: Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
    var isValidBidValue: Bool {
        
        guard let doubleValue = Double(self) else { return false}
        if doubleValue < 0{
            return false
        }
        return true
    }
    
    var verifyURL: Bool {
        if let url  = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
