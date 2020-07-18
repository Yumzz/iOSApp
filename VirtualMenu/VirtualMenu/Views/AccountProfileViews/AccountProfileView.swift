//
//  AccountProfileView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/17/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import AuthenticationServices
import Firebase
import FirebaseFirestore

struct ProfileButton: View {
    
    var imageName: String
    var label: String
    
    var body: some View{
        HStack {
           Image(imageName)
               .shadow(radius: 10)
               .frame(width: 40, height: 40)
           VStack(alignment: .leading) {
               Text(label)
                   .font(.custom("Futura Bold", size: 18))
           }
        }
    }
}

struct AccountProfileView: View {
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    var body: some View {
            VStack(spacing: 40){
                ZStack{
                    if image ==  nil {
                        if (user.profilePhoto == nil){
                            Image("profile_photo_edit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        }
                        else{
                            Image(uiImage: user.profilePhoto!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        }
                    }
                    else{
                        image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    }
                }
                List{
                    
                    NavigationLink(destination: ContactUs()) {
                        ProfileButton(imageName: "contact_us", label: "Contact Us")
                    }

                    NavigationLink(destination: ReportProblem()) {
                        ProfileButton(imageName: "report_problem", label: "Report Problem")
                    }

                    NavigationLink(destination: SuggestRestaurant()) {
                        ProfileButton(imageName: "report_problem", label: "Suggest Restaurant")
                    }
                }
            }.navigationBarTitle("Account Profile")
            .navigationBarItems(trailing: Button(action: {
                self.showingImagePicker.toggle()
            }, label: {
                    Text("Edit Profile Photo")
        }))
            .sheet(isPresented: $showingImagePicker, onDismiss: changePhoto){ ImagePicker(image: self.$inputImage)
            }
        }
    
    func changePhoto(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        Utils().uploadUserProfileImage(profileImage: inputImage)
        user.profilePhoto = inputImage
        
//        changeRequest?.photoURL = image
    }
    
}

struct AccountProfile_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileView()
    }
}

