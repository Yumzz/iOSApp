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
    @State private var results = [Resulted]()
    @ObservedObject var recVM = RecCardVM()
    
    var body: some View {
        VStack{
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
                        print("choices: \(choiceString)")
//                        recVM.compareDishes(userTP: choiceString)
                        
                        self.choicesClicked.removeAll()

                    }
                Spacer().frame(width: UIScreen.main.bounds.width, height: 40)
            }
        }.onAppear(){
            self.labs = [ethnicityLab, stapleLab, meatLab, vegLab, flavLab, allergyLab, veganLab]
            self.strings = [ethnicityLab: "Ethnicity", stapleLab: "Staple", meatLab: "Meat", vegLab : "Vegetables", flavLab: "Flavour", allergyLab : "Allergies", veganLab : "Vegan/Vegetarian"]
        }
        
    }
    
//    func loadData() async {
//        guard let url = URL(string: "https://yumzztasteprofile.azurewebsites.net/api/YumzzPredictionAPIV2?code=k3EK4IBtnVunHEZD0M07LJrZgk90Mq9usP9tg8Am5mSN9jytHsIkpg==&user_tp_raw=\(choiceString)&dishes_tp_raw=\(dishIngredString)beef,fish;fish,japanese;chinese,noodle,hotpot") else {
//            print("Invalid URL")
//            return
//        }
//        do {
//            if #available(iOS 15.0, *) {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//                    results = decodedResponse.results
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//
//        } catch {
//            print("Invalid data")
//        }
//
//    }
    
//    func getData() {
//        Task {
//            await loadData()
//        }
//    }
    
    
}

struct Response: Codable {
    var results: [Resulted]
}

struct Resulted: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
