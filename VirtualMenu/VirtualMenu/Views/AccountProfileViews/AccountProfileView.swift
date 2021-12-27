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
    
    var label: String
    var dark: Bool = false
    
    var body: some View{
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text(label)
                        .foregroundColor(dark ? .white : Color(UIColor().colorFromHex("#000000", 1)))
                        .font(.system(size: 24))
                }
                Spacer()
                VStack(alignment: .trailing){
                    dark ? Image("forward_white_button") : Image("forward_button")
//                        .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.1, height: 55, alignment: .leading)
            .background(dark ? ColorManager.blackest : Color(.white))

            .cornerRadius(10)
//            .shadow(radius: 2)
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
    @State var loggedIn = false

    
    @State var isNavigationBarHidden: Bool = true
    
    @EnvironmentObject var user: UserStore
    @ObservedObject var accountVM = AccountProfileViewModel()
    
    @Environment (\.colorScheme) var colorScheme : ColorScheme
    
    private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(colorScheme == .dark ? ColorManager.darkBack :  UIColor().colorFromHex("#F3F1EE", 1)).edgesIgnoringSafeArea(.all)
    //            if self.show{
    //                GeometryReader{_ in
    //                    Loader()
    //                }.background(Color.black.opacity(0.45))
    //            }
    //            else{
    //            if user.isLogged {
                    VStack{
                        Spacer().frame(height: 20)
                        Group{
                            if image ==  nil {
                                if (userProfile.profilePhoto != nil){
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 145, height: 145)
                                    Button(action: {
                                        self.showingImagePicker.toggle()
                                    }, label: {
                                        Text("Edit Profile Photo")
                                            .foregroundColor(colorScheme == .dark ? .white : ColorManager.textGray)
                                    })
                                    Spacer().frame(height: 15)
                                    if(userProfile.fullName != ""){
                                        Text(userProfile.fullName)
                                            .font(.custom("Open Sans-SemiBold", size: 30))
                                            .foregroundColor(colorScheme == .dark ? .white : ColorManager.yumzzOrange )
                                    }
                                }
                                else{
                                    FBURLImage(url: "profilephotos/\(userProfile.userId)", imageWidth: 150, imageHeight: 150, circle: true)
//                                    Image(uiImage: userProfile.profilePhoto!.circle!)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 150, height: 150)
                                    Button(action: {
                                        self.showingImagePicker.toggle()
                                    }, label: {
                                        Text("Edit Profile Photo")
                                            .foregroundColor(colorScheme == .dark ? .white : ColorManager.textGray)
                                    })
                                    Spacer().frame(height: 15)
                                    if(userProfile.fullName != ""){
                                        Text(userProfile.fullName)
                                            .font(.custom("Open Sans-SemiBold", size: 30))
                                    }
                                }
                            }
                            else{
                                image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                    .onAppear(){
                                        print("hihihihihihihi\(image.debugDescription)")
//                                        image = nil
//                                        print("qwertyuiop\(image.debugDescription)")
                                    }
                                Button(action: {
                                    self.showingImagePicker.toggle()
                                }, label: {
                                    Text("Edit Profile Photo")
                                        .foregroundColor(colorScheme == .dark ? .white : ColorManager.textGray)
                                })
                                Spacer().frame(height: 15)
                                Text(userProfile.fullName)
                                    .font(.custom("Open Sans-SemiBold", size: 30))
                                    .foregroundColor(colorScheme == .dark ? .white : ColorManager.textGray)
                            }
                        }
    //                    VStack{
    //                        Divider()
    //                            .frame(width: (UIScreen.main.bounds.width/1.2), height: 10, alignment: .center)
    //                        .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
    //
    //                    }
                        
                        ScrollView {

                            VStack(alignment: .leading, spacing: 10){
                                
                                NavigationLink(destination: ContactUs()) {
                                    ProfileButton(label: "  Contact Us", dark: colorScheme == .dark)
                                }.buttonStyle(PlainButtonStyle())
                                
                                
                                NavigationLink(destination: ReportProblem()) {
                                    ProfileButton(label: "  Report Problem", dark: colorScheme == .dark)
                                }.buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: SuggestRestaurant()) {
                                    ProfileButton(label: "  Suggest Restaurant", dark: colorScheme == .dark)
                                }.buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: PastOrders()) {
                                    ProfileButton(label: "  Past Orders", dark: colorScheme == .dark)
                                }.buttonStyle(PlainButtonStyle())
                            }
                            
                            Spacer().frame(height: 20)
                            if(userProfile.userId == ""){
                                NavigationLink(destination: AccountProfileLoginView()){
                                    OrangeButton(strLabel: "Sign In", width: 141, height: 48, dark: colorScheme == .dark)
                                        .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    //                                    .onTapGesture(){
    //                                        self.user.isLogged = false
    //                                        self.user.showOnboarding = true
    //                                    }
                                }
                                
                            }
                            else{
                                Button(action: {
                                    self.show = true
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        defer {
                                            NSLog(Auth.auth().currentUser?.email! ?? "no user")
                                            self.accountVM.ridProfile()
                                            NSLog(userProfile.emailAddress)
                                            self.show = false
                                            Auth.auth().signInAnonymously() { (authResult, error) in
                                              // ...
                                                print("anonymous")
                                                if(error != nil){
                                                    print(error.debugDescription)
                                                }
                                                else{
                                                    self.user.isLogged = true
                                                    self.user.showOnboarding = false
                                                    print("yes")
                                                    print(authResult?.additionalUserInfo)
                                                }
                                            }
                                        }
                                      try firebaseAuth.signOut()
                                
                                    } catch let signOutError as NSError {
                                      print ("Error signing out: %@", signOutError)
                                    }
                                }){
                                    OrangeButton(strLabel: "Sign Out", width: 141, height: 48, dark: colorScheme == .dark)
                                        .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                    }
                            }
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
                        if(userProfile.userId != ""){
                            self.loggedIn = true
                        }
                        
                    }
                    .onDisappear(){
                        self.isNavigationBarHidden = false
                    }
    //            } else {
    //                AccountProfileLoginView()
    //                    .navigationBarTitle("Log In to your account")
    //            }
    //            }
            }
    }
        
    }
    
    func changePhoto(){
        print("asdfghjkl")
        if(inputImage != nil){
            self.show = true
            guard let inputImage = inputImage else { return }
            
            image = Image(uiImage: inputImage.circle!)
            
            print("before\(userProfile.profilePhoto.debugDescription)")
            userProfile.profilePhoto = inputImage
            print("after\(userProfile.profilePhoto.debugDescription)")
            
            let dispatch = DispatchGroup()
            
            dispatch.enter()
            
            let prom = Utils.uploadUserProfileImage(profileImage: inputImage, dispatch: dispatch)
                                
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

