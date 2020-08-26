//
//  SignUpView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/24/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit

var signUp = false
var login = false
struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    @State var alertMsg = ""
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var showAlert = false
    @State var showDetails = false
    
    @State var createdAccount = false
    var socialLogin = SocialLogin()
    
    @EnvironmentObject var user: UserStore
    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    
    var body: some View {
                
        VStack(spacing: 30) {
            Text("Yumzz")
            .font(.custom("Montserrat-SemiBold", size: 48))
            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
            .bold()
            
            Text("Create your account")
            .font(.custom("Montserrat-SemiBold", size: 20))
            .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
            .bold()
            
            CustomTextField(strLabel: "Name", strField: $name, uiTextAutoCapitalizationType: .words, uiKeyboardType: .default)
            
            CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
            
            CustomPasswordField(strLabel: "Password", password: $password)
            
            Button(action: {
                Auth.auth().createUser(withEmail: self.email, password: self.password){
                    (result, error) in
                    if (error != nil){
                        self.alertMessage = "Error creating user"
                        self.alertTitle = "Error"
                    }
                    else{
                        let db = Firestore.firestore()
                        db.collection("User").addDocument(data: ["email": self.email, "password": self.password, "username": self.name, "id": result!.user.uid]) {(error) in
                            if error != nil {
                                self.alertMessage = "Error creating user"
                                self.alertTitle = "Error"
                            }
                            
                        }
                        
                    }
                    print("created")
                    self.alertMessage = "Password Reset email was sent to you so you can choose your own password!"
                    self.alertTitle = "User Created!"
                    self.showAlert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.showAlert = false
                        self.user.showOnboarding = false
                    }
                }
            })
            {
                NavigationLink(destination: AppView(), isActive: $createdAccount){
                    CoralButton(strLabel: "Sign Up")
                }.disabled(!self.createdAccount)
            }
            
            
            HStack {
                
                VStack {
                    Divider()
                        .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                        .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .leading)
                    
                }
                
                Text("OR")
                
                VStack{
                    Divider()
                        .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .trailing)
                }
                
            }
            
            HStack{
                Button(action: {
                    self.socialLogin.attemptLoginGoogle()
                }){
                    SocialMediaButton(imgName: "continue_with_google")
                    .frame(width: 100, height: 50)
                }

                Button(action: {
                    print("apple")
                }){
                    SocialMediaButton(imgName: "continue_with_apple")
                    .frame(width: 100, height: 50)
                }

                Button(action: {
                    self.signinInFb()
                }){
                    SocialMediaButton(imgName: "continue_with_facebook")
                    .frame(width: 100, height: 50)
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
            }
            Spacer()
        }
//        .navigationBarHidden(false)
//        .navigationBarItems(leading: UIBarButtonItem(image: UIImage(Image("back_button")), style: .plain, target: nil, action: nil))
//        .navigationBarItems(leading: Image("back_button"))
//        .navigationBarItems(leading: UIBarButtonItem(image: UIImage(Image("back_button")), style: .plain, target: nil, action: nil))
    }
    
    func goToLogin(){
        
    }
    
    func signinInFb() {
        socialLogin.attemptLoginFb(completion: { result, error in
            if(error == nil){
                self.user.isLogged = true
                self.user.showOnboarding = false
            }else{
                //create alert saying no account associated with this FB profile. Please use sign up page
            }
        })
    }
    
    
    struct SocialLogin: UIViewRepresentable {
        var dispatch = DispatchGroup()

        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            signUp = true
            login = false
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                print("RESULT: '\(result)' ")
                let authen = AuthenticationViewModel()
                if error != nil {
                    print("error")
                }else if(result!.isCancelled){
                    print("result cancelled")
                }else if(!result!.isCancelled){
                    //create a userProfile based on FB info
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    print("success Get user information.")

                    let fbRequest = GraphRequest(graphPath:"me", parameters: ["fields":"email, name, picture"])
                    fbRequest.start { (connection, infoResult, error) -> Void in

                    let authen = AuthenticationViewModel()

                    if error == nil {
                        print("User Info : \(infoResult ?? "No result")")
                        print(infoResult.unsafelyUnwrapped)
                        print(credential.description)
                        
                        if let infoResult = infoResult as? [String:Any],
                            let email: String = infoResult["email"] as? String,
                            let name: String = infoResult["name"] as? String,
                            let picture = infoResult["picture"] as? [String: Any],
                            let data = picture["data"] as? [String: Any],
                            let url = data["url"] as? String
                            {
                            
                            let x = credential.hashValue
                            let dispatchTwo = DispatchGroup()
                            self.dispatch.enter()

                            Auth.auth().createUser(withEmail: email, password: String(x)) { (authResult, error) in
                                if(error != nil){
                                    NSLog(String(error!.localizedDescription))
                                }
                                else{
                                    userProfile.emailAddress = email
                                    userProfile.fullName = name
                                    userProfile.profilePhotoURL = url
                                    //need to download photo URL and save that
                                    dispatchTwo.enter()
                                    authen.fetchUserID(name: name, email: email, dispatch: dispatchTwo)
                                    let fileUrl = URL(string: url)
                                    userProfile.downloadPhoto(url: fileUrl!)
                                    //now i need to store this into profilephotos
                                    let db = Firestore.firestore()
                                    db.collection("User").addDocument(data: ["email": email, "password": x, "username": name, "id": Auth.auth().currentUser?.uid]) {(error) in
                                    }
                                    
                                }
                                self.dispatch.leave()
                            }
                            self.dispatch.notify(queue: .main){
                                Auth.auth().currentUser!.link(with: credential)
                                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                                    if error != nil{
                                        NSLog(String(error!.localizedDescription))
                                        return
                                    }
                                    else{
                                        print("sent password reset")
                                    }
                                }
                                
                                signUp = false
                                completion(result, error)
                                return
                            }

                        }
                    } else {
                        print("Error Getting Info \(error ?? "error" as! Error)");
                        completion(result, error)
                        return
                        }
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
