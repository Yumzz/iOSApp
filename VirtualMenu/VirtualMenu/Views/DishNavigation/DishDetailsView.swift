//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by Sally Gao on 10/12/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import SwiftUI
import Combine

//struct ReviewUser: Identifiable {
//    let id = UUID()
//    let review: Review
//    let user: UserProfile
//}
struct DishDetailsView: View {
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @State var count: Int = 1
    
    @EnvironmentObject var order : OrderModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var addtapped = false
    @State var addIt = false
    @State var isNavigationBarHidden: Bool = true
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero

    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).ignoresSafeArea(.all)
            ScrollView(.vertical){
                ZStack {
                    VStack{
                        if(dish.photoExists){
                            #if !APPCLIP
                            FBURLImage(url:  dish.coverPhotoURL, imageWidth: 375, imageHeight: 240, circle: false)
                            Spacer()
                            #else
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)).frame(width: 375, height: 240).foregroundColor(.black)
                            Spacer()
                            #endif
                        }
                        else{
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)).frame(width: 375, height: 240).foregroundColor(.black)
                            Spacer()
                        }
                    }
                    VStack(spacing: 0){
                        VStack{
                            HStack{
                                Text(dish.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41)
                                    .foregroundColor(.black)
                                Spacer()
                                
                            }
                            HStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
                                    .overlay(Text("4.5").foregroundColor(.black))
                                    
                                .frame(width: 45, height: 20)
                                Text("(298 reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41).foregroundColor(.black)
                                Spacer()
                            }
                            HStack{
                                Text("\(dish.description)").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)

                                Spacer()
                            }
                           
                        }.padding()
                        Spacer()
                        //options
                        if(!dish.options.isEmpty){
                            VStack(spacing: 0){
                                HStack{
                                    Text("Options")
                                        .font(.system(size: 24))
                                }
                                VStack{
                                    OptionsCard(options: dish.options, exclusive: dish.exclusive, dish: dish)
                                }
                            }
                        }
                        if(dish.choices != ["":["":[""]]]){
                        }
                        HStack{
                            HStack{
                                Image(systemName: "minus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .onTapGesture {
                                        print("tapped")
                                        if(self.count > 1){
                                            self.count -= 1
                                        }
                                    }
                                Text("\(self.count)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .font(.footnote)
                                    .foregroundColor(Color.black)
                                    .frame(width: 30)
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .onTapGesture {
                                        self.count = self.count + 1
                                    }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: 122, height: 48)
//                            NavigationLink(destination: ReviewOrder()){

                                HStack{
                                    Text("$\(dish.price.removeZerosFromEnd())")
                                        .font(.system(size: 16, weight: .semibold))
                                        .font(.footnote)
                                        .frame(width: 100)
//                                    Image(systemName: "cart.fill.badge.plus")
//                                        .font(.system(size: 18))
                                    Text("Add to Cart")
                                        .font(.system(size: 16, weight: .semibold))
                                        .font(.footnote)
                                        .frame(width: 100)
                                }
                                .padding()
                                .foregroundColor(Color.white)
                                .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                .cornerRadius(10)
                                .scaledToFit()
//                                .frame(width: UIScreen.main.bounds.width/2, height: 48)
                                .onTapGesture {
                                    print("here")
                                    var i = 0
                                    while i < self.count{
                                        let d = DispatchGroup()
                                        d.enter()
                                        self.order.addDish(dish: self.dish, rest: self.restaurant, dis: d)
                                        i += 1
                                    }
                                    //ask about side order/choices here
                                    if !dish.choices.isEmpty{
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruct"), object: dish.choices)
                                    }
                                    self.addtapped = true
                                }
                            
                        }
//                        Spacer()
                    }
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))))
                    .offset(y:200)
                }
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarItems(leading: WhiteBackButton(mode: self.presentationMode))
            .onAppear(){
                self.isNavigationBarHidden = false
                print("yessiririririr")
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Special Instruct"), object: nil, queue: .main) { (Notification) in
                    print("added")
                    self.addIt = true
                }
            }
            .onDisappear(){
                self.isNavigationBarHidden = true
            }
//        .alert(isPresented: self.$addtapped){
//            print("added")
////            self.addtapped = false
//
//            return Alert(title: Text("Dish Added"))
//        }
        .alert(isPresented: $addIt, TextFieldAlert(title: "Any Special Instructions?", message: dish.description) { (text) in
                    if text != nil {
                        print(text)
                        self.order.dishChoice[dish] = text
//                        self.saveGroup(text: text!)
                    }
                })
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}

class TextFieldAlertViewController: UIViewController {
    
    /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
    /// - Parameters:
    ///   - title: to be used as title of the UIAlertController
    ///   - message: to be used as optional message of the UIAlertController
    ///   - text: binding for the text typed into the UITextField
    ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
    init(isPresented: Binding<Bool>, alert: TextFieldAlert) {
        self._isPresented = isPresented
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @Binding
    private var isPresented: Bool
    private var alert: TextFieldAlert
    
    // MARK: - Private Properties
    private var subscription: AnyCancellable?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }
    
    private func presentAlertController() {
        guard subscription == nil else { return } // present only once
        
        let vc = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        // add a textField and create a subscription to update the `text` binding
        vc.addTextField {
            // TODO: 需要补充这些参数
            // $0.placeholder = alert.placeholder
            // $0.keyboardType = alert.keyboardType
            // $0.text = alert.defaultValue ?? ""
            $0.text = self.alert.defaultText
        }
        if let cancel = alert.cancel {
            vc.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
                //                self.action(nil)
                self.isPresented = false
            })
        }
        let textField = vc.textFields?.first
        vc.addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            self.isPresented = false
            self.alert.action(textField?.text)
        })
        present(vc, animated: true, completion: nil)
    }
}

struct TextFieldAlert {
    
    let title: String
    let message: String?
    var defaultText: String = ""
    public var accept: String = "Accept" // The left-most button label
    public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
    public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
    
}

struct AlertWrapper:  UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    let alert: TextFieldAlert
    
    typealias UIViewControllerType = TextFieldAlertViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIViewControllerType {
        TextFieldAlertViewController(isPresented: $isPresented, alert: alert)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        // no update needed
    }
}

struct TextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: TextFieldAlert
    
    
    var body: some View {
        ZStack {
            if (isPresented) {
                AlertWrapper(isPresented: $isPresented, alert: content)
            }
            presentingView
        }
    }
}

extension View {
    
    func alert(isPresented: Binding<Bool>, _ content: TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
    
}
