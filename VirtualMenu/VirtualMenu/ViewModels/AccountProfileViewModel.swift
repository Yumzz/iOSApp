//
//  AccountProfileViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 18/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import SwiftUI

func changePhoto(inputImage: UIImage?){
    guard let inputImage = inputImage else { return }
    
    //image = Image(uiImage: inputImage.circle!)
    
    Utils().uploadUserProfileImage(profileImage: inputImage)
    
    userProfile.profilePhoto = inputImage
}
