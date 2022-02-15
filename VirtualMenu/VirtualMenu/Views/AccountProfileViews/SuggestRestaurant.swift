//
//  SuggestRestauratn.swift
//
//
//  Created by Rohan Tyagi on 7/16/20.
//

import SwiftUI

struct SuggestRestaurant: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var messageBody: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var textStyle = UIFont.TextStyle.body

    
    @ObservedObject var suggestVM = SuggestRestaurantViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Did we miss a place?")
                        .font(.custom("Futura Bold", size: 22))
                        .foregroundColor(Color("OrangeWhite"))
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading) {
                    Text("Where should we email you back?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                        .foregroundColor(Color("OrangeWhite"))
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading) {
                    Text("What is your name?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                        .foregroundColor(Color("OrangeWhite"))
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading, spacing: 15) {
                    TextView(text: self.$messageBody, textStyle: self.$textStyle)
                        .padding(.horizontal)
                }
                Spacer()
                    .frame(height: CGFloat(15))
                Button(action: {
                    let dispatch = DispatchGroup()
                    self.suggestVM.sendResponse(email: self.email, messageBody: self.messageBody, name: self.name, disp: dispatch)
                    self.alertMessage = self.suggestVM.alertMessage
                    self.alertTitle = self.suggestVM.alertTitle
                    self.showingAlert.toggle()

                }) {
                    Text("Send")
                        .foregroundColor(Color("WhiteOrange"))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}


struct SuggestRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        SuggestRestaurant()
    }
}
