//
//  SurveyView.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 9/17/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import SwiftUI

import Combine
//import Firebase
//import FirebaseDatabase
//import Alamofire


// TODO: the introspect lib might also be useful
// https://stackoverflow.com/questions/59003612/extend-swiftui-keyboard-with-custom-button

struct TextEditorWithDone: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let textfield = UITextView()
        textfield.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 2)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.items = [spacer, doneButton]
        
        textfield.inputAccessoryView = toolBar
        textfield.delegate = context.coordinator
        return textfield
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
    }
    
}


extension TextEditorWithDone {
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text = textView.text ?? ""
            }
        }
    }
}


extension  UITextView{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}

struct TextFieldWithDone: UIViewRepresentable {
    
    let placeHolder : String
    @Binding var text: String
    var keyType: UIKeyboardType
    let showToolbar = false
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.placeholder = placeHolder
        textfield.keyboardType = keyType
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.autocorrectionType = .no
        textfield.text = text
        
        textfield.addTarget(textfield, action: #selector(textfield.doneButtonTapped(button:)), for: .editingDidEndOnExit)
        
        if showToolbar {
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
            let doneButton = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [spacer, doneButton]
            textfield.inputAccessoryView = toolBar
        }
                
        textfield.delegate = context.coordinator
        return textfield
    }

    func updateUIView(_ view: UITextField, context: Context) {
        view.text = text
    }
}

extension TextFieldWithDone {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    
    @Published private(set) var currentHeight: CGFloat = 0
    @Published private(set) var isShowing: Bool = false

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
        isShowing = true
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
        isShowing = false
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let bgColor : Color
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            //.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            //.frame(width: 104, height: 40)
            
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .frame(minWidth: 104, minHeight: 40)
            
            .background(bgColor)
            .cornerRadius(20.0)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
            
    }
}

struct YesNoButtonStyle: ButtonStyle {
    let bgColor : Color
    init(bgColor: Color = Color.gray) {
        self.bgColor = bgColor
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
            .background(bgColor)
            .cornerRadius(26.0)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
            
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    let extraHeight : CGFloat
    func path(in rect: CGRect) -> Path {
        let rectExtended = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height + extraHeight)
        let path = UIBezierPath(roundedRect: rectExtended,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Extension to do both stroke and fill at same time
extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}


struct BinaryChoiceQuestionView : View {
    
    @State var selectedIndices : Set<Int> = []
    @ObservedObject var question : BinaryQuestion
    
    let onChoiceMade : (() -> Void)?
    
    @State private var autoAdvanceProgress : CGFloat = 0.0
    @State private var goingToNext : Bool = true
    
    var body : some View {
        
        VStack {
            
            //Text(question.title).font(.title).padding(16)
            Text(question.title).font(.title).fontWeight(.bold).padding(16)
            
            //Spacer()
            //Text("Choice2: ".appendingFormat("%i", selectedIndices.count)).opacity(0.5) // view refresh hack
            
            HStack {
                
                Button(action: { selectChoice(0) }, label: {
                    Text(question.choices[0].text).font(.title).bold()
                }).buttonStyle(YesNoButtonStyle(bgColor: selectedIndices.contains(0) ? Color.green : Color.gray))
                .padding(6)
                
                
                Button(action: { selectChoice(1) }, label: {
                    Text(question.choices[1].text).font(.title)
                }).buttonStyle(YesNoButtonStyle(bgColor: selectedIndices.contains(1) ? Color.green : Color.gray))
                .padding(6)
                
                
            }
            //.frame(height: UIScreen.main.bounds.height * 0.6)
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 20))
            
        }.onAppear(perform: {
            self.autoAdvanceProgress = 0
            self.updateChoices()
        })
        .frame(maxWidth: .infinity) // stretch whole width
        //.background(Color.red)
        .overlay(Rectangle().frame(width: autoAdvanceProgress, height: 3, alignment: .top).foregroundColor(Color(.systemBlue)), alignment: .top)
            .animation(.easeInOut(duration: 0.51))
        
    }
    
    // Update the local @State with selected choice
    // TODO: figure out how to directly use the question to update UI
    //        tried observable stuff with no luck
    func updateChoices() {
        selectedIndices = []
        for (i,choice) in question.choices.enumerated() {
            if choice.selected {
                selectedIndices.insert(i)
            }
        }
    }
    
    func selectChoice( _ choiceIndex : Int ) {
        selectedIndices = []
        selectedIndices.insert(choiceIndex)
        //question.choices[choiceIndex].selected = true;
        for (i,choice) in question.choices.enumerated() {
            choice.selected = i == choiceIndex
            question.choices[i].selected = choice.selected
        }
        
        self.goingToNext = true
        if question.autoAdvanceOnChoice {
            self.autoAdvanceProgress = UIScreen.main.bounds.width
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.51) {
            if question.autoAdvanceOnChoice {
                self.onChoiceMade?()
            }
            self.autoAdvanceProgress = 0
        }
        
        
    }
    
}



struct ContactFormQuestionView : View {
    
    @ObservedObject var question : ContactFormQuestion
    
    init(question: ContactFormQuestion ) {
        
        self.question = question
    }
    
    
    var body : some View {
        VStack {
            //Text(question.title).font(.title).padding(16)
            Text(question.title).font(.title).fontWeight(.bold).padding(16)

            VStack(alignment: .leading) {
                Text("Name (optional)")
                    .font(.callout)
                    .bold()
                TextField("Name", text: $question.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
            }.padding()
            
            
            VStack(alignment: .leading) {
                Text("Email Address")
                    .font(.callout)
                    .bold()
                TextField("Email Address", text: $question.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textContentType(.emailAddress)
                    
                    
            }.padding()
            
//            VStack(alignment: .leading) {
//                Text("Company ( optional )")
//                    .font(.callout)
//                    .bold()
//                TextField("Company", text: $question.company)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//            }.padding()
            
            
            VStack(alignment: .leading) {
                Text("Comments ( optional )")
                    .font(.callout)
                    .bold()
                TextField("Comments / Feedback", text: $question.feedback)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
            }.padding()
                    
        }
        
                
    }
    
    
}



struct CommentsFormQuestionView : View {
    
    @ObservedObject var question : CommentsFormQuestion
    
    
    
    var body : some View {
        VStack {
            //Text(question.title).font(.title).padding(16)
            Text(question.title).font(.title).fontWeight(.bold).padding(EdgeInsets(top: 12, leading: 28, bottom: 2, trailing: 28))
            //Text(question.subtitle).font(.title3).background(Color.red).padding(16)
            Text(question.subtitle).font(.title3).italic().foregroundColor(Color(.secondaryLabel))
                .padding(EdgeInsets(top: 0, leading: 28, bottom: 1, trailing: 28))
            
            VStack(alignment: .leading) {
                Text("Email Address")
                    .font(.callout)
                    .bold()
                
                TextFieldWithDone(placeHolder:"Email Address", text: $question.emailAddress, keyType: .emailAddress)
                
                // OR
//                TextField("Email Address", text: $question.emailAddress )
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disableAutocorrection(true)
//                    .textContentType(.emailAddress)
                    
                    
            }.padding()
            
            VStack(alignment: .leading) {

                Text("Comments")
                    .font(.callout)
                    .bold()

                TextEditorWithDone(text: $question.feedback )
                    .disableAutocorrection(true)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke( Color(.systemGray5), lineWidth: 1) )
                    .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))

            }.padding()
            
        
        }
                
    }
    
}


struct InlineMultipleChoiceQuestionGroupView : View {
    
    @ObservedObject var group : InlineMultipleChoiceQuestionGroup
    @State var selectedIndices : Set<Int> = []
    
    @State var customText : String = ""
    
    var body: some View {
        
        VStack {
            Text(group.title).font(.title).fontWeight(.bold).padding(EdgeInsets(top: 12, leading: 12, bottom: 1, trailing: 12))
                
            ForEach(group.questions, id: \.uuid) { inline_question in
                
                if inline_question.choices.first!.allowsCustomTextEntry {
                    
                    //Text("Other")
                    //TextField("Other: ", text: $customText)
                    
//                    MultipleChoiceResponseView(question: inline_question,
//                                               choice: inline_question.choices.first!,
//                                               selectedIndices: $selectedIndices)
                    
                } else {
                InlineMultipleChoiceQuestionView(question: inline_question)
                    .padding(7)
                    //.background(LinearGradient(gradient: Gradient(colors: [Color(.systemGray6).opacity(0.6), Color(.systemGray6).opacity(0.4)]), startPoint: .top, endPoint: .bottom))
                    .background(Color(.systemGray5).opacity(0.15))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray5), lineWidth: 2))
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                }
                    
            }
        }
        .frame(maxWidth: .infinity) // stretch whole width
        
    }
    
}


struct InlineMultipleChoiceQuestionView : View {
    
    @ObservedObject var question : MultipleChoiceQuestion
    @State var selectedChoices : Set<UUID> = []
    
    let colors : [Color] = [.red, .orange, .green]
    private func getColor( _ choice : MultipleChoiceResponse ) -> Color {
        return self.colors[ self.question.choices.firstIndex(where: { $0.uuid == choice.uuid })! ]
    }
    var body: some View {
        
        VStack {
        
            HStack {
                
                //Circle().fill( selectedIndices.contains(2) ? Color.green : Color(.systemGray5)).frame(width: 10, height: 10, alignment: .center).padding(EdgeInsets.init(top: 2, leading: 0, bottom: 0, trailing: 0))
                
                Text(question.title).font(.title3).fontWeight(.semibold).foregroundColor(Color(.label)).opacity(0.8).padding(4)
                Text("".appendingFormat("%i", selectedChoices.count)).opacity(0.5).frame(width: 1, height:1)
                
                //Spacer()
                
            }
        
            
            
            HStack {
                
            ForEach(question.choices, id: \.uuid) { choice in
                
                
                Button(action: { selectChoice(choice) }, label: {
                    
                    Spacer()
                    
                    Text( choice.text )
                        .font(.system(size: 14, weight: choice.selected ? .bold : .semibold)).multilineTextAlignment(.center)
                        .foregroundColor( choice.selected ? Color(.label ) : Color(.label ).opacity(0.65) )
                        .scaledToFill()
                        
                        .padding(2)
                    
                    Spacer()
                    
                    
                })
                .frame(width: 100, height: 40)
                
                .background(getColor(choice).opacity( choice.selected ? 0.25 : 0.1 ))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke( choice.selected ? getColor(choice) : getColor(choice).opacity(0.0), lineWidth: 2) )
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .padding(4)
                
                .opacity( (selectedChoices.count > 0 && !selectedChoices.contains(choice.uuid)) ? 0.5 : 1.0 )
                
                //.cornerRadius(28)
                //.border(Color(.systemGray3), width: 1)
                //.padding(EdgeInsets.init(top: 5, leading: 35, bottom: 12, trailing: 35))
                //.border(Color.black)
                
    
                
                
            }
            }
            
        }
//        .overlay(Rectangle().frame(width: 180, height: 1, alignment: .top).foregroundColor(Color(.systemGray5)), alignment: .top)

        
    }
    
    
    func selectChoice( _ selectedChoice : MultipleChoiceResponse ) {
        // required to refresh the view ...
        // not sure how to do it automatically
        
        // when new choice == choice in list :
        //  - if its in there, remove it
        //  - if not add it
        // else
        //  - only remove if multiple
        
        
        if question.allowsMultipleSelection {

            assert(false) // TODO: fix

        } else {

            selectedChoices = []
            
            for choice in question.choices {
                if selectedChoice.uuid == choice.uuid {
                    choice.selected = true;
                    selectedChoices = [choice.uuid]
                } else {
                    choice.selected = false;
                }

            }

        }
        
    }
    
    
}




struct MultipleChoiceResponseView : View {
    
    @ObservedObject var question : MultipleChoiceQuestion
    @ObservedObject var choice : MultipleChoiceResponse
    
    @Binding public var selectedIndices : Set<Int>
    
    var scrollProxy : ScrollViewProxy
    
    @State private var customTextEntry: String = ""
    
    static let OtherTextFieldID : Int = 8919
    
    var body : some View {
        
        VStack {
                        
            
            Button(action: { selectChoice(choice) }, label: {
                
                Circle().fill(choice.selected ? Color.green : Color(.systemGray5)).frame(width: 30, height: 30, alignment: .center).padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .overlay(
                        choice.selected ?
                            Image(systemName: "checkmark").foregroundColor(.white)
                            .padding(EdgeInsets(top:0, leading: 20, bottom: 0, trailing: 0)): nil
                        
                    )
                    
                Text( choice.text )
                    .font( .title3)
                    .fontWeight( choice.selected ? .bold : .regular )
                    .foregroundColor( Color(.label ) )
                    .padding()
                    .scaledToFit()
                

                Spacer()
                
                
            })
            
            
            .cornerRadius(selectedIndices.count == 0 ? 28 : 28)
            .overlay(RoundedRectangle(cornerRadius: 28)
                        .stroke( choice.selected ? Color.green : Color(.systemGray5), lineWidth: 2) )
            .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
            .padding(EdgeInsets.init(top: 3, leading: 35, bottom: 3, trailing: 35))
            
            
            if choice.allowsCustomTextEntry && choice.selected {
                
                HStack {
                    
                    TextFieldWithDone(placeHolder:"Tap to Edit!", text: $customTextEntry, keyType: .default)
                        .onChange(of: customTextEntry, perform: { value in
                            self.updateCustomText(choice, value)
                        })
                        .padding(EdgeInsets(top: 16, leading: 10, bottom: 3, trailing: 10))
                        .foregroundColor(Color(.systemGray2))
                        .id(Self.OtherTextFieldID)

                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.scrollProxy.scrollTo(Self.OtherTextFieldID, anchor: .bottom)

                                if let text = choice.customTextEntry {
                                    self.customTextEntry = text
                                }
                            }
                        })
                    
                }
                
                
                .background(
                    RoundedCornersShape(corners: [.bottomLeft, .bottomRight], radius: 14, extraHeight: 22)
                        .fill(Color(.systemGray6), strokeBorder: Color(.systemGray2), lineWidth: 2)
                        //.stroke(Color(UIColor.systemGray6), lineWidth: 5)
                        .offset(y:-14)
                )
                .padding(EdgeInsets.init(top: 5, leading: 35, bottom: 12, trailing: 35))
                .offset(y: -24.0)
                .zIndex(-1)
                
                
                
            }
            
        }
        
    }
    
    
    
    func selectChoice( _ selectedChoice : MultipleChoiceResponse ) {
        // required to refresh the view ...
        // not sure how to do it automatically
        //selectedChoiceIndex = -1
        
        if question.allowsMultipleSelection {
            
            for (i,choice) in question.choices.enumerated() {
                if selectedChoice.uuid == choice.uuid {
                    if selectedIndices.contains(i) {
                        selectedIndices.remove(i)
                        question.choices[i].selected = false;
                        selectedChoice.selected = false;
                    } else {
                        selectedIndices.insert(i)
                        question.choices[i].selected = true;
                        selectedChoice.selected = true;
                    }
                    
                }
                
            }
            
        } else {
            
            selectedIndices = []
            for (i,choice) in question.choices.enumerated() {
                if selectedChoice.uuid == choice.uuid {
                    choice.selected = true;
                    selectedIndices = [i]
                } else {
                    choice.selected = false;
                }
                
            }
            
        }
        
        if ( selectedChoice.allowsCustomTextEntry && selectedChoice.selected ) {
            //self.scrollProxy.scrollTo(OtherTextFieldID)
        }
        
        
    }
    
    func updateCustomText( _ selectedChoice : MultipleChoiceResponse, _ text : String ) {
        
        for (i,choice) in question.choices.enumerated() {
            if selectedChoice.uuid == choice.uuid {
                question.choices[i].customTextEntry = text
                selectedChoice.customTextEntry = text
            }
        }
        
    }
    
}

struct MultipleChoiceQuestionView : View {
    
    @ObservedObject var question : MultipleChoiceQuestion
    var scrollProxy : ScrollViewProxy
    
    // @State hack required to update view it seems
    @State var selectedIndices : Set<Int> = []
    
    @State private var customTextEntry: String = ""
    
    
    var body: some View {
        VStack {
                    
        Text(question.title).font(.title).fontWeight(.bold).padding(EdgeInsets(top:14, leading: 16, bottom: 8, trailing: 16))
            
        if question.allowsMultipleSelection {
            Text("Pick as many as you want").font(.title3).italic().foregroundColor(Color(.secondaryLabel))
        }
            
        ForEach(question.choices, id: \.uuid) { choice in
            
            MultipleChoiceResponseView(question: question,
                                       choice: choice,
                                       selectedIndices: $selectedIndices,
                                       scrollProxy: scrollProxy)
            
        } // end ForEach
            
        }
        .frame(maxWidth: .infinity) // stretch whole width
        .background(Color.white)
        
    }
    
    func selectChoice( _ selectedChoice : MultipleChoiceResponse ) {
        // required to refresh the view ...
        // not sure how to do it automatically
        //selectedChoiceIndex = -1
        if question.allowsMultipleSelection {
            
            for (i,choice) in question.choices.enumerated() {
                if selectedChoice.uuid == choice.uuid {
                    if selectedIndices.contains(i) {
                        selectedIndices.remove(i)
                        question.choices[i].selected = false;
                        selectedChoice.selected = false;
                    } else {
                        selectedIndices.insert(i)
                        question.choices[i].selected = true;
                        selectedChoice.selected = true;
                    }
                    
                }
                
            }
            
        } else {
            
            selectedIndices = []
            for (i,choice) in question.choices.enumerated() {
                if selectedChoice.uuid == choice.uuid {
                    choice.selected = true;
                    selectedIndices = [i]
                } else {
                    choice.selected = false;
                }
                
            }
            
        }
        
    }
    
    func updateCustomText( _ selectedChoice : MultipleChoiceResponse, _ text : String ) {
        
        for (i,choice) in question.choices.enumerated() {
            if selectedChoice.uuid == choice.uuid {
                question.choices[i].customTextEntry = text
                selectedChoice.customTextEntry = text
            }
        }
        
    }
    
}



protocol SurveyViewDelegate : AnyObject {
    func surveyCompleted( with survey : Survey )
    func surveyDeclined()
    func surveyRemindMeLater()
}

struct SurveyView: View {
    
    @ObservedObject var survey : Survey
    
    @State var currentQuestion : Int = 0
    
    enum SurveyState {
        case showingIntroScreen
        case taking
        case complete
        case code
    }
    
    @State var surveyState : SurveyState = .showingIntroScreen
    @State var processing = false
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var delegate : SurveyViewDelegate?
    
    init(survey: Survey, delegate : SurveyViewDelegate? = nil) {
        self.survey = survey
        self.delegate = delegate
    }
    
    
    var body: some View {
        
        if surveyState == .showingIntroScreen {
            
            // TODO: break out into IntroView
            VStack {
                                
                HStack {
                    
                    Image(uiImage: UIImage(named: "SurveyAppIcon")?.resizeImageTo(size: CGSize(width: 100, height: 100)) ?? UIImage())
//                    Text("👋").font(.system(size: 80))
//                    Text("😀").font(.system(size: 100))
                }.padding(EdgeInsets(top: 50, leading: 0, bottom: 20, trailing: 0))
                
                Text("Want a discount?").font(.system(size: 45)).multilineTextAlignment(.center)
              
                Text("Take survey. Get a code.").font(.title).padding(30).multilineTextAlignment(.center)
                
                Text("$5 off for every $30+ order").font(.title2).padding(EdgeInsets(top: 0, leading: 40, bottom: 10, trailing: 45)).multilineTextAlignment(.center)
                
                HStack {
                    
//                    Button(action: { self.remindMeLaterTapped() }, label: {
//                        Text("Remind Me").foregroundColor(Color(.secondaryLabel)).bold().padding(15)
//                    }).buttonStyle(CustomButtonStyle(bgColor: Color(.systemGray5)))
//                    .padding(5)
                
                    Button(action: { self.takeSurveyTapped() }, label: {
                    Text("Take Survey").bold().padding(15)
                    }).buttonStyle(CustomButtonStyle(bgColor: Color.blue))
                    .padding(5)
                                    
                
                }.padding()
                
                Button(action: { self.noThanksTapped() }, label: {
                    Text("No Thanks")
                }).padding()
            }
        }
        else if surveyState == .complete {
        //if true {
            
            VStack {
                
                Image(uiImage: UIImage(named: "AppIcon")?.resizeImageTo(size: CGSize(width: 100, height: 100)) ?? UIImage())
//                Text("👍").font(.system(size: 120)).padding(EdgeInsets(top: 60, leading: 0, bottom: 20, trailing: 0))
                
                Text("Thanks!").font(.system(size: 45)).multilineTextAlignment(.center)
              
//                Text("Here is your code: C42A45Y").font(.title).padding(30).multilineTextAlignment(.center)
                Text("Submit Survey for Discount Code").font(.title).padding(30).multilineTextAlignment(.center)
                
                ProgressView()
                    .opacity( processing ? 1.0 : 0.0 )
                
                Button(action: { submitSurveyTapped() }, label: {
                    Text("Submit Survey").bold()
                }).buttonStyle(CustomButtonStyle(bgColor: Color.blue)).padding()
                //.enabled( !self.processing )
                
            
                Button(action: { self.restartSurveyTapped() }, label: {
                    Text("Retake Survey")
                }).padding()
            }
            
        }
        else if surveyState == .code{
            
            VStack {
                
                
                Text("Thanks!").font(.system(size: 45)).multilineTextAlignment(.center)
              
//                Text("Here is your code: C42A45Y").font(.title).padding(30).multilineTextAlignment(.center)
                Text("Here is your code: C42A45Y").font(.title).padding(30).multilineTextAlignment(.center)
                
            }
//            .onAppear(){
//            }
            
        }
        
        else {
        
            VStack(spacing:0) {
                                    
            Text("Question ".appendingFormat("%i / %i", currentQuestion+1, self.survey.questions.count))
                .bold().padding(EdgeInsets(top: 5, leading: 0, bottom: 2, trailing: 0))
                .frame(maxWidth: .infinity)
                        
                
                ForEach(survey.questions.indices, id: \.self) { i in
                    
                    if i == currentQuestion {
                        
                        ScrollViewReader { proxy in
                        ScrollView {
                            
                            if let question = survey.questions[currentQuestion] as? MultipleChoiceQuestion {
                                MultipleChoiceQuestionView(question: question, scrollProxy: proxy )
                            } else if let question = survey.questions[currentQuestion] as? BinaryQuestion {
                                BinaryChoiceQuestionView(question: question, onChoiceMade: { nextTapped() })
                            } else if let question = survey.questions[currentQuestion] as? ContactFormQuestion {
                                ContactFormQuestionView(question: question)
                            } else if let question = survey.questions[currentQuestion] as? CommentsFormQuestion {
                                CommentsFormQuestionView(question: question)
                            } else if let question = survey.questions[currentQuestion] as? InlineMultipleChoiceQuestionGroup {
                                InlineMultipleChoiceQuestionGroupView(group: question)
                            
                            }
                            
                            // Space filling rect for extra scroll with transparent prev/next bar
                            //Rectangle().fill(Color.clear).frame(width: 2, height: 2).id(bottomID)
                            
                        }
                        .background(Color.white)
//                        .keyboardAware()
                        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.systemGray4)), alignment: .top)
                        }


                    }
                }
                
                
                
                
                HStack() {
                                    
                    Button(action: { previousTapped() }, label: {
                        Text("Previous").foregroundColor(Color(.secondaryLabel)).bold()
                    }).buttonStyle(CustomButtonStyle(bgColor: Color(.systemGray5)))
                    
                    Spacer()
                    Button(action: { nextTapped() }, label: {
                        Text("Next").bold()
                    }).buttonStyle(CustomButtonStyle(bgColor: Color.blue))
                                    
                }.padding(EdgeInsets(top: 12, leading: 22, bottom: 18, trailing: 22))
                    
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea( [.leading, .trailing] )
                

                
            }
            .background(Color.white)
            
            /*
             // For semi transparent overlay of prev/next bar to show more content
             // underneat that is scrollable ...
             // downside is the 'other' choice expands to have text field that is hidden
            .overlay(
                
                HStack() {
                                    
                    Button(action: { previousTapped() }, label: {
                        Text("Previous").foregroundColor(Color(.secondaryLabel)).bold()
                    }).buttonStyle(CustomButtonStyle(bgColor: Color(.systemGray5)))
                    
                    Spacer()
                    Button(action: { nextTapped() }, label: {
                        Text("Next").bold()
                    }).buttonStyle(CustomButtonStyle(bgColor: Color.blue))
                                    
                }.padding(18)
                    
                .background(Color(.systemGray6).opacity(0.75))
                .edgesIgnoringSafeArea( [.leading, .trailing] )
                , alignment: .bottom
            )
            */
            .edgesIgnoringSafeArea( .bottom )
            //.background(Color.red)
            
        }
        
    }
    
    private func closeKeyboard() {
        UIApplication.shared.endEditing()
    }
    
    
    func previousTapped() {
        var i = self.currentQuestion
        
        while i > 0 {
            i = i - 1
            
            let question = survey.questions[i]
            if question.isVisible(for: survey) {
                self.currentQuestion = i
                break
            }
        }
        
    }
    
    func nextTapped() {
        
        if self.currentQuestion == survey.questions.count-1 {
            // Survey done
            self.setSurveyComplete()
        } else {
            //self.currentQuestion += 1
            for i in (self.currentQuestion+1)..<self.survey.questions.count {
                let question = survey.questions[i]
                if question.isVisible(for: survey) {
                    self.currentQuestion = i
                    break
                }
                
                if i == self.survey.questions.count-1 {
                    self.setSurveyComplete()
                }
            }
        }
    }
    
    func submitSurveyTapped() {
        //must send data to firebase
//        let url = URL(string: Constants.baseURL.api + "/survey")!
//        var request = URLRequest(url: url)
        Survey.saveResponseToServer(survey: survey) { success in
            if success {
                print("yes")
            }
            else{
                print("no")
            }
        }
        
//        request.httpMethod = "POST"
//        let bodyData = "Body=\(body)x&DishID=\(dish.key)&RestID=\(rest.key)&StarRating=\((starRating))&Username=\(username)&UserID=\(userID)"
//        print(bodyData)
//        request.httpBody = bodyData.data(using: .utf8)
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                    title = "Network Error"
//                    result = "There was a Network Error while processing your request"
//                    return
//            }
//            title = "Request Submitted!"
//            result = "Our team will respond shortly"
//        }.resume()
        self.surveyState = .code
        self.processing = true
        
        var meta : [String : String] = [:]
        
        #if DEBUG
        meta["debug"] = "true"
        #endif
        
        meta["app_version"] = Bundle.main.releaseVersionNumber
        meta["build"] = Bundle.main.buildVersionNumber
        
        survey.metadata = meta
        
        
        self.delegate?.surveyCompleted(with: self.survey)
        
        self.processing = false
        
    }
    
    func takeSurveyTapped() {
        self.surveyState = .taking
    }
    
    func noThanksTapped() {
        self.delegate?.surveyDeclined()
    }
    
    func remindMeLaterTapped() {
        self.delegate?.surveyRemindMeLater()
    }
    
    func restartSurveyTapped() {
        
        self.currentQuestion = 0
        self.surveyState = .taking
        
    }
    
    func setSurveyComplete() {
        
        self.surveyState = .complete
        
    }
    
}

struct SurveyView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SurveyView(survey: SampleSurvey).preferredColorScheme(.light)
        
    }
}


class SurveyViewHC: UIHostingController<SurveyView> {
    required init?(coder aDecoder: NSCoder = NSCoder.empty()) {
        super.init(coder: aDecoder, rootView: SurveyView(survey: SampleSurvey))
    }
}


extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension Survey {

    //MARK: - Save to Server
    
    //static func saveResponseToServer(survey:Survey) -> Bool {
    static func saveResponseToServer(survey:Survey, completion: ((_ success: Bool)->())? ) {

//        var ref: DatabaseReference!
        
        //get answers and add to postData
        let jsonData = Survey.getJsonDataForSurvey(survey: survey)
        var postData = "entry.378834618="
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as? [String: Any] else { completion?(false); return }
            
//            for q in survey.questions {
//                print("keys: \(q.)")
//            }
//            print("keys: \(type(of: survey.questions))")
//            if let unwrapped = dictionary["questions"] {
//                print("data entry: \(unwrapped)")
//            } else {
//                print("Missing json data")
//            }
            for q in dictionary["questions"] as! NSArray {
//                for w in ((q as! NSDictionary)["question"] as! NSArray) {
//                    print("data: \(((q as! NSDictionary)["question"] as! NSDictionary)["choices"])")
                
                if (((q as! NSDictionary)["question"]) as! NSDictionary)["choices"] != nil{
                    for ch in (((q as! NSDictionary)["question"]) as! NSDictionary)["choices"] as! NSArray{
                        if ((ch as! NSDictionary)["selected"] as! Bool) == true{
                            let text = (ch as! NSDictionary)["text"]
                            if(postData.substring(from: postData.index(before: postData.endIndex)) != "="){
                                postData += "&entry.1093810496" + "=" + (text as! String)
                                print("data1: \(postData)")
//                                postData = "&entry.377377366"
                            }
                            else{
                                postData += (text as! String)
                                print("data2: \(postData)")
                            }
//                            print("data: \(postData)")
                        }
                    }
                }else{
                    if ((((q as! NSDictionary)["question"]) as! NSDictionary)["tag"] as! String) == "contact-form" {
                        let name = ((((q as! NSDictionary)["question"]) as! NSDictionary)["name"] as! String)
                        let email = ((((q as! NSDictionary)["question"]) as! NSDictionary)["emailAddress"] as! String)
                        let feedback = ((((q as! NSDictionary)["question"]) as! NSDictionary)["feedback"] as! String)
                        postData += "&entry.377377366" + "=" + "Name: " +
                        name + " Email: " + email + "Feedback: " + feedback
//                        print("contact-form: \(((((q as! NSDictionary)["question"]) as! NSDictionary).allKeys))")
                    }
                }
                
//                if(postData.firstIndex(of: "&") != nil){
//                    postData += "&entry.377377366" + "=" + (text as! String)
//                    print("data3: \(postData)")
//                }
//                for ch in (((q as! NSDictionary)["question"] as! NSDictionary)["choices"]! {
//                    if ch["selected"] == true{
//                        print("data: yes")
//                    }
//                }
//                    for ch in (w as! NSDictionary)["choices"]!{
//                        if (ch as! NSDictionary)["selected"]! == true{
//
//                        }
//                    }
//                }
//                print("data:\((q as! NSDictionary)["question"])")
            }
            var url = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSc6MQ8LZd9MHDjHiQG3mRMtO9OS1TWsTkEmdLPktD-6NIAO9A/formResponse")
            var request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData.data(using: String.Encoding(rawValue: NSUTF8StringEncoding))
//                .dataUsingEncoding(NSUTF8StringEncoding)
            _ = NSURLConnection(request: request as URLRequest, delegate: nil, startImmediately: true)
        }
        catch {
            print(error.localizedDescription)
            completion?(false)

        }
        
//        NSURLConnection
//        if let unwrapped = dictionary {
//            print("data entry: \(unwrapped)")
//        } else {
//            print("Missing json data")
//        }
       
//        print("data entry: \(jsonData?.first)")
        
//        var url = NSURL(string: "https://docs.google.com/forms/d/e/1FAIpQLSc6MQ8LZd9MHDjHiQG3mRMtO9OS1TWsTkEmdLPktD-6NIAO9A/formResponse")
//        var postData = "entry.378834618_sentinel"
//        + "=" + text
//        postData += "entry.1093810496_sentinel" + "=" + text
//
//        var request = NSMutableURLRequest(url: url! as URL)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
//        var connection = NSURLConnection(request: request as URLRequest, delegate: nil, startImmediately: true)
        
//        let data = ["entry.123123123": jsonData[""], "entry.123124214": suggestedImprovements]

//        Alamofire.request(url, method: .post, parameters: data).validate()
//            .responseString {
//                response in
//                // do your magic
//            }
//
//        ref = Database.database().reference()
//
//        let UUID : UUID = UUID()
//        let uuid_string = "\(UUID)"
//
//        let dateFormatter = ISO8601DateFormatter()
//        let timeStampString = dateFormatter.string(from: Date())
//
//
//
//        let jsonData = Survey.getJsonDataForSurvey(survey: survey)
//
//        do {
//
//            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as? [String: Any]
//            else { completion?(false); return }
//
//
//            ref.child("surveys").child(uuid_string).setValue([ "response": dictionary, "createdAt": timeStampString]) { error, db in
//                if error != nil {
//                    completion?(false)
//                } else {
//                    completion?(true)
//                }
//            }
//
//        } catch {
//
//            print(error.localizedDescription)
//            completion?(false)
//
//        }


    }
    
    
    //MARK: - JSON
    
    static func getJsonStringFromData( jsonData: Data)->String? {
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            
            //print("JSON OUTPUT")
            //print(jsonString)
            
            return jsonString
        }
        
        return nil
    }
    
    
    static func getJsonDataForSurvey(survey: Survey)->Data? {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(survey)

            return jsonData
            
            

            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
    
    static func getSurveyFromString(jsonString: String) -> Survey? {
        
        do {
            
            let jsonData = jsonString.data(using: .utf8)!
            let survey = try JSONDecoder().decode(Survey.self, from: jsonData)
            return survey
            
        } catch {
            print(error)
        }
        
        return nil
        
    }
    
    
    
    
    
}
