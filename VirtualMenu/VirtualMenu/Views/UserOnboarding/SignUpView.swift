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
import AuthenticationServices
import CryptoKit

var signUp = false
var login = false
var facebook = false
var google = false
var credential: AuthCredential? = nil

struct SignUpView: View {
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    @State var currentNonce: String? = ""
    
    @State var alertMsg = ""
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var showAlert = false
    @State var showDetails = false
    
    @State var createdAccount = false
    var socialLogin = SocialLogin()
    
    @EnvironmentObject var user: UserStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    

    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            if user.showOnboarding {
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
                        self.showAlert = false
                        let actionCode = ActionCodeSettings()
                        actionCode.url = URL(string: "https://yumzzapp.page.link/connect")
                        actionCode.handleCodeInApp = true
                        actionCode.setIOSBundleID(Bundle.main.bundleIdentifier!)
                        Auth.auth().sendSignInLink(toEmail: self.email, actionCodeSettings: actionCode) { (error) in
            //                            self.user.showOnboarding = false
                            if let error = error {
                                self.alertMessage = error.localizedDescription
                                self.alertTitle = "Error!"
                                self.showAlert.toggle()
                              return
                            }
                            UserDefaults.standard.set(self.email, forKey: "Email")
                            UserDefaults.standard.set(self.name, forKey: "Name")
                            UserDefaults.standard.set(self.password, forKey: "Password")
                            self.alertMessage = "A confirmation email was sent to \(self.email). Please click the link to sign in!"
                            self.alertTitle = "Email Sent!"
                            self.showAlert.toggle()
                        }
            //                print("just ended button action")
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

                        AppleSignInButton()
                        .frame(width: 100, height: 50)
                            .onTapGesture {
                                self.showAppleLogin()
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
            }else{
                AppView()
            }
        }.onAppear(perform: {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil, queue: .main) { (Notification) in
                self.user.showOnboarding = false
                self.user.isLogged = true
            }
        })
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: PinkBackButton(mode: self.mode))
    }
    
    
    func signinInFb() {
        socialLogin.attemptLoginFb(completion: { result, error in
            if(error == nil){
            }else{
                //create alert saying no account associated with this FB profile. Please use sign up page
                self.alertMessage = "\(error!.localizedDescription)"
                self.alertTitle = "Error!"
                self.showAlert.toggle()
            }
            facebook = false
            signUp = false
        })
    }

    private func performExistingAccountFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()
        ]
        performSignUp(using: requests)
    }
    
    private func showAppleLogin(){
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider()
        .createRequest()
        request.requestedScopes = [
            .fullName, .email
        ]
        performSignUp(using: [request])
        request.nonce = sha256(nonce)
    }
    
    private func performSignUp(using requests: [ASAuthorizationRequest]){
        login = false
        signUp = true
        print("here")
        delegate = SignInWithAppleDelegates(window: window, currentNonce: currentNonce!){ result in
            switch result {
            case .success(let user):
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
            facebook = true
            google = false
            signUp = true
            login = false
            fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                print("RESULT: '\(result)' ")
                let authen = AuthenticationViewModel()
                if error != nil {
                    print("error")
                }else if(result!.isCancelled){
                    print("result cancelled")
                }else if(!result!.isCancelled){
                    //create a userProfile based on FB info
                    credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    print("success Get user information.")
                    

                    let fbRequest = GraphRequest(graphPath:"me", parameters: ["fields":"email, name, picture"])
                    fbRequest.start { (connection, infoResult, error) -> Void in
                        
                    if error == nil {
                        print("User Info : \(infoResult ?? "No result")")
                        print(infoResult.unsafelyUnwrapped)
                        print(credential!.description)
                        
                        if let infoResult = infoResult as? [String:Any],
                            let email: String = infoResult["email"] as? String,
                            let name: String = infoResult["name"] as? String,
                            let picture = infoResult["picture"] as? [String: Any],
                            let data = picture["data"] as? [String: Any],
                            let url = data["url"] as? String
                            {
                            UserDefaults.standard.set(email, forKey: "Email")
                            UserDefaults.standard.set(name, forKey: "Name")
//                            let dispatchTwo = DispatchGroup()
                            let actionCode = ActionCodeSettings()
                            actionCode.url = URL(string: "https://yumzzapp.page.link/connect")
                            actionCode.handleCodeInApp = true
                            actionCode.setIOSBundleID(Bundle.main.bundleIdentifier!)
                            self.dispatch.enter()
                            
                            Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCode) { (error) in
    //                            self.user.showOnboarding = false
                                if let error = error {
                                  return
                                }
                                userProfile.emailAddress = email
                                userProfile.fullName = name
                                userProfile.profilePhotoURL = url
                                self.dispatch.leave()
                            }
                            self.dispatch.notify(queue: .main){
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
