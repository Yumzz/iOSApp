//
//  ForgotPassword.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/20/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    @State var showAlert = false
    @State var alertMsg = ""
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    @ObservedObject var forgotPassword = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    @State var isNavigationBarHidden: Bool = true
    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            Color("DarkBack").edgesIgnoringSafeArea(.all)
            Spacer().frame(width: UIScreen.main.bounds.width, height: 0)
            VStack{
                Text("Retrieve Your Account")
                    .foregroundColor(Color("WhiteTextGrey"))
                    .font(.largeTitle).bold()
                    .font(.system(size: 36))
                    .padding(.leading, 40)
//                    .padding(.trailing, 40)
            }.position(x: UIScreen.main.bounds.width/2.5, y: 20)
            VStack{

                CustomTextField(field: "Email", strLabel: "jonnyives@apple.com", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress).foregroundColor(.black)
                    
                Spacer().frame(height: 30)

                    
                    Button(action: {
                        let val = self.forgotPassword.forgotPasswordValidInputs(email: self.email)
                        print("val: \(val)")
                        if (val == "") {
                            print("valhere")
                            let e = self.email
                            self.email = ""
                            self.alertTitle = "Email was sent"
                            self.alertMsg = "Use email to reset password"
                            self.showAlert.toggle()
                            let x = self.forgotPassword.passwordReset(email: e)
                            if(x == ""){
                                self.alertTitle = "Email was sent"
                                self.showAlert.toggle()
                            }
                            else{
                                self.alertTitle = x
                                self.alertMsg = "Email not reachable"
                                self.showAlert.toggle()
                            }
                        }
                        else{
                            print("valnotthere")
                            self.alertTitle = "Email unable to be sent"
                            self.alertMsg = val
                            self.showAlert.toggle()
                        }
                    }) {
                        OrangeButton(strLabel: "Reset your Password", width: 330, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    }
//                        .alert(isPresented: $showingAlert) {
//                            Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
//                        }
            }
            Spacer().frame(height: 120)

        }
//        .alert(isPresented: $showAlert, content: { self.alert })
        .navigationBarTitle("")
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(mode: self.mode))
        .onAppear(){
            self.isNavigationBarHidden = false
        }
        .onDisappear(){
            self.isNavigationBarHidden = true

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMsg)"), dismissButton: .default(Text("Got it!")))
            }

//        .navigationBarBackButtonHidden(true)
//        .navigationBarTitle("")

}
    
}

struct ModalView: View {
    
  var body: some View {
    Group {
      Text("Modal view")
      
    }
  }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
        
    }
}
