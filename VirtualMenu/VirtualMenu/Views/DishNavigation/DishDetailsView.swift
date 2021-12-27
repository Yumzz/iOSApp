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
    @Environment (\.colorScheme) var colorScheme : ColorScheme
    
//    @State private var keyboardHeight: CGFloat = 0
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var addtapped = false
    @State var addIt = false
    @State var isNavigationBarHidden: Bool = true
    
    @State var specInstruc: String = ""
    
//    @Binding var specInstruct: String
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
//    var uiTextAutoCapitalizationType:UITextAutocapitalizationType
//    var uiKeyboardType: UIKeyboardType

    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        ZStack{
            Color(colorScheme == .dark ? ColorManager.darkBack : #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
//            ScrollView(.vertical){
                ZStack {
                    #if !APPCLIP
                    VStack{
                        
                        if(dish.photoExists){
                            
                            FBURLImage(url:  dish.coverPhotoURL, imageWidth: 375, imageHeight: 240, circle: false)
                            Spacer()
                            
                        }
                        else{
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)).frame(width: 375, height: 240).foregroundColor(.black)
                            Spacer()
                        }
                    }
//                    #endif
                    
                    GeometryReader { fullView in
                        
//                        ScrollView(.vertical){
//                    #if !APPCLIP
                        ScrollView(.vertical){
                            ScrollViewReader{ scrollView in
                                VStack{
                                    
                                    VStack{
                                        
            //                            VStack{
                                       
                                        TextField("Insert Special Instructions here", text: $specInstruc)
                                            .frame(width: UIScreen.main.bounds.width - 40, height: 40, alignment: .center)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            
            //                                Spacer()
            //                            }
                                        HStack{
                                            Text(dish.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41) .foregroundColor(colorScheme == .dark ? .white : .black)
                                            Spacer()
    //                                        #if !APPCLIP
                                            TagCard(dish: dish, card: false, dark: colorScheme == .dark)
    //                                        #endif

                                        }
                                        Text("\(dish.description)").font(.system(size: 14, weight: .semibold)).foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
                                        
                                        
                                       
                                    }.padding()
    //                                .onDrag { () -> NSItemProvider in
    //
    //                                    scrollView.scrollTo( anchor: NSItemProvider.accessibilityActivationPoint())
    //                                }
                                    Spacer()
                                    //options
                                    if(!dish.options.isEmpty){
                                        VStack(spacing: 0){
                                            HStack{
                                                Text("Options")
                                                    .font(.system(size: 24))
                                            }
                                            VStack{
                                                OptionsCard(options: dish.options, exclusive: dish.exclusive, dark: colorScheme == .dark  ,dish: dish)
                                            }
                                        }
                                    }
                                    
                                    
                                    Spacer().frame(width: UIScreen.main.bounds.width, height: 40)
                                    
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
                                                .foregroundColor(colorScheme == .dark ? .white : Color.black)
                                                .frame(width: 30)
                                            Image(systemName: "plus")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                                .onTapGesture {
                                                    self.count = self.count + 1
                                                }
                                        }
                                        .padding()
                                        .background(colorScheme == .dark ? ColorManager.blackest : Color.white)
                                        .cornerRadius(10)
                                        .frame(width: 122, height: 48)

                                            HStack{
                                                if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                                                    if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                                                        Text("$\(String(dish.price))" + "00")
                                                            .font(.system(size: 16, weight: .semibold))
                                                            .font(.footnote)
                                                            .frame(width: 100)
                                                        Spacer()
                                                    }
                                                    else{
                                                        Text("$\(String(dish.price))" + "0")
                                                            .font(.system(size: 16, weight: .semibold))
                                                            .font(.footnote)
                                                            .frame(width: 100)
                                                        Spacer()
                                                    }
                                                }
                                                else{
                                                    Text("$\(String(dish.price))")
                                                        .font(.system(size: 16, weight: .semibold))
                                                        .font(.footnote)
                                                        .frame(width: 100)
                                                    Spacer()
                                                }
                                                
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
                                                
                                                if(specInstruc != ""){
                                                    if((self.order.dishChoice[dish]?.isEmpty) != nil){
                                                        self.order.dishChoice[dish] = ""
                                                    }
                                                    self.order.dishChoice[dish] = specInstruc
                                                    if !dish.choices.isEmpty{
                                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruct"), object: dish.choices)
                                                    }
                                                    specInstruc = ""
                                                }
                                                else{
                                                    self.order.dishChoice[dish] = ""
                                                    if !dish.choices.isEmpty{
                                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruct"), object: dish.choices)
                                                    }
                                                    specInstruc = ""
                                                }
                                                
            //                                    self.addtapped = true
                                                
                                                
                                            }
                                        
                                    }
            //                        Spacer()
                                }
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(colorScheme == .dark ? Color(ColorManager.darkBack) : Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1))))
                                .offset(y: dish.options.isEmpty ? 200 : 100)
                            }
                            
                        }.ignoresSafeArea(edges: .bottom)
                    }
                    #else
                    VStack{
                        
                        VStack{
                            
//                            VStack{
                            HStack{
                                Text(dish.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41) .foregroundColor(colorScheme == .dark ? .white : .black)
//                                        #if !APPCLIP
//                                        #endif
                            }
                            VStack{
                                Text("\(dish.description)").font(.system(size: 14, weight: .semibold)).foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.71, green: 0.71, blue: 0.71, alpha: 1))).tracking(-0.41)
//                                dish.description.lengthOfBytes(using: String.Encoding)
                            }.frame(height: max(80, CGFloat(dish.description.count/5)))
                                .onAppear(){
                                    print("size: \(CGFloat(dish.description.count/5))")
                                }
                            TextField("Insert Special Instructions here", text: $specInstruc)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 40, alignment: .center)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                
//                                Spacer()
//                            }
                           
                            
                            
                           
                        }.padding()
                            
//                                .onDrag { () -> NSItemProvider in
//
//                                    scrollView.scrollTo( anchor: NSItemProvider.accessibilityActivationPoint())
//                                }
//                        Spacer()
                        //options
                        if(!dish.options.isEmpty){
                            VStack(spacing: 0){
                                HStack{
                                    Text("Options")
                                        .font(.system(size: 24))
                                }
                                VStack{
                                    OptionsCard(options: dish.options, exclusive: dish.exclusive, dark: colorScheme == .dark  ,dish: dish)
                                }
                            }
                        }
                        
                        
//                        Spacer().frame(width: UIScreen.main.bounds.width, height: 40)
                        
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
                                    .foregroundColor(colorScheme == .dark ? .white : Color.black)
                                    .frame(width: 30)
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .onTapGesture {
                                        self.count = self.count + 1
                                    }
                            }
                            .padding()
                            .background(colorScheme == .dark ? ColorManager.blackest : Color.white)
                            .cornerRadius(10)
                            .frame(width: 122, height: 48)

                                HStack{
                                    if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                                        if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                                            Text("$\(String(dish.price))" + "00")
                                                .font(.system(size: 16, weight: .semibold))
                                                .font(.footnote)
                                                .frame(width: 100)
                                            Spacer()
                                        }
                                        else{
                                            Text("$\(String(dish.price))" + "0")
                                                .font(.system(size: 16, weight: .semibold))
                                                .font(.footnote)
                                                .frame(width: 100)
                                            Spacer()
                                        }
                                    }
                                    else{
                                        Text("$\(String(dish.price))")
                                            .font(.system(size: 16, weight: .semibold))
                                            .font(.footnote)
                                            .frame(width: 100)
                                        Spacer()
                                    }
                                    
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
                                    
                                    if(specInstruc != ""){
                                        if((self.order.dishChoice[dish]?.isEmpty) != nil){
                                            self.order.dishChoice[dish] = ""
                                        }
                                        self.order.dishChoice[dish] = specInstruc
                                        if !dish.choices.isEmpty{
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruct"), object: dish.choices)
                                        }
                                        specInstruc = ""
                                    }
                                    else{
                                        self.order.dishChoice[dish] = ""
                                        if !dish.choices.isEmpty{
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruct"), object: dish.choices)
                                        }
                                        specInstruc = ""
                                    }
                                    
//                                    self.addtapped = true
                                    
                                    
                                }
                            
                        }
//                        Spacer()
                    }
                    .keyboardAdaptive()
                    
                    
                    
                    
                    #endif
//                    }
                }
//                .padding(.bottom, keyboardHeight)
//                        // 3.
//                .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
//                Spacer()
//            }
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
//        .alert(isPresented: $addIt, TextFieldAlert(title: "Any Special Instructions?", message: dish.description) { (text) in
//                    if text != nil {
//                        print(text)
//                        self.order.dishChoice[dish] = text
////                        self.saveGroup(text: text!)
//                    }
//                })
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

//                            HStack{
//                                RoundedRectangle(cornerRadius: 5)
//                                    .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
//                                    .overlay(Text("4.5").foregroundColor(.black))
//
//                                .frame(width: 45, height: 20)
//                                Text("(298 reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41).foregroundColor(.black)
//                                Spacer()
//                            }
//                            TextField("Insert Special Instructions here", text: $specInstruc)
//                                .frame(width: UIScreen.main.bounds.width - 40, height: 40, alignment: .center)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())

//                            VStack(alignment: .leading, spacing: 0){
//                                Text("Special Instructions:")
//                                    .foregroundColor(ColorManager.yumzzOrange)
//
//                                TextField("Insert Special Instructions here", text: $specInstruc)
//                                    .frame(width: UIScreen.main.bounds.width - 40, height: 40, alignment: .center)
//                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                            }
