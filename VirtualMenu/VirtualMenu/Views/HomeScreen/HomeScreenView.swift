//
//  HomeScreenView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second

    var id: Int {
        hashValue
    }
}

struct HomeScreenView: View {
    @ObservedObject var HomeScreenVM : HomeScreenViewModel
    
    @State private var showAccount = false
    @State private var qrCodeShow = false
 
    
    @State var restaurants = [RestaurantFB]()
    @State var cityRests = [String: [RestaurantFB]]()
    
    @State var cities = [String]()
//    @State private var orderRecButtonClicked = false
//    @State private var waitButtonClicked = false
    
    @State var rest = RestaurantFB.previewRest()
    @State private var restChosen = false
//    @State private var callWaiter = false
    @State private var IoT = false
    @State var wrongQRCode = false
    
    @State var navbarhidden = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var user: UserStore
    @GestureState private var dragOffset = CGSize.zero
        
    let dispatchGroup = DispatchGroup()
    
    @EnvironmentObject var order : OrderModel
    
    var locationManager = LocationManager()

    init() {
        self.HomeScreenVM = HomeScreenViewModel(dispatch: dispatchGroup)
        
    }
    
    
    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
//                if(self.waitButtonClicked){
//                    view.overlay(WaiterConnection(rest: self.order.restChosen), alignment: .bottom)
//                }
//                else{
                    view.overlay(overlay, alignment: .bottom)
//                    .overlay(OrderRecButton, alignment: .bottomLeading)

//                        .overlay(waitButt, alignment: (self.order.dishesChosen || !self.order.buildsChosen.isEmpty) ? .topTrailing : .bottomLeading)
//                        .overlay(waitButt, alignment: .topTrailing)
//                }
                
            } else {
//                if(self.waitButtonClicked){
                    view
//                    .overlay(OrderRecButton, alignment: .bottomLeading)
//                }
//                else{
//                    view
//                       .overlay(waitButt, alignment: .bottomLeading)
//                }
             }
//            if self.waitButtonClicked {
//                view.sheet(isPresented: self.$waitButtonClicked){
//                    WaiterConnection(rest: self.order.restChosen)
//                }
                
//                ZStack {
//                    Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))
//                    VStack {
//                        WaiterConnection()
////                        RecView(isOpen: self.$recButtonClicked)
//                    }.padding()
//                }
//                .frame(width: 329, height: 374)
//                .cornerRadius(20).shadow(radius: 20)
//                .transition(.slide)
//                .animation(.default)
//            }
        }                    .navigationBarTitleDisplayMode(.inline)

    }
    
    var overlay: some View {
        VStack{
            NavigationLink(destination: ReviewOrder()){
                ViewCartButton(dishCount: self.order.allDishes + self.order.allBuilds)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            Spacer().frame(width: 0, height: 10)
        }
    }
    
//    var OrderRecButton: some View {
//        VStack{
//
//            OrangeButton(strLabel: "Get Local Recommendation", width: 325, height: 48)
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
//
//            }
//        .onTapGesture(){
//            self.qrCodeShow = true
//            self.orderRecButtonClicked = true
//
//        }
//    }
    
//    var waitButt: some View {
//        VStack{
//            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
//                Spacer().frame(height: 100)
//            }
////            EmptyView()
//            OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48, dark: colorScheme == .dark)
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
//                .onTapGesture {
//                    self.callWaiter = true
//                    self.IoT = true
//                    self.waitButtonClicked = true
//                }
//            Spacer().frame(height: 20)
////            RecButton()
////                .onTapGesture {
////                    self.recButtonClicked = true
////                }
////
//            if(self.order.dishesChosen != [] || !self.order.buildsChosen.isEmpty){
//                Spacer().frame(height: 20)
//            }
////            Spacer().frame(width: 0, height: (!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty) ? 70 : 10)
//        }
//    }
    
    var view: some View{
    GeometryReader { geometry in
        if(self.restChosen){
            RestaurantHomeView(restaurant: self.rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: self.rest.coordinate))
//                .navigationBarTitle("")
//                .navigationBarBackButtonHidden(true)
//                .navigationBarHidden(false)
//                .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
//                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//                    if(value.translation.width > 100) {
//                        self.mode.wrappedValue.dismiss()
//                    }
//                }))
        }
        else{
            ZStack {
                Color("DarkBack").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: user.guest ? 10 : UIScreen.main.bounds.height/8)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Near you").font(.system(size: 24, weight: .semibold)).foregroundColor(Color("Back"))
                            Spacer()
                        }.padding()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30) {
                                ForEach(self.restaurants, id:\.id) { restaurant in

                                    NavigationLink(
                                        destination: RestaurantHomeView(restaurant: restaurant, distance: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate))
                                    ) {
                                        HSRestaurantCard(restaurant: restaurant, location: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate))
                                    }
                                }
                            }
                        }.frame(height: 150).padding()
                        
                        
                        ForEach(self.cities, id:\.self) { city in
                            
                            HStack{
                                Text("Popular in \(city)").font(.system(size: 24, weight: .semibold)).foregroundColor(Color("Back"))
                                Spacer()
                            }.padding()
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 30) {
                                    
                                    ForEach(self.cityRests[city]!, id:\.self) { rest in

                                        NavigationLink(
                                            destination: RestaurantHomeView(restaurant: rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate))
                                        ) {
                                            HSRestaurantCard(restaurant: rest, location: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate))
                                        }


                                    }

                                }
                            }.frame(height: 135).padding()
                        }
                        Spacer()
                        
                    }
                }
                }.padding(.top, geometry.safeAreaInsets.top)
    //                .background(Color(red: 0.953, green: 0.945, blue: 0.933))\
                    .navigationBarItems(leading: HStack {
                        Text("Yumzz").font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color("OrangeWhite"))
                        Spacer().frame(width: UIScreen.main.bounds.width/5)
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 24, weight: .bold)).padding()
                            .foregroundColor(Color("YumzzOrange"))
                            .onTapGesture{
                                print("touched qr")
//                                self.navbarhidden = true
                                self.qrCodeShow = true
                            }
                        
                        if (userProfile.profilePhotoURL == ""){
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    self.showAccount = true
                                }
                                .sheet(isPresented: self.$showAccount) {
                                    AccountProfileView()
                                    //dismiss once confirmation alert is sent
                                }
                        }
                        else{
                            FBURLImage(url: "profilephotos/\(userProfile.userId)", imageWidth: 36, imageHeight: 36, circle: true)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    self.showAccount = true
                                }
                                .onAppear(){
                                    print("zxcvbnm\(userProfile.profilePhoto.debugDescription)")
                                }
                                .sheet(isPresented: self.$showAccount) {
                                    AccountProfileView()
                                    //dismiss once confirmation alert is sent
                                }
    //                        Image(uiImage: userProfile.profilePhoto!.circle!)
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fill)
    //                            .frame(width: 36, height: 36)
                                
                        }
                        
                    }.navigationBarTitleDisplayMode(.inline)
                    .foregroundColor(Color("YumzzOrange"))
//                        .frame(alignment: .top)
//                        .padding()
                        .onTapGesture(){
                            print("tapped hstack")
                        })
                    .onAppear(){
                        self.navbarhidden = false
                    }
//                    .onDisappear(){
//                        self.navbarhidden = true
//                    }
                    .navigationBarHidden(self.navbarhidden)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .popover(isPresented: self.$qrCodeShow){
//                    Home
//                    QRScanView(completion: { textPerPage in
//                        if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                            print("wow: \(text)")
//                        }
//                    })
//                    if(self.orderRecButtonClicked){
//                        OrderRecChoose()
//                            .onDisappear(){
//                                self.orderRecButtonClicked = false
//                            }
//                    }
//                    else{
                        MenuConnection()
                        .onDisappear(){
    //                        if(self.rest.description != ""){
    //                            self.order.newOrder(rest: self.rest)
    //                        }
                            self.qrCodeShow = false
                        }
                        .onAppear(){
                            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PrintInfoWrong"), object: nil, queue: .main) { [self] (Notification) in
                                print("qrcode printinfo here")
                                self.wrongQRCode = true
                            }
    //                        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CallWaitWrong"), object: nil, queue: .main) { [self] (Notification) in
    //                            print("qrcode callwait here")
    //                            self.wrongQRCode = true
    //                        }
                        }.alert(isPresented: self.$wrongQRCode){
                            return Alert(title: Text("Wrong QR Code! Please drag down this view, reclick the qr scanner, and scan the QR Code with the blue border!"))
                            self.wrongQRCode = false
    //                        print("just displayed alert and about to ask to reload")
    //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMenuScan"), object: nil)
    //                        self.view.
                        }
//                    }
                    
//                    .alert(isPresented: $wrongQRCode, TextFieldAlert(title: "Wrong QR Code", message: "Please scan the QR Code with the blue border to see the menu") { (text) in
//                                self.wrongQRCode = false
//                        //need to refresh
//                        self.qrCodeShow = false
//                        self.qrCodeShow = true
//                            })
                }
                .onAppear(){
                    self.dispatchGroup.notify(queue: .main){
//                        var code = ""
                        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ChooseRest"), object: nil, queue: .main) { [self] (Notification) in
//                            print("this is the code \(code)")
                            print("asked and gotten")
                            var text = Notification.object as! String
                            let d = DispatchGroup()
                            d.enter()
                            
                            var rest = self.getQueryStringParameter(url: text, param: "restaurant", d: d)
                //                    rest.replace
//                            rest = rest?.replacingOccurrences(of: "-", with: " ")
//                            print("ask: \(rest)")
//                            if((rest?.contains("Vics")) != nil){
//                                rest = rest?.replacingOccurrences(of: "Vics", with: "Vic's")
//
//                            }
                            self.order.newOrder(rest: self.restaurants.first(where: { $0.id.replacingOccurrences(of: " ", with: "") == rest })!)
                            print("ask: \(rest)")
                            
                            d.notify(queue: .main){
                //                self.rest = self.restaurants.first(where: { $0.name == rest })!
                                
                                self.restChosen = true
                                
                                self.rest = self.restaurants.first(where: { $0.id.replacingOccurrences(of: " ", with: "") == rest })!
//                                print("ask: \(self.rest.description)")
                                self.qrCodeShow = false
//                                print("ask1: \(self.qrCodeShow)")
                                
                //                        self.
                //                        RestaurantHomeView(restaurant: self.rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: self.rest.coordinate))
                                
                            }
                            
                            
                        }
                        
                        
                        self.restaurants = self.HomeScreenVM.allRestaurants
                        for x in self.restaurants {
        //                    let restSet = Set(arrayLiteral: cityRests[x.cityAddress].map({ $0.self }))
        //                    let r = Array(restSet)
                            print("rest: \(x)")
                            if(self.cityRests[x.cityAddress] == nil){
                                self.cityRests[x.cityAddress] = []
                            }
                            if(!self.cityRests[x.cityAddress]!.contains(x)){
                                self.cityRests[x.cityAddress]!.append(x)
                            }
                            if(!cities.contains(x.cityAddress)){
                                self.cities.append(x.cityAddress)
                            }
                        }
                    }
                }
            }
//            .hiddenNavigationBarStyle()
        }
//
        
    }
//    .hiddenNavigationBarStyle()
}
    
    func getQueryStringParameter(url: String, param: String, d: DispatchGroup) -> String? {
      print("url: \(url)")
        var x = ""
//        guard let url = URLComponents(string: url) else { x = ""; return}
        print("url pre: \(url)")

        guard let url = URL(string: url) else { return ""}
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
//
        d.leave()
        return components.queryItems?.first(where: { $0.name == param })?.value!
        
    }
}

struct HSRestaurantCard: View {
    var restaurant: RestaurantFB
//    var HomeScreenVM : HomeScreenViewModel
    var location: Double
    
    var body: some View {
            VStack {
                HStack {
                    FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 175, imageHeight: 88, circle: false)
                        .frame(width: 175, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                HStack{
                    Text(restaurant.name).font(.system(size: 18, weight: .bold)).tracking(-0.41).foregroundColor(Color("Back"))
                    Spacer()
                }
                HStack{
                    Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.location.removeZerosFromEnd()) miles").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("GreyWhite")).tracking(-0.41)
                    Spacer()
                }
            }.frame(width: 175, height: 150)
            .padding(.leading, 10)

        }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}






//                This for order review iteration
//                .alert(isPresented: $orderRevNeed, TextFieldAlert(title: "How was Your Last Order?", message: "How") { (text) in
//                            if text != nil {
//                                print(text)
//                                if((self.order.dishChoice[self.dish]?.isEmpty) != nil){
//                                    self.order.dishChoice[self.dish] = ""
//                                }
//                                var newText = text?.replacingOccurrences(of: ";", with: ",")
//                                self.order.dishChoice[self.dish] = newText!
//
//                                print(self.order.dishChoice[self.dish])
//        //                        self.saveGroup(text: text!)
//        //                        self.addtapped = true
//                                self.choice = self.order.dishChoice
//                            }
//                            print("alert here now")
//        //                    self.addtapped = true
//                        })
//                .navigationBarTitle("").navigationBarHidden(true)
//                .navigationBarBackButtonHidden(true)



//                        if(userProfile.userId != ""){
                            //order review add iteration
                            //need to check if most recnt order exists without review
//                            let prev = HomeScreenVM.checkPrevOrder(userID: userProfile.userId)
//                            if prev.1 {
                                //pop up about alert
                                
//                            }
//                            if prev[1]{
//
//                            }
                            
//                        }
