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
    @State private var recButtonClicked = false
    
    @State var rest = RestaurantFB.previewRest()
    @State private var restChosen = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero


    
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
                if(self.recButtonClicked){
                    view.overlay(overlay, alignment: .bottom)
                }
                else{
                    view.overlay(overlay, alignment: .bottom)
                        .overlay(recButt, alignment: .bottomLeading)
                }
                
            } else {
                if(self.recButtonClicked){
                    view
                }
                else{
                    view
                       .overlay(recButt, alignment: .bottomLeading)
                }
             }
            if self.recButtonClicked {
                ZStack {
                    Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))
                    VStack {
                        RecView(isOpen: self.$recButtonClicked)
                    }.padding()
                }
                .frame(width: 329, height: 374)
                .cornerRadius(20).shadow(radius: 20)
                .transition(.slide)
                .animation(.default)
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
    
    var recButt: some View {
        VStack{
            EmptyView()
//            RecButton()
//                .onTapGesture {
//                    self.recButtonClicked = true
//                }
//
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
                Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Yumzz").font(.system(size: 36, weight: .bold)).frame(alignment: .leading)
                        Spacer()
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 24, weight: .bold)).padding()
                            .onTapGesture{
                                self.activeSheet = .second
                                self.qrCodeShow = true
                                self.qrCodeShow2 = false
                            }
                        
                        if (userProfile.userId == ""){
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
                    }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1))).frame(alignment: .top).padding()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Near you").font(.system(size: 24, weight: .semibold)).foregroundColor(.black)
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
                                Text("Popular in \(city)").font(.system(size: 24, weight: .semibold)).foregroundColor(.black)
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
    //                .background(Color(red: 0.953, green: 0.945, blue: 0.933))
                
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .popover(isPresented: self.$qrCodeShow){
                    QRScanView(completion: { textPerPage in
                        if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                            print("wow: \(text)")
                        }
                    }).onDisappear(){
                        activeSheet = .first
                        self.qrCodeShow = false
//                        self.restChosen = false
                        
                    }
                }
                .navigationBarTitle("").navigationBarHidden(true)
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
                        
                    }
                }
            }
        }
//
        
    }
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
                    Text(restaurant.name).font(.system(size: 18, weight: .bold)).tracking(-0.41).foregroundColor(.black)
                    Spacer()
                }
                HStack{
                    Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.location.removeZerosFromEnd()) miles").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
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
