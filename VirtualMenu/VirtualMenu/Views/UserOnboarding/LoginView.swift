//
//  LoginView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/23/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices
import CryptoKit

struct LoginView: View {
    
    @EnvironmentObject var accountDetails: AccountDetails
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil
    
    @State var email: String = ""
    @State var password: String = ""
    @State var alertMsg = ""
    @State var currentNonce: String? = ""
    
    @State private var showForgotPassword = false
    @State private var showSignup = false
    @State var showAlert = false
    @State var showDetails = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @Binding var loggedin: Bool
    @State var loggedIn = false
    @State var showGoogle = false
    @State var showFB = false
    
    var socialLogin = SocialLogin()
    
    @ObservedObject var AuthenticationVM = AuthenticationViewModel()
    
    @EnvironmentObject var user: UserStore
    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
        ZStack {
        if user.showOnboarding {
        NavigationView{
            VStack(spacing: 20) {
                    VStack{
                        Text("Yumzz")
                        .font(.custom("Montserrat-SemiBold", size: 48))
                        .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                        .bold()
                        .padding(.leading, 0)
                    }
                    
                    Text("Login to your account")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
                    .bold()
                    
                    CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    
                    CustomPasswordField(strLabel: "Password", password: $password)
                    
                    Button(action: {
                        print(self.email)
                        print(self.password)
                        Auth.auth().signIn(withEmail: self.email, password: self.password){ result, error in
                            print("signin attempt: \(result)")
                            if(error != nil){
                                print(error!)
                                self.alertMsg = "Your email or password is incorrect"
                                self.alertTitle = "Sign in error"
                                self.showAlert.toggle()
                            }
                            else{
                                self.user.isLogged = true
                                UserDefaults.standard.set(true, forKey: "isLogged")
                                print(self.user.showOnboarding)
                                self.user.showOnboarding = false
                                print(self.user.showOnboarding)
                                UserDefaults.standard.set(false, forKey: "showOnboarding")
                                
                                self.AuthenticationVM.updateProfile()
                            }
                        }
                    }) {
                        CoralButton(strLabel: "Sign in")
                    }
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                                .frame(height: 5)
                            
                            Button(action: {
                                self.showForgotPassword = true
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.black)
                                    .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                                
                            }
                            .sheet(isPresented: self.$showForgotPassword) {
                                ForgotPasswordView()
                                //dismiss once confirmation alert is sent
                            }
                            
                        }.padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    }
                    
                    HStack{
                        
                        VStack{
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

                        AppleSignInButton()
                        .frame(width: 100, height: 50)
                            .onTapGesture {
                                self.showAppleLogin()
                        }

                        Button(action: {
                            self.logginFb()
                        }){
                            SocialMediaButton(imgName: "continue_with_facebook")
                            .frame(width: 100, height: 50)
                        }
                    }
                
                VStack(spacing: 20){
                    Button(action: {
                            self.user.showOnboarding = false
                    }){
                        GuestButton(strLabel: "Sign in as a Guest")
                    }
                        
                    Button(action: {
                    }, label: {
                        NavigationLink(destination: SignUpView()) {
                            Text("New User? Create an account")
                            .foregroundColor(.black)
                            .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                        }
                        
                    })
                }
            }
            }
        }else{
                AppView()
            }
        }.onAppear(perform: {
            self.email = ""
            self.password = ""
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil, queue: .main) { (Notification) in
                self.user.showOnboarding = false
                self.user.isLogged = true
            }
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert, content: { self.alert })
    }
    
    func logginFb() {
        socialLogin.attemptLoginFb(completion: { result, error in
            if(error == nil){
                print("made it")
                self.user.isLogged = true
                self.user.showOnboarding = false
            }else{
                //create alert saying no account associated with this FB profile. Please use sign up page
                //make case for the error that comes when above happens
                self.alertMessage = "No account associated with this Facebook profile. Please create a new account."
                self.alertTitle = "Error!"
                self.showAlert.toggle()
            }
        })
    }
    
    private func performExistingAccountFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()
        ]
        performSignIn(using: requests)
    }
    
    private func showAppleLogin(){
        let request = ASAuthorizationAppleIDProvider()
        .createRequest()
        request.requestedScopes = [
            .fullName, .email
        ]
        performSignIn(using: [request])
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]){
        login = true
        signUp = false
        print("here")
        delegate = SignInWithAppleDelegates(window: window, currentNonce: currentNonce!){ result in
            switch result {
            case .success(_):
                //already created a new account or signed in
                print("here")
                self.alertMessage = "You have successfully logged in through Apple"
                self.alertTitle = "Success!"
                self.showAlert.toggle()
                self.user.showOnboarding = false
                self.user.isLogged = true
            case .failure(let error):
                //send alert
                self.alertMessage = "\(error.localizedDescription)"
                self.alertTitle = "Error!"
                self.showAlert.toggle()
            }
        }
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = delegate
        controller.presentationContextProvider = delegate
        controller.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
    struct SocialLogin: UIViewRepresentable {
        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            login = true
            signUp = false
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
            
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            var dispatch = DispatchGroup()
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            print("logged out")
            
            fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                print("RESULT: '\(result)' ")

                if error != nil {
                    print("error")
                    return
                }else if(result!.isCancelled){
                    print("result cancelled")
                    return
                }
                
                if(!result!.isCancelled){
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        //authresult = Promise of UserCredential
                        print("signing in")
                        if(authResult != nil){
                            print("authorized")
                            print(authResult?.additionalUserInfo?.profile)
                            let userInfo = authResult?.additionalUserInfo?.profile
                            if let userInfo = userInfo as? [String:Any],
                                                       let email: String = userInfo["email"] as? String,
                                                       let name: String = userInfo["name"] as? String,
                                                       let picture = userInfo["picture"] as? [String: Any],
                                                       let data = picture["data"] as? [String: Any],
                                let url = data["url"] as? String {
                                    userProfile.fullName = name
                                    userProfile.emailAddress = email
                                    userProfile.profilePhotoURL = url
                                    print(userProfile.emailAddress)
                                    print(userProfile.fullName)
                                    dispatch.enter()
                                    userProfile.userId = Auth.auth().currentUser!.uid
                                    dispatch.notify(queue: .main) {
                                        dispatch.enter()
                                        userProfile.getProfilePhoto(dispatch: dispatch)
                                        dispatch.notify(queue: .main){
                                            completion(result, error)
                                            return
                                        }
                                    }
                            }
                            //need to check if user exists with password, if so, then get pic
                            Auth.auth().fetchSignInMethods(forEmail: userProfile.emailAddress) { (methods, error) in
                                if(methods!.count > 1){
                                    dispatch.enter()
                                    userProfile.getProfilePhoto(dispatch: dispatch)
                                    dispatch.notify(queue: .main){
                                        completion(result, error)
                                        return
                                    }
                                }
                                }
                                completion(result, error)
                                return
                        }
                        else{
                            //no account exists with this FB profile -> alert saying "please go to sign up"
                            print("no account exists")
                            print(error.debugDescription)
                            completion(result, error)
                            return
                        }
                    }
                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedin: .constant(false))
    }
}
