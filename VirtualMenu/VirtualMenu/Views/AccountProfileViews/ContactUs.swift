//
//  ContactUs.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/16/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct ContactUs: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var messageBody: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State var show = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Let's have a chat")
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
                    Text("What's on your mind?")
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    MultiLineTFContact(txt: $messageBody)
                        .border(Color.gray.opacity(0.5), width: 1)
                        .padding(.leading, (UIScreen.main.bounds.width * 10) / 414)
                        .padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                }
                Spacer()
                    .frame(height: CGFloat(15))
                Button(action: {
                    self.show.toggle()
                    if isValidInput(inputVal: self.email) && isValidInput(inputVal: self.name) && isValidInput(inputVal: self.messageBody) {
                        let url = URL(string: Constants.baseURL.api + "/feedback")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        let bodyData = "name=\(self.name)&email=\(self.email)&message=\(self.messageBody)&Type=Contact"
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
                }) {
                    Text("Send")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
                Spacer()
                if self.show{
                    GeometryReader{_ in
                        
                        Loader()
                    }.background(Color.black.opacity(0.45))
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
//            .blur(radius: self.show ? 15 : 0)

        }
        
    }
}

struct MultiLineTFContact: UIViewRepresentable {

    @Binding var txt: String

    func makeUIView(context: UIViewRepresentableContext<MultiLineTFContact>) -> MultiLineTFContact.UIViewType {
        let tview = UITextView()
        tview.layer.cornerRadius = 20.0
        tview.font = .systemFont(ofSize: 16)
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        tview.text = "Tell us anything you want"
        tview.delegate = context.coordinator
        tview.textColor = .gray
        tview.returnKeyType = .continue
        return tview
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTFContact>) {

    }

    func makeCoordinator() -> MultiLineTFContact.Coordinator {
        return MultiLineTFContact.Coordinator(parent1: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: MultiLineTFContact

        init(parent1: MultiLineTFContact) {
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

struct ContactUs_Previews: PreviewProvider {
    static var previews: some View {
        ContactUs()
    }
}

struct Loader: View {
    
    @State var animate = false
    var body: some View {
        
        VStack{
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [.orange, .red]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            
            Text("Please Wait...").padding(.top)
            
        }
        .background(Color.white)
        .cornerRadius(15)
            
        .onAppear {
            self.animate.toggle()
        }
        
    }
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
