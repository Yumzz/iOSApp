//
//  ListDishesView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 10/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import Foundation
import Combine



struct ListDishesView: View {
        
    var restaurant: RestaurantFB
    
    @ObservedObject var listDishVM: ListDishesViewModel
    
    @State var isLoading = false
    
    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
        
    @State var builds = [BuildFB]()
    
    @State var dishCats = [DishCategory]()
    @State var dishChosen = DishFB.previewDish()
    
    @State var restname = ""
     
    @State var addtapped = false
    @State var addWOSize = false
    
    @State var addo = false
    @State var showingAlert = false
    @State var isNavBarHidden = false
    
    @State private var waitButtonClicked = false
    
    @State var appclip = false
        
    @EnvironmentObject var order : OrderModel

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    let dispatchGroup = DispatchGroup()

    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        print("List Dish Vm created")
        
        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant, dispatch: dispatchGroup)
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(.black)]
        
    }
    
    
    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
                    view.overlay(overlay, alignment: .bottom)
                        .overlay(waitButt, alignment: .bottomLeading)
                        .navigationBarTitle("\(self.restname)")
                        .navigationBarBackButtonHidden(true)
//                        .navigationBarItems(leading: BackButton(mode: self.mode))
                        .navigationBarHidden(self.isNavBarHidden)
                        .onDisappear(){
                            print("disappear")
                            self.restname = ""
                            self.isNavBarHidden = true
                            self.addWOSize = false
                            self.addtapped = false
                            print("disappear, restname: \(self.restname), navbarhidden: \(self.isNavBarHidden)")
                        }
            } else {
                    view
                       .overlay(waitButt, alignment: .bottomLeading)
                        .navigationBarHidden(self.isNavBarHidden)
//                }
             }
        }
//        .navigationBarHidden(self.isNavBarHidden)
    }
    
    var waitButt: some View {
        VStack{
//            EmptyView()
//            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
//                Spacer().frame(height: 60)
//            }
            OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .onTapGesture {
                    self.waitButtonClicked = true
                }
            Spacer().frame(height: 20)
            
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
                Spacer().frame(height: 60)
            }
//            RecButton()
//                .onTapGesture {
//                    self.recButtonClicked = true
//                }
//
//            Spacer().frame(width: 0, height: (!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty) ? 70 : 10)
        }
    }
    
    var overlay: some View {
        VStack{
            NavigationLink(destination: ReviewOrder().navigationTitle("").navigationBarHidden(true)){
                ViewCartButton(dishCount: self.order.allDishes + self.order.allBuilds)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            Spacer().frame(width: 0, height: 10)
        }
    }

    
    var view: some View {
        
        ZStack {
            Color("DarkBack").edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                ScrollViewReader{ scrollView in
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            ForEach(self.dishCats, id: \.name){ dishCategory in
                                Text("\(dishCategory.name)")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 12))
                                    .scaledToFit()
                                    .background((self.dishCategoryClicked == dishCategory) ? 
                                                    ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) :
                                                     ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
                                    .foregroundColor((self.dishCategoryClicked == dishCategory) ?
                                                        Color(UIColor().colorFromHex("#FFFFFF", 1)) : ColorManager.textGray)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if((self.dishCategoryClicked == dishCategory)){
                                            self.dishCategoryClicked = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
                                        }
                                        else{
                                            self.dishCategoryClicked = dishCategory
                                            scrollView.scrollTo(self.dishCats.firstIndex(of: dishCategory), anchor: .top)
                                        }
                                    }
                                }

                            }

                    }
//
                    Spacer().frame(height: 20)
//
                    ForEach(self.dishCats, id: \.name){ dishCategory in
                        VStack(alignment: .leading, spacing: 20) {

                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
                                .foregroundColor(Color("Back"))
                
//
                            if(dishCategory.description != ""){
                                Text("\(dishCategory.description)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("GreyWhite"))
                                    .tracking(-0.41)
                            }
//
                            VStack(spacing: 20){
                                if dishCategory.dishes.isEmpty {
                                    ForEach(dishCategory.builds, id: \.id) {
                                        build in
                                        Text("\(build.name)")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .padding(.leading)
                                            .foregroundColor(Color("Back"))
                                        VStack{
                                            Text("\(build.description)")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1)))
                                                .tracking(-0.41)
                                                .padding(.horizontal)
                                        }
                                        .frame(height: 50)
//                                        .frame()
                                        
//                                            .lineLimit(nil)
//                                            .multilineTextAlignment(.leading)
//
//                                            .scaledToFit()
                                            
//                                            .scaledToFill()
//                                            .padding(.horizontal)
                                            
                                        BuildCard(build: build, rest: self.restaurant)
                                    }
                                    Spacer().frame(height: 20)
                                }
                                ForEach(dishCategory.dishes, id: \.id) {
                                    dish in
                                        NavigationLink(destination:
                                            DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                        ) {
                                            DishCard(dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), singPrice:dish.options.isEmpty, rest: self.restaurant, dish: dish)
                                        }
                                }
                                Spacer().frame(height: 20)
                            }
                                }.id(self.dishCats.firstIndex(of: dishCategory))
                            }
//                    Spacer()
                        }
                    }
                }.navigationBarTitleDisplayMode(self.addtapped ? .inline : .automatic)
                .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: self.$waitButtonClicked){
            WaiterConnection(rest: self.order.restChosen)
                .onDisappear(){
                    self.addtapped = true
                }
        }
        .onAppear{
//            print("aaaaa: \(userProfile.userId)")
            self.dispatchGroup.notify(queue: .main){
//                print("post list dish view model")
                self.dishCats = self.listDishVM.dishCategories
                self.builds = self.listDishVM.builds
                //must make build for each under build category
                self.restname = self.restaurant.name
                self.isNavBarHidden = false
//                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
//                    print("added1")
//                    self.addWOSize = Notification.object! as! Bool
//                    self.addtapped = true
//                }
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Special Instruction"), object: nil, queue: .main) { (Notification) in
                    var tup = Notification.object! as! (DishFB, Bool)
                    self.dishChosen = tup.0
                    print("added2")
//                    self.dishChosen.description = self.dishChosen.description.sidesFixed(str: self.dishChosen.description, dishcat: self.dishCats)
                    self.addo = true
                    self.addtapped = true
                    self.addWOSize = tup.1
                }
                self.addWOSize = false
                self.addtapped = false
            }
        }
        .navigationBarTitle("\(self.restname)")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavBarHidden)
        .navigationBarItems(leading: BackButton(mode: self.mode))
//        .onDisappear(){
//            self.restname = ""
//            self.isNavBarHidden = true
//        }
        .alert(isPresented: $addo, TextFieldAlert(title: "Any Special Instructions?", message: "\(self.dishChosen.name) - \(self.dishChosen.description)") { (text) in
                    if text != nil {
                        print(text)
                        if((self.order.dishChoice[self.dishChosen]?.isEmpty) != nil){
                            self.order.dishChoice[self.dishChosen] = ""
                        }
                        var newText = text?.replacingOccurrences(of: ";", with: ",")
                        self.order.dishChoice[self.dishChosen] = newText!
                        print(self.order.dishChoice[self.dishChosen])
//                        self.saveGroup(text: text!)
                        self.addtapped = true
                    }
                    print("alert here now")
                    self.addtapped = true
                })
        
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
    }
}



struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView(restaurant:  RestaurantFB.previewRest())
        }
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


//                view.overlay(overlay, alignment: .bottom)
//                    .navigationBarTitle("\(self.restname)")
//                    .navigationBarBackButtonHidden(true)
//                    .navigationBarItems(leading: BackButton(mode: self.mode))
//                    .navigationBarHidden(self.isNavBarHidden)
//                    .onDisappear(){
//                        print("disappear")
//                        self.restname = ""
//                        self.isNavBarHidden = true
//                        self.addWOSize = false
//                        self.addtapped = false
//                        print("disappear, restname: \(self.restname), navbarhidden: \(self.isNavBarHidden)")
//                    }
