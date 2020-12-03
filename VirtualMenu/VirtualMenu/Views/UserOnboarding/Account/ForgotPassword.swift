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
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            Spacer().frame(width: UIScreen.main.bounds.width, height: 0)
            VStack{
                Text("Retrieve Your Account")
                    .foregroundColor(ColorManager.textGray)
                    .font(.largeTitle).bold()
                    .font(.system(size: 36))
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
            }.position(x: UIScreen.main.bounds.width/2.5, y: 20)
            VStack{

                CustomTextField(field: "Email", strLabel: "jonnyives@apple.com", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    
                Spacer().frame(height: 30)

                    
                    Button(action: {
                        let val = self.forgotPassword.forgotPasswordValidInputs(email: self.email)
                        if (val == "") {
                            let x = self.forgotPassword.passwordReset(email: self.email)
                            if(x == ""){
                                self.alertMsg = "Email was sent"
                                self.showAlert.toggle()
                            }
                        }
                        else{
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
