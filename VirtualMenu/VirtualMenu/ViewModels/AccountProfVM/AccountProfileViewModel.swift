//
//  AccountProfileViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 18/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import SwiftUI
import Firebase

class AccountProfileViewModel: ObservableObject {
    
    @EnvironmentObject var user: UserStore
    
    @State var signedOut = false

//    func changePhoto(inputImage: UIImage?){
//        guard let inputImage = inputImage else { return }
//        
//        //image = Image(uiImage: inputImage.circle!)
//        
//        userProfile.profilePhoto = inputImage
//        
//        let prom = Utils().uploadUserProfileImage(profileImage: inputImage)
//        
//        if(prom.result != nil){
//            return
//        }else{
//            print(prom.error!)
//        }
//    }
    
    func ridProfile(){
        userProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)
    }
    
}
