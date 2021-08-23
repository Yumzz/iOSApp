//
//  RecView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/10/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct RecView: View {
    @Binding var isOpen: Bool
    var attributes = ["Spiciness", "Oiliness", "Saltiness", "Sweetness", "Temperature", "Vegan", "Vegetarian"]
    var recViewModel = RecViewModel()
    var matchGiven: Bool = false
    @State private var tasteprofile = [0,0,0,0,0,0,0]
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).ignoresSafeArea(.all)
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Button(action:{
                        self.isOpen = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
                ScrollView(.vertical) {
                    VStack {
                        ForEach(self.attributes, id: \.self){ attr in
                            if(attr == "Vegan" || attr == "Vegetarian"){
                                numChoose(attribute: attr, range: 1, tasteProf: self.$tasteprofile)
                            }
                            else{
                                numChoose(attribute: attr, range: 4, tasteProf: self.$tasteprofile)
                            }
                        }.foregroundColor(.black)
                        
                    }
                }
                VStack{
                    MatchMeButton()
                        .onTapGesture {
                            self.recViewModel.getRecommendation(tp: tasteprofile)
                            
                        }
                }
                
            }
        }
            
    }

}

struct numChoose: View {
    @State private var num = 1
    var attribute: String
    var range: Int
    @Binding var tasteProf: [Int]
    var attrToIndex = ["Spiciness": 0 , "Oiliness": 1, "Saltiness": 2, "Sweetness": 3, "Temperature": 4, "Vegan": 5, "Vegetarian": 6]
    
    var body: some View {
        
        HStack{
            Text(attribute + " level: \(tasteProf[attrToIndex[attribute]!])")
            
            Spacer().frame(width: 30)
            Picker("", selection: $tasteProf[attrToIndex[attribute]!]){
                ForEach(0...range, id:\.self){
                    Text("\($0)").foregroundColor(.black)
                }
            }.frame(width: 40, height: 30).clipped()
        }
        
    }
}
