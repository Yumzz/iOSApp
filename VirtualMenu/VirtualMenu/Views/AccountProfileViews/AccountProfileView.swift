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
                .resizable()
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
    
    @State private var signedOut = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State var show = false
    
     @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40){
                    
                    Spacer()
                        .frame(maxHeight: 0)
                    
                    Group{
                        if image ==  nil {
                            if (user.profilePhoto == nil){
                                Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                            }
                            else{
                                Image(uiImage: user.profilePhoto!.circle!)
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
                    
                    VStack(alignment: .leading, spacing: 20){
                        NavigationLink(destination: ContactUs()) {
                            ProfileButton(imageName: "contact_us", label: "Contact Us")
                        }.buttonStyle(PlainButtonStyle())
                        

                        NavigationLink(destination: ReportProblem()) {
                            ProfileButton(imageName: "report_problem", label: "Report Problem")
                        }.buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: SuggestRestaurant()) {
                            ProfileButton(imageName: "suggest_restaurant", label: "Suggest Restaurant")
                        }.buttonStyle(PlainButtonStyle())
                    }
                        
                        
                    
                        Button(action: {
                              let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                self.signedOut = true
                            } catch let signOutError as NSError {
                              print ("Error signing out: %@", signOutError)
                            }
                        }){
                            NavigationLink(destination: InitialScreen().navigationBarBackButtonHidden(true), isActive: self.$signedOut){
                                Text("Sign Out")
                                .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                            }.disabled(!self.signedOut)
                        }
                    
                    Button(action: {
                        self.navigator.isOnboardingShowing = true
                    }) {
                        Text("Exit")
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .navigationBarTitle("Account Profile")
                .navigationBarItems(trailing: Button(action: {
                    self.showingImagePicker.toggle()
                }, label: {
                        Text("Edit Profile Photo")
            }))
        }
            
            .sheet(isPresented: $showingImagePicker, onDismiss: changePhoto){ ImagePicker(image: self.$inputImage)
                .alert(isPresented: self.$showingAlert) {
                Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
            }
            }
        }
    
    func changePhoto(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage.circle!)
        let x = Utils().uploadUserProfileImage(profileImage: inputImage)
        print(x)
        user.profilePhoto = inputImage
        
//        changeRequest?.photoURL = image
    }
    
}

struct AccountProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountProfileView()
        }
    }
}

