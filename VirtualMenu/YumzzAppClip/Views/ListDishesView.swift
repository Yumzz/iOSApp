//
//  ListDishesView.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//
import SwiftUI
import Combine

enum ActiveSheet: Identifiable {
    case first, second

    var id: Int {
        hashValue
    }
}

struct ListDishesView: View {

    var restaurant: RestaurantFB

    @ObservedObject var listDishVM: ListDishesViewModel

    @State var isLoading = false

    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "", description: "")

    @State var builds = [BuildFB]()

    @State var dishCats = [DishCategory]()
    @State var dishChosen: DishFB = DishFB.previewDish()

    @State var restname = ""

    @State var addo = false
    @State var addtapped = false
    @State var addWOSize = false
    @State var showingAlert = false
    @State var isNavBarHidden = false

    @State private var showSheet2 = false
    @State private var activeSheet: ActiveSheet?

    @EnvironmentObject var order : OrderModel

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero

    let dispatchGroup = DispatchGroup()


    init(restaurant: RestaurantFB) {

        self.restaurant = restaurant

        print("List Dish Vm created")

        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant, dispatch: dispatchGroup)

    }

    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
                view.overlay(overlay, alignment: .bottom)
            }else {
                view
            }
        }.navigationBarHidden(self.isNavBarHidden)

    }

    var overlay: some View {
        VStack{
                ViewCartButton(dishCount: self.order.allDishes)
                    .onTapGesture{
                        self.activeSheet = .second
                        self.showSheet2 = true
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            Spacer().frame(width: 0, height: 10)
        }
    }



    var view: some View {
//        EmptyView()
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical) {
                ScrollViewReader{ scrollView in
//                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            ForEach(self.dishCats, id: \.name){ dishCategory in
                                Text("\(dishCategory.name)")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 12))
                                    .scaledToFit()
                                    .background((self.dishCategoryClicked == dishCategory) ?
                                                    ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) : ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
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
////
                    Spacer().frame(height: 20)
////
                    ForEach(self.dishCats, id: \.name){ dishCategory in
                        VStack(alignment: .leading, spacing: 20) {
//
                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
////
                            if(dishCategory.description != ""){
                                Text("\(dishCategory.description)")
                                    .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                            }
//////
                            VStack(spacing: 20){
                                if dishCategory.dishes.isEmpty {
                                    ForEach(dishCategory.builds, id: \.id) {
                                        build in
                                        Text("\(build.name)")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .padding(.leading)
                                        Text("\(build.description)")
                                            .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                                        BuildCard(build: build, rest: self.restaurant)
                                    }
                                    Spacer().frame(height: 20)
                                }
                                ForEach(dishCategory.dishes, id: \.id) {
                                    dish in
                                    DishCard(dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), singPrice: dish.options.isEmpty, rest: self.restaurant, dish: dish)
                                        .onTapGesture{
                                            self.dishChosen = dish
                                            self.activeSheet = .first
                                            self.showSheet2 = true
                                        }
                                }
                                Spacer().frame(height: 20)
                            }
                        }.id(self.dishCats.firstIndex(of: dishCategory))
                    }
                    Spacer()
//                }
                }
            }.navigationBarTitleDisplayMode(self.addtapped ? .inline : .automatic)
                .frame(maxWidth: .infinity)
            }
        .sheet(isPresented: $showSheet2){
            if(self.activeSheet == .first){
                DishDetailsView(dish: self.dishChosen, restaurant: self.restaurant)
            }
            else{
                ReviewOrder()
            }
        }
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                self.dishCats = self.listDishVM.dishCategories
                if self.restaurant.builds != nil {
                    self.builds = self.restaurant.builds!
                }
                //must make build for each under build category
                self.restname = self.restaurant.name
                print("ask: \(self.restname)")
                self.isNavBarHidden = false
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
                    print("added")
                    self.addWOSize = Notification.object! as! Bool
                    self.addtapped = true
                }
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Special Instruction"), object: nil, queue: .main) { (Notification) in
                    self.dishChosen = Notification.object! as! DishFB
                    print("added")
                    self.addo = true
                }
                self.addWOSize = false
                self.addtapped = false
            }
        }
//        .navigationBarTitle("\(self.restname)")
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(self.isNavBarHidden)
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
                        self.order.dishChoice[self.dishChosen] = text!
                        print(self.order.dishChoice[self.dishChosen])
//                        self.saveGroup(text: text!)
                    }
                })
//        .gesture(
//            DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//            if(value.translation.width > 100) {
//                self.mode.wrappedValue.dismiss()
//            }
//        }))
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




//beg
//
//  ListDishesView.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//
//import SwiftUI
//import Combine
//
//enum ActiveSheet: Identifiable {
//    case first, second
//
//    var id: Int {
//        hashValue
//    }
//}
//
//struct ListDishesView: View {
//
//    var restaurant: RestaurantFB
//
//    @ObservedObject var listDishVM: ListDishesViewModel
//
//    @State var isLoading = false
//
//    @State var dishCategoryClicked: DishCategory = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
//
//    @State var builds = [BuildFB]()
//
//    @State var dishCats = [DishCategory]()
//    @State var dishChosen: DishFB = DishFB.previewDish()
//
//    @State var restname = ""
//
//    @State var addo = false
//    @State var addtapped = false
//    @State var addWOSize = false
//    @State var showingAlert = false
//    @State var isNavBarHidden = false
//
//    @State private var showSheet2 = false
//    @State private var activeSheet: ActiveSheet?
//
//    @EnvironmentObject var order : OrderModel
//
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//    @GestureState private var dragOffset = CGSize.zero
//
//    let dispatchGroup = DispatchGroup()
//
//
//    init(restaurant: RestaurantFB) {
//
//        self.restaurant = restaurant
//
//        print("List Dish Vm created")
//
//        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant, dispatch: dispatchGroup)
//
//    }
//
//    var body: some View {
//        Group {
//            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
//                view.overlay(overlay, alignment: .bottom)
//            }else {
//                view
//            }
//        }.navigationBarHidden(self.isNavBarHidden)
//
//    }
//
//    var overlay: some View {
//        VStack{
//                ViewCartButton(dishCount: self.order.allDishes)
//                    .onTapGesture{
//                        self.activeSheet = .second
//                        self.showSheet2 = true
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
//            Spacer().frame(width: 0, height: 10)
//        }
//    }
//
//
//
//    var view: some View {
////        EmptyView()
//        ZStack {
//            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
//            ScrollView(.vertical) {
//                ScrollViewReader{ scrollView in
////                VStack {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10){
//                            ForEach(self.dishCats, id: \.name){ dishCategory in
//                                Text("\(dishCategory.name)")
//                                    .padding(.horizontal, 20)
//                                    .padding(.vertical, 10)
//                                    .font(.system(size: 12))
//                                    .scaledToFit()
//                                    .background((self.dishCategoryClicked == dishCategory) ?
//                                                    ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) : ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
//                                    .foregroundColor((self.dishCategoryClicked == dishCategory) ?
//                                                        Color(UIColor().colorFromHex("#FFFFFF", 1)) : ColorManager.textGray)
//                                    .cornerRadius(5)
//                                    .onTapGesture {
//                                        if((self.dishCategoryClicked == dishCategory)){
//                                            self.dishCategoryClicked = DishCategory(isExpanded: false, dishes: [], name: "", description: "")
//                                        }
//                                        else{
//                                            self.dishCategoryClicked = dishCategory
//                                            scrollView.scrollTo(self.dishCats.firstIndex(of: dishCategory), anchor: .top)
//                                        }
//                                    }
//                                }
//
//                            }
//
//                    }
//////
//                    Spacer().frame(height: 20)
//////
//                    ForEach(self.dishCats, id: \.name){ dishCategory in
//                        VStack(alignment: .leading, spacing: 20) {
////
//                            Text("\(dishCategory.name)")
//                                .font(.title)
//                                .fontWeight(.semibold)
//                                .padding(.leading)
//////
//                            if(dishCategory.description != ""){
//                                Text("\(dishCategory.description)")
//                                    .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
//                            }
////////
//                            VStack(spacing: 20){
//                                if dishCategory.dishes.isEmpty {
//                                    ForEach(dishCategory.builds, id: \.id) {
//                                        build in
//                                        Text("\(build.name)")
//                                            .font(.title)
//                                            .fontWeight(.semibold)
//                                            .padding(.leading)
//                                        Text("\(build.description)")
//                                            .font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
//                                        BuildCard(build: build, rest: self.restaurant)
//                                    }
//                                    Spacer().frame(height: 20)
//                                }
//                                ForEach(dishCategory.dishes, id: \.id) {
//                                    dish in
//                                    DishCard(dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price), singPrice: dish.options.isEmpty, rest: self.restaurant, dish: dish)
//                                        .onTapGesture{
//                                            self.dishChosen = dish
//                                            self.activeSheet = .first
//                                            self.showSheet2 = true
//                                        }
//                                }
//                                Spacer().frame(height: 20)
//                            }
//                        }.id(self.dishCats.firstIndex(of: dishCategory))
//                    }
//                    Spacer()
////                }
//                }
//            }.navigationBarTitleDisplayMode(self.addtapped ? .inline : .automatic)
//                .frame(maxWidth: .infinity)
//            }
//        .sheet(isPresented: $showSheet2){
//            if(self.activeSheet == .first){
//                DishDetailsView(dish: self.dishChosen, restaurant: self.restaurant)
//            }
//            else{
//                ReviewOrder()
//            }
//        }
//        .onAppear{
//
//            self.dispatchGroup.notify(queue: .main){
//                self.dishCats = self.listDishVM.dishCategories
//                if self.restaurant.builds != nil {
//                    self.builds = self.restaurant.builds!
//                }
//                //must make build for each under build category
//                self.restname = self.restaurant.name
//                print("ask: \(self.restname)")
//                self.isNavBarHidden = false
////                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Alert"), object: nil, queue: .main) { (Notification) in
////                    print("added")
////                    self.addWOSize = Notification.object! as! Bool
////                    self.addtapped = true
////                }
//                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Special Instruction"), object: nil, queue: .main) { (Notification) in
//                    var tup = Notification.object! as! (DishFB, Bool)
//                    self.dishChosen = tup.0
//                    print("added2")
////                    self.dishChosen.description = self.dishChosen.description.sidesFixed(str: self.dishChosen.description, dishcat: self.dishCats)
//                    self.addo = true
//                    self.addtapped = true
//                    self.addWOSize = tup.1
//                }
//                self.addWOSize = false
//                self.addtapped = false
//            }
//        }
//        .navigationBarTitle("\(self.restname)")
//        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(self.isNavBarHidden)
//        .onDisappear(){
//            self.restname = ""
//            self.isNavBarHidden = true
//        }
////        .alert(isPresented: self.$addtapped){
////            print("added")
////            if(self.addWOSize){
////                return Alert(title: Text("Dish Added"))
////            }
////            else{
////                return Alert(title: Text("Please choose Size"))
////            }
////        }
//        .alert(isPresented: $addo, TextFieldAlert(title: "Any Special Instructions?", message: "\(self.dishChosen.name) - \(self.dishChosen.description)") { (text) in
//                    if text != nil {
//                        print(text)
//                        if((self.order.dishChoice[self.dishChosen]?.isEmpty) != nil){
//                            self.order.dishChoice[self.dishChosen] = ""
//                        }
//                        self.order.dishChoice[self.dishChosen] = text!
//                        print(self.order.dishChoice[self.dishChosen])
////                        self.saveGroup(text: text!)
//                    }
//                })
//        .gesture(
//            DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//            if(value.translation.width > 100) {
//                self.mode.wrappedValue.dismiss()
//            }
//        }))
//    }
//}
//
//
//struct ListDishesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            ListDishesView(restaurant:  RestaurantFB.previewRest())
//        }
//
//    }
//}
//
//
//class TextFieldAlertViewController: UIViewController {
//
//    /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
//    /// - Parameters:
//    ///   - title: to be used as title of the UIAlertController
//    ///   - message: to be used as optional message of the UIAlertController
//    ///   - text: binding for the text typed into the UITextField
//    ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
//    init(isPresented: Binding<Bool>, alert: TextFieldAlert) {
//        self._isPresented = isPresented
//        self.alert = alert
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    @Binding
//    private var isPresented: Bool
//    private var alert: TextFieldAlert
//
//    // MARK: - Private Properties
//    private var subscription: AnyCancellable?
//
//    // MARK: - Lifecycle
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        presentAlertController()
//    }
//
//    private func presentAlertController() {
//        guard subscription == nil else { return } // present only once
//
//        let vc = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
//        // add a textField and create a subscription to update the `text` binding
//        vc.addTextField {
//            // TODO: 需要补充这些参数
//            // $0.placeholder = alert.placeholder
//            // $0.keyboardType = alert.keyboardType
//            // $0.text = alert.defaultValue ?? ""
//            $0.text = self.alert.defaultText
//        }
//        if let cancel = alert.cancel {
//            vc.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
//                //                self.action(nil)
//                self.isPresented = false
//            })
//        }
//        let textField = vc.textFields?.first
//        vc.addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
//            self.isPresented = false
//            self.alert.action(textField?.text)
//        })
//        present(vc, animated: true, completion: nil)
//    }
//}
//
//struct TextFieldAlert {
//
//    let title: String
//    let message: String?
//    var defaultText: String = ""
//    public var accept: String = "Accept" // The left-most button label
//    public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
//    public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
//
//}
//
//struct AlertWrapper:  UIViewControllerRepresentable {
//
//    @Binding var isPresented: Bool
//    let alert: TextFieldAlert
//
//    typealias UIViewControllerType = TextFieldAlertViewController
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIViewControllerType {
//        TextFieldAlertViewController(isPresented: $isPresented, alert: alert)
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<AlertWrapper>) {
//        // no update needed
//    }
//}
//
//struct TextFieldWrapper<PresentingView: View>: View {
//
//    @Binding var isPresented: Bool
//    let presentingView: PresentingView
//    let content: TextFieldAlert
//
//
//    var body: some View {
//        ZStack {
//            if (isPresented) {
//                AlertWrapper(isPresented: $isPresented, alert: content)
//            }
//            presentingView
//        }
//    }
//}
//
//extension View {
//
//    func alert(isPresented: Binding<Bool>, _ content: TextFieldAlert) -> some View {
//        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
//    }
//
//}

