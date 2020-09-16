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
        Group {
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
        .frame(width: UIScreen.main.bounds.width/1.1, height: 55, alignment: .leading)
        .background(Color(.white))

        .cornerRadius(10)
        .shadow(radius: 2)
        }
        .padding(.horizontal)
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
    
    @State var isNavigationBarHidden: Bool = true
    
    @EnvironmentObject var user: UserStore
    @ObservedObject var accountVM = AccountProfileViewModel()
    
    var body: some View {
        ZStack{
            if self.show{
                GeometryReader{_ in
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
            if user.isLogged {
                VStack{
                    Spacer().frame(height: 20)
                    Group{
                        if image ==  nil {
                            if (userProfile.profilePhoto == nil){
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                Button(action: {
                                    self.showingImagePicker.toggle()
                                }, label: {
                                    Text("Edit Profile Photo")
                                })
                            }
                            else{
                                Image(uiImage: userProfile.profilePhoto!.circle!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                Button(action: {
                                    self.showingImagePicker.toggle()
                                }, label: {
                                    Text("Edit Profile Photo")
                                })
                                Spacer().frame(height: 15)
                                Text(userProfile.fullName)
                                    .font(.custom("Open Sans-SemiBold", size: 30))
                            }
                        }
                        else{
                            image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                            Button(action: {
                                self.showingImagePicker.toggle()
                            }, label: {
                                Text("Edit Profile Photo")
                            })
                            Spacer().frame(height: 15)
                            Text(userProfile.fullName)
                                .font(.custom("Open Sans-SemiBold", size: 30))
                        }
                    }
                    VStack{
                        Divider()
                            .frame(width: (UIScreen.main.bounds.width/1.2), height: 10, alignment: .center)
                        .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                        
                    }
                    
                    ScrollView {

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
                            self.show = true
                            let firebaseAuth = Auth.auth()
                            do {
                                defer {
                                    NSLog(Auth.auth().currentUser?.email! ?? "no user" )
                                    self.accountVM.ridProfile()
                                    NSLog(userProfile.emailAddress)
                                    self.user.isLogged = false
                                    self.show = false
                                }
                              try firebaseAuth.signOut()
                        
                            } catch let signOutError as NSError {
                              print ("Error signing out: %@", signOutError)
                            }
                        }){
                            Text("Sign Out")
                                .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                            .padding()
                            }.background((Color(UIColor().colorFromHex("#F88379", 1))))
                        .cornerRadius(10)
                        
                    }
                    
                    
                    
                    Spacer()
                }
            .navigationBarTitle("")
            .navigationBarHidden(self.isNavigationBarHidden)
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $showingImagePicker, onDismiss: self.changePhoto){ ImagePicker(image: self.$inputImage)
                    .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                    }
                }
                .onAppear(){
                    self.isNavigationBarHidden = true
                    print("logged: \(self.user.isLogged)")
                    if(self.image == nil){
                        print("image: nill")
                        print(userProfile.profilePhoto?.description)
                        print(userProfile.userId)
                    }
                    else{
                        print("image: not nil")
                    }
                    
                }
                .onDisappear(){
                    self.isNavigationBarHidden = false
                   
                }
            } else {
                AccountProfileLoginView()
                    .navigationBarTitle("Log In to your account")
            }
            }
        }.background(AccountProfGradientView().edgesIgnoringSafeArea(.all))
        
        
    }
    
    func changePhoto(){
        if(inputImage != nil){
            self.show = true
            guard let inputImage = inputImage else { return }
            
            //image = Image(uiImage: inputImage.circle!)
            
            userProfile.profilePhoto = inputImage
            
            let dispatch = DispatchGroup()
            
            dispatch.enter()
            
            let prom = Utils().uploadUserProfileImage(profileImage: inputImage, dispatch: dispatch)
                                
            dispatch.notify(queue: .main){
                if(prom.result != nil){
                    return
                }else{
                    print(prom.result.debugDescription)
                }
                self.show = false
            }
        }
    }
    
}

struct AccountProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountProfileView()
        }
    }
}

