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

    
    @ObservedObject var FirebaseFunctions = FirebaseFunctionsViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Did we miss a place?")
                        .font(.custom("Futura Bold", size: 22))
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading) {
                    Text("Where should we email you back?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
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
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    Spacer()
                        .frame(height: CGFloat(30))
                }
                VStack (alignment: .leading, spacing: 15) {
                    Text("What's the address?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    TextView(text: self.$messageBody, textStyle: self.$textStyle)
                        .padding(.horizontal)
                        .border(Color.gray.opacity(0.5), width: 1)
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                }
                Spacer()
                    .frame(height: CGFloat(15))
                Button(action: {
                    let results = self.FirebaseFunctions.suggestRestaurantButton(email: self.email, messageBody: self.messageBody, name: self.name)
                    let result = results[0]
                    let title = results[1]
                    print(result)
                    if(result == ""){
                        return
                    }
                    else{
                        self.alertTitle = title
                        self.alertMessage = result
                        self.showingAlert.toggle()
                    }
                }) {
                    Text("Send")
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

struct MultiLineTFSuggestRestaurant: UIViewRepresentable {

    @Binding var txt: String

    func makeUIView(context: UIViewRepresentableContext<MultiLineTFSuggestRestaurant>) -> MultiLineTFSuggestRestaurant.UIViewType {
        let tview = UITextView()
        tview.layer.cornerRadius = 20.0
        tview.font = .systemFont(ofSize: 16)
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        tview.text = "The street address, city, state, and zip code would help us out tremendously!"
        tview.delegate = context.coordinator
        tview.textColor = .gray
        tview.returnKeyType = .continue
        return tview
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTFSuggestRestaurant>) {

    }

    func makeCoordinator() -> MultiLineTFSuggestRestaurant.Coordinator {
        return MultiLineTFSuggestRestaurant.Coordinator(parent1: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: MultiLineTFSuggestRestaurant

        init(parent1: MultiLineTFSuggestRestaurant) {
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

struct SuggestRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        SuggestRestaurant()
    }
}
