//
//  OrderRecChoose.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/25/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderRecChoose: View {
    //need to input labels - clickable - ethnicity required
    
    let ethnicityLab = ["american", "caribbean", "chinese", "french", "german", "greek", "indian", "italian", "japanese", "korean", "mediterranean", "mexican", "moroccan", "russian", "spanish", "thai", "vietnamese"]
    let stapleLab = ["bread", "noodle", "rice", "salad", "pasta", "potato", "wheat"]
    let meatLab = ["beef", "pork", "chicken", "duck", "lamb", "turkey", "rabbit", "fish", "shrimp", "lobster", "plant-based"]
    let vegLab = ["antichoke", "asparagus", "avocado", "beet", "bok choy", "broccoli", "brussel", "carrot", "cauliflower", "chili", "corn", "cucumber", "eggplant", "garlic", "green bean", "mushroom", "olive", "pea", "potato", "radish", "tomato", "truffle"]
    let flavLab = ["hot", "juicy", "mild", "numb", "pickled", "salty", "savory", "sour", "spicy", "sweet"]
    let allergyLab = ["gluten", "crustaceans", "eggs", "fish", "peanuts", "soybeans", "milk", "nuts", "celery", "mustard", "sesame seeds", "lupin", "molluscs"]
    let veganLab = ["vegan", "vegetarian"]
    @State var labs: [[String]] = []
    @State var strings: [[String]:String] = [:]
    @State var choicesClicked: Set<String> = []
    @State var choicesRemoved: Set<String> = []
    @State var choiceString: String = ""
    @State var dishIngredString: String = ""
    @State private var results = [DishFB]()
    @ObservedObject var recVM = RecCardVM()
    @State var resultsGotten = false

    
    var body: some View {
        VStack{
            Spacer().frame(width: UIScreen.main.bounds.width, height: 20)
            Text("Please Select Your Cravings!")
            ScrollView(.vertical){
                Spacer().frame(width: UIScreen.main.bounds.width, height: 40)
                ForEach(self.labs, id:\.self){ lab in
                    VStack{
                        Text(self.strings[lab]!)
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(lab, id:\.self){ l in
                                    Group{
                                            Text("\(l)")
                                            .foregroundColor(Color("BlackestOffWhite"))
                                                RoundedRectangle.init(cornerRadius: 5)
                                                .fill((self.choicesClicked.contains(l)) ? ColorManager.yumzzOrange : Color.white)
                                                .border(ColorManager.yumzzOrange)
                                                .onTapGesture(){
                                                    if(self.choicesClicked.contains(l)){
                                                        self.choicesRemoved.insert(l)
                                                        self.choicesClicked.remove(l)
                                                        choicesRemoved.removeAll()
                                                    }
                                                    else{
                                                        self.choicesClicked.insert(l)
                                                    }
                                                }
                                                .frame(width: 20, height: 20)
                                        
                                    }
                                    .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                    
                                }
                            }
                        }.background(Color("PinkishOrange"))
                    
                    }
                }
                OrangeButton(strLabel: "Get Recommendation", width: 200, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    .onTapGesture {
                        choiceString = ""
                        for cS in choicesClicked {
                            choiceString += cS + ", "
                        }
                        let dgroup = DispatchGroup()
                        dgroup.enter()
                        recVM.compareDishes(userTP: choiceString, disp: dgroup)
                        dgroup.notify(queue: .main){
                            results = recVM.maxes
                            self.resultsGotten = true
                            self.choicesClicked.removeAll()
                        }

                    }
                Spacer().frame(width: UIScreen.main.bounds.width, height: 40)
            }
        }.onAppear(){
            self.labs = [ethnicityLab, stapleLab, meatLab, vegLab, flavLab, allergyLab, veganLab]
            self.strings = [ethnicityLab: "Ethnicity", stapleLab: "Staple", meatLab: "Meat", vegLab : "Vegetables", flavLab: "Flavour", allergyLab : "Allergies", veganLab : "Vegan/Vegetarian"]
        }
//        .navigationBarTitle("Please Select Your Cravings!")
        .overlay(ReviewsBottomSheetModal(display: self.$resultsGotten, backgroundColor: .constant(Color(UIColor().colorFromHex("#FFFFFF", 1))), rectangleColor: .constant(Color(UIColor().colorFromHex("#656565", 1)))) {
                ZStack{
                    Text("Here are the best dishes in your local area for your cravings!")
                    Spacer().frame(height: 100)
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(self.results, id: \.id){
                                dish in
        //                                            #if !APPCLIP
                                
//                                NavigationLink(
//                                    destination: DishDetailsView(dish: dish, restaurant: dish.res).navigationBarHidden(false)
//                                ) {
                                    RecommendedDishCard(dish: dish)
//                                }
                            }
                        }
                    }.frame(height: 150)
                }
                }
            )
    }
    
}

struct RecommendedDishCard: View {
    var dish: DishFB
//    var p = ""
    var body: some View {
        VStack {
            if dish.photoExists {
                HStack {
                    FBURLImage(url: dish.coverPhotoURL, imageWidth: 175, imageHeight: 88, circle: false)
                        .frame(width: 175, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
            }
            HStack{
                Text(dish.name).foregroundColor(Color("Back")).font(.system(size: 18, weight: .bold)).tracking(-0.41)
                Spacer()
            }
            HStack{
                Text(dish.description).foregroundColor(Color("Back")).font(.system(size: 14, weight: .bold))
//                Spacer()
            }
            HStack{
                if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                    if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                        Text(String(dish.price) + "00").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("GreyWhite")).tracking(-0.41)
                        Spacer()
                    }
                    else{
                        Text(String(dish.price) + "0").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("GreyWhite")).tracking(-0.41)
                        Spacer()
                    }
                }
                else{
                    Text(String(dish.price)).font(.system(size: 12, weight: .semibold)).foregroundColor(Color("GreyWhite")).tracking(-0.41)
                    Spacer()
                }
                
            }
        }.frame(width: 175, height: 150)
        .padding(.leading, 5)
//        .onAppear(){
//            var oh = ""
//            if(String(dish.price).numOfNums() < 4){
//                if(String(dish.price).numOfNums() < 3){
//                    oh = String(dish.price) + "00"
//                }
//                else{
//                    oh = String(dish.price) + "0"
//                }
//            }
//            else{
//                oh = String(dish.price)
//            }
//
//        }
    }
}
//
//struct Response: Codable {
//    var results: [Resulted]
//}
//
//struct Resulted: Codable {
//    var trackId: Int
//    var trackName: String
//    var collectionName: String
//}
