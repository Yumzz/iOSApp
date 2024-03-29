//
//  ReportProblem.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/16/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct ReportProblem: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var messageBody: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var textStyle = UIFont.TextStyle.body


    
    @ObservedObject var reportVM = ReportProblemViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("What did we mess up on?")
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
                    self.reportVM.sendResponse(email: self.email, messageBody: self.messageBody, name: self.name, disp: dispatch)
                    self.alertMessage = self.reportVM.alertMessage
                    self.alertTitle = self.reportVM.alertTitle
                    self.showingAlert.toggle()
                }) {
                    Text("Send")
                        .foregroundColor(Color("OrangeWhite"))
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

struct MultiLineTFReport: UIViewRepresentable {

    @Binding var txt: String

    func makeUIView(context: UIViewRepresentableContext<MultiLineTFReport>) -> MultiLineTFReport.UIViewType {
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

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTFReport>) {

    }

    func makeCoordinator() -> MultiLineTFReport.Coordinator {
        return MultiLineTFReport.Coordinator(parent1: self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: MultiLineTFReport

        init(parent1: MultiLineTFReport) {
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

struct ReportProblem_Previews: PreviewProvider {
    static var previews: some View {
        ReportProblem()
    }
}

