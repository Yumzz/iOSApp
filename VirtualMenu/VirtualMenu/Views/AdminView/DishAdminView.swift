//
//  DishAdminView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct DishAdminView: View {
    @State var description: String = ""
    @State var name: String = ""
    @State var price: String = ""
    @State var restaurant: String = ""
    @State var type: String = ""

    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State var show = false
    @State private var alertTitle = ""
    @State private var textStyle = UIFont.TextStyle.body

    
    
    var body: some View {
            VStack{
                VStack(spacing: 30){
               TextView(text: self.$description, textStyle: self.$textStyle)
                    .border(Color.gray.opacity(0.5), width: 1)
                    .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                    .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
//                CustomTextField(strLabel: "Description", strField: $description, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    CustomTextField(field: "Name", strLabel: "Salmon", strField: $name, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    CustomTextField(field: "Price", strLabel: "$7.00", strField: $price, uiTextAutoCapitalizationType: .none, uiKeyboardType: .decimalPad)
                    CustomTextField(field: "Restaurant", strLabel: "Fabio's Fish", strField: $restaurant, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    CustomTextField(field: "Type", strLabel: "Fish", strField: $type, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                }
                                
                VStack{
                Button(action: {
                        if isValidInput(inputVal: self.description) && isValidInput(inputVal: self.name) && isValidInput(inputVal: self.restaurant) && isValidInput(inputVal: self.type){
                            let url = URL(string: Constants.baseURL.api + "/dishAdd")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            let bodyData = "Name=\(self.name)&Description=\(self.description)&Price=\(self.price)&Type=\(self.type)&Restaurant=\(self.restaurant)"
                            print(bodyData)
                            request.httpBody = bodyData.data(using: .utf8)

                            URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let httpResponse = response as? HTTPURLResponse,
                                      (200...299).contains(httpResponse.statusCode) else {
                                        self.showingAlert = true
                                        self.show.toggle()
                                        self.alertTitle = "Network Error"
                                        self.alertMessage = "There was a Network Error while processing your request"
                                    return
                                }
                                self.show.toggle()
                                self.showingAlert = true
                                self.alertTitle = "Request Submitted!"
                                self.alertMessage = "Our team will respond shortly"
                            }.resume()
                        } else {
                            self.show.toggle()
                            self.showingAlert = true
                            self.alertTitle = "Missing Field(s)"
                            self.alertMessage = "Please ensure all three fields are filled out"
                        }
                }){
                    Text("Enter Data")
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
            }
            }
    }
}

struct DishAdminView_Previews: PreviewProvider {
    static var previews: some View {
        DishAdminView()
    }
}

struct MultiLineTFDishAdmin: UIViewRepresentable {

    @Binding var txt: String

    func makeUIView(context: UIViewRepresentableContext<MultiLineTFDishAdmin>) -> MultiLineTFDishAdmin.UIViewType {
        let tview = UITextView()
        tview.layer.cornerRadius = 20.0
        tview.font = .systemFont(ofSize: 16)
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        tview.text = "Description"
        tview.delegate = context.coordinator
        tview.textColor = .gray
        tview.returnKeyType = .continue
        return tview
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTFDishAdmin>) {

    }

    func makeCoordinator() -> MultiLineTFDishAdmin.Coordinator {
        return MultiLineTFDishAdmin.Coordinator(parent1: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: MultiLineTFDishAdmin

        init(parent1: MultiLineTFDishAdmin) {
            parent = parent1
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .label
        }
    }
}
