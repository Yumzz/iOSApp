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
    @State private var qrCodeShow2 = false
 
    
    @State var restaurants = [RestaurantFB]()
    @State var cityRests = [String: [RestaurantFB]]()
    
    @State var cities = [String]()
    @State private var waitButtonClicked = false
    
    @State var rest = RestaurantFB.previewRest()
    @State private var restChosen = false
    @State private var callWaiter = false
    @State private var IoT = false
    @State var orderRevNeed = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @Environment (\.colorScheme) var colorScheme : ColorScheme

    
    @State private var activeSheet: ActiveSheet?
    
    let dispatchGroup = DispatchGroup()
    
    @EnvironmentObject var order : OrderModel
    
    var locationManager = LocationManager()

    init() {
        self.HomeScreenVM = HomeScreenViewModel(dispatch: dispatchGroup)
        
    }
    
    
    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
                if(self.waitButtonClicked){
                    view.overlay(WaiterConnection(rest: self.order.restChosen), alignment: .bottom)
                }
                else{
                    view.overlay(overlay, alignment: .bottom)
//                        .overlay(waitButt, alignment: (self.order.dishesChosen || !self.order.buildsChosen.isEmpty) ? .topTrailing : .bottomLeading)
                        .overlay(waitButt, alignment: .topTrailing)
                }
                
            } else {
                if(self.waitButtonClicked){
                    view
                }
                else{
                    view
                       .overlay(waitButt, alignment: .bottomLeading)
                }
             }
            if self.waitButtonClicked {
                view.sheet(isPresented: self.$waitButtonClicked){
                    WaiterConnection(rest: self.order.restChosen)
                }
                
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
            }
        }
    }
    
    var overlay: some View {
        VStack{
            NavigationLink(destination: ReviewOrder()){
                ViewCartButton(dishCount: self.order.allDishes)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            Spacer().frame(width: 0, height: 10)
        }
    }
    
    var waitButt: some View {
        VStack{
            if(!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty){
                Spacer().frame(height: 100)
            }
//            EmptyView()
            OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48, dark: colorScheme == .dark)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .onTapGesture {
                    self.callWaiter = true
                    self.IoT = true
                    self.waitButtonClicked = true
                }
            Spacer().frame(height: 20)
//            RecButton()
//                .onTapGesture {
//                    self.recButtonClicked = true
//                }
//
            if(self.order.dishesChosen != [] || !self.order.buildsChosen.isEmpty){
                Spacer().frame(height: 20)
            }
//            Spacer().frame(width: 0, height: (!self.order.dishesChosen.isEmpty || !self.order.buildsChosen.isEmpty) ? 70 : 10)
        }
    }
    
    var view: some View{
    GeometryReader { geometry in
        if(self.restChosen){
            RestaurantHomeView(restaurant: self.rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: self.rest.coordinate))
                .onAppear(){
                    print("here")
                    print("wohoo: \(self.HomeScreenVM.getDistFromUser(coordinate: self.rest.coordinate)) \(self.rest.coordinate)")
                }
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(false)
                .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
//                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
//                    if(value.translation.width > 100) {
//                        self.mode.wrappedValue.dismiss()
//                    }
//                }))
        }
        else{
            ZStack {
                Color(colorScheme == .dark ? ColorManager.darkBack : #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 60)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Near you").font(.system(size: 24, weight: .semibold)).foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                        }.padding()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30) {
                                ForEach(self.restaurants, id:\.id) { restaurant in

                                    NavigationLink(
                                        destination: RestaurantHomeView(restaurant: restaurant, distance: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate))
                                    ) {
                                        HSRestaurantCard(restaurant: restaurant, location: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate),dark: colorScheme == .dark)
                                    }
                                }
                            }
                        }.frame(height: 150).padding()
                        
                        
                        ForEach(self.cities, id:\.self) { city in
                            
                            HStack{
                                Text("Popular in \(city)").font(.system(size: 24, weight: .semibold)).foregroundColor(colorScheme == .dark ? .white : .black)
                                Spacer()
                            }.padding()
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 30) {
                                    
                                    ForEach(self.cityRests[city]!, id:\.self) { rest in

                                        NavigationLink(
                                            destination: RestaurantHomeView(restaurant: rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate))
                                        ) {
                                            HSRestaurantCard(restaurant: rest, location: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate), dark: colorScheme == .dark)
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
                            .foregroundColor(colorScheme == .dark ? .white : ColorManager.yumzzOrange)
                        Spacer().frame(width: UIScreen.main.bounds.width/5)
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 24, weight: .bold)).padding()
                            .foregroundColor(colorScheme == .dark ? ColorManager.darkModeOrange : ColorManager.yumzzOrange)
                            .onTapGesture{
                                print("touched qr")
                                self.activeSheet = .second
                                self.qrCodeShow = true
                                self.qrCodeShow2 = false
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
                    }.foregroundColor(colorScheme == .dark ? ColorManager.darkModeOrange : Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
//                        .frame(alignment: .top)
                        .padding()
                        .onTapGesture(){
                            print("tapped hstack")
                        })
                
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .popover(isPresented: self.$qrCodeShow){
//                    Home
//                    QRScanView(completion: { textPerPage in
//                        if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                            print("wow: \(text)")
//                        }
//                    })
                    MenuConnection()
                        .onDisappear(){
                        activeSheet = .first
                        self.qrCodeShow = false
//                        self.restChosen = false
                        
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
                .onAppear(){
                    self.dispatchGroup.notify(queue: .main){
                        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ChooseRest"), object: nil, queue: .main) { [self] (Notification) in
                            
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
                            print("ask: \(rest)")
                            
                            d.notify(queue: .main){
                //                self.rest = self.restaurants.first(where: { $0.name == rest })!
                                
                                self.activeSheet = .first
                                self.restChosen = true
                                
                                self.rest = self.restaurants.first(where: { $0.id.replacingOccurrences(of: " ", with: "") == rest })!
                                print("ask: \(self.rest.description)")
                                self.qrCodeShow = false
                                self.qrCodeShow2 = true
                                print("ask1: \(self.qrCodeShow)")
                                
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
                        if(userProfile.userId != ""){
                            //order review add iteration
                            //need to check if most recnt order exists without review
//                            let prev = HomeScreenVM.checkPrevOrder(userID: userProfile.userId)
//                            if prev.1 {
                                //pop up about alert
                                
//                            }
//                            if prev[1]{
//                                
//                            }
                            
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
    var dark: Bool = false
    
    var body: some View {
            VStack {
                HStack {
                    FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 175, imageHeight: 88, circle: false)
                        .frame(width: 175, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                HStack{
                    Text(restaurant.name).font(.system(size: 18, weight: .bold)).tracking(-0.41).foregroundColor(dark ? .white : .black)
                    Spacer()
                }
                HStack{
                    Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.location.removeZerosFromEnd()) miles").font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
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
