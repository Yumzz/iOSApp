//
//  BuildCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/9/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct BuildCard: View {
    var build: BuildFB
    @State var typeClicked: String = ""
    @State var addOnClicked: Set<String> = []
    @State var typesClicked: Set<String> = []
    @State var sizeClicked: String = ""
    @State var indexPrice: Int = -1
    @State var count: Int = 1
    @State var total = 0.00
//    var dark: Bool = false
    @Environment (\.colorScheme) var colorScheme : ColorScheme
    
    var d = DispatchGroup()

    var rest: RestaurantFB

    #if !APPCLIP
    @EnvironmentObject var order : OrderModel
    #endif
    
    var body: some View {
        ZStack {
            if build.individCost {
                HStack{
                    VStack{
                    ForEach(self.build.typeOpt, id: \.self){
                        type in
                        
                        Text("\(type)")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
//                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(Font.headline.weight(.bold))
                            .font(.system(size: 24))
//                            .onTapGesture {
//                                print(type)
//                            }
//                        ZStack{
                        VStack{
                            ForEach(self.build.addOns[type]!, id: \.self){
                                 option in
                                HStack{
                                    Text("\(option): $" + String.priceFix(price: (self.build.individualCosts[type]![((Int) (self.build.addOns[type]!.firstIndex(of: option)!))])))
                                        .foregroundColor(.black)
//
                                    
                                        
//                                    Text("\(option): $\(((Double) (self.build.individualCosts[type]![((Int) (self.build.addOns[type]!.firstIndex(of: option)!))])!).removeZerosFromEnd())")

                                    Spacer()
                                    
                                    RoundedRectangle.init(cornerRadius: 5)
                                        .fill(self.addOnClicked.contains(option) ? ColorManager.yumzzOrange : Color.white)
                                        .border(ColorManager.yumzzOrange)
                                        
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(ColorManager.yumzzOrange)
                                        .onTapGesture {
                                            let idx = (Int) (self.build.addOns[type]!.firstIndex(of: option)!)
                                            let ingredCost = (Double) (self.build.individualCosts[type]![idx])
                                            if(self.addOnClicked.contains(option)){
                                                self.addOnClicked.remove(option)
                                                self.total -= ingredCost!
//                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: true)
//
                                            }
                                            else{

                                                self.addOnClicked.insert(option)
                                                self.total += ingredCost!
//                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: true)
                                            }
                                        }
                                
                                
                                }
                                
//                                .background(colorScheme == .dark ? Color.black : Color.white)
//                        .frame(height: 112)
                                
//
//                        .cornerRadius(10)
                            
                        }
//                            .background(dark ? Color.white : Color.white)
                        
                        }
                        .padding(.horizontal)
                        .background(colorScheme == .dark ? ColorManager.offWhiteBack : Color.white)
//                        .frame(height: CGFloat((self.build.addOns[type]!.count))*32)
                        .cornerRadius(10)
                        
                        
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
                                Text("$\(String.priceFix(price: String (self.total + build.basePrice)))")
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
                                    //if size not clicked then show alert
                                    // go through each clicked option and add up based on type clicked
                                    #if !APPCLIP
//                                    var i = 0
//                                    while i < self.count{
//                                        self.d.enter()
                                        self.order.addBuildOwn(build: self.build, rest: self.rest, dis: d, total: self.total, optionsChosen: self.addOnClicked)
//                                        self.d.notify(queue: .main){
//                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: false)
//                                        }
//                                        i += 1
//                                    }
                                    #endif
                                    
                                }
                            }
                        
                    }.cornerRadius(10)
                }
            }

            else{
                VStack{
                    Text("Select Size:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                    HStack{
                        ForEach(self.build.typePrice, id: \.self){
                            type in
                            VStack{
                            Text("\(type)")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .font(.subheadline)
                                .onTapGesture {
                                    print(type)
                                }
                                .foregroundColor(.black)
                                ForEach(self.build.exclusiveOpts[type]!, id: \.self){
                                    size in
    //                                HStack{
                                    Text("\(size): $\(self.build.sizePrice[type]![self.build.exclusiveOpts[type]!.firstIndex(of: size)!])")
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .background(((self.typeClicked == type) && (self.sizeClicked == size)) ? ColorManager.yumzzOrange.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)) : ColorManager.offWhiteBack.clipShape(RoundedRectangle(cornerRadius: 10, style: .circular)))
                                        .onTapGesture {
                                            self.addOnClicked.removeAll()
                                            self.typesClicked.removeAll()
                                            if((self.typeClicked == type) && (self.sizeClicked == size)){
                                                self.typeClicked = ""
                                                self.sizeClicked = ""
                                                self.total = 0.00
    //                                            self.total -= Double(self.build.sizePrice[type]![self.build.exclusiveOpts[type]!.firstIndex(of: size)!])!
                                            }
                                            
                                            else{
                                                self.total = Double(self.build.sizePrice[type]![self.build.exclusiveOpts[type]!.firstIndex(of: size)!])!
                                                self.sizeClicked = size
                                                self.typeClicked = type
                                                self.indexPrice = self.build.exclusiveOpts[self.typeClicked]!.firstIndex(of: self.sizeClicked)!
                                            }
                                    
                                        }
                            }
                        }
                    }
                }
                    Text("Select Options:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    ForEach(self.build.typeOpt, id: \.self){
                        opt in
                        HStack{
                            Text("\(opt)")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            ForEach(self.build.typePrice, id: \.self){
                                type in
                                StyledText(verbatim: "\(type): +\(self.build.priceOpts[opt]![type]!.componentsJoined(by: "/"))")
                                .style(.highlight(), ranges: { self.indexPrice == -1 ? [$0.range(of: " " )!] :(self.typeClicked == type ? [$0.range(of: "\(self.build.priceOpts[opt]![self.typeClicked]![self.indexPrice])")!] : [$0.range(of: " " )!]
                                        ) })
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                        
                    VStack{
                        ScrollView{
                            ForEach(self.build.addOns[opt]!, id: \.self){
                                option in
                                HStack{
                                    Text("\(option)")
                                        .foregroundColor(colorScheme == .dark ? .white : .black)

                                    Spacer()
                                    
                                    RoundedRectangle.init(cornerRadius: 5)
                                        .fill(self.addOnClicked.contains(option) ? ColorManager.yumzzOrange : Color.white)
                                        .border(ColorManager.yumzzOrange)
                                        
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(ColorManager.yumzzOrange)
                                        .onTapGesture {
                                            if(self.addOnClicked.contains(option)){
                                                if(self.typeClicked == ""){
                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: true)
                                                }
                                                else{
                                                    self.addOnClicked.remove(option)
                                                    var bo = false
                                                    for x in self.addOnClicked {
                                                        if(self.build.addOns[opt]!.contains(x)){
                                                            bo = true
                                                            break
                                                        }
                                                    }
                                                    if(!bo){
                                                        self.typesClicked.remove(opt)
                                                        print("rem: \(self.typesClicked)")
                                                        if(self.typeClicked != ""){
                                                            self.total -= (self.build.priceOpts[opt]![self.typeClicked]![self.indexPrice] as! Double)
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                if(self.typeClicked == ""){
                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: true)
                                                }
                                                else{
                                                    self.addOnClicked.insert(option)
                                                    print("rem: \(self.typesClicked)")
                                                    if(self.typeClicked != ""){
                                                        if(!self.typesClicked.contains(opt)){
                                                            self.total += (self.build.priceOpts[opt]![self.typeClicked]![self.indexPrice] as! Double)
                                                        }
                                                    }
                                                    self.typesClicked.insert(opt)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        
                    }.background(Color.white)
                    .frame(width: UIScreen.main.bounds.width/1.3, height: 150, alignment: .center)
                    .padding()
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
                            Text("$\(self.total.removeZerosFromEnd())")
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
                            if(self.sizeClicked == ""){
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: true)
                            }
                            else{
                                //if size not clicked then show alert
                                // go through each clicked option and add up based on type clicked
                                #if !APPCLIP
                                var i = 0
                                while i < self.count{
                                    self.d.enter()
                                    self.order.addBuildOwn(build: self.build, rest: self.rest, dis: d, total: self.total, optionsChosen: self.addOnClicked)
                                    self.d.notify(queue: .main){
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: false)
                                    }
                                    i += 1
                                }
                                #endif
                                
                            }
                        }
                    
                }
                }
            }
        }.cornerRadius(10)
    }
}

