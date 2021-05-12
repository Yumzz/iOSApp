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
                                numChoose(attribute: attr, range: 1)
                            }
                            else{
                                numChoose(attribute: attr, range: 4)
                            }
                        }
                        
                    }
                }
                VStack{
                    MatchMeButton()
                        .onTapGesture {
                            self.recViewModel.getRecommendation(tp: [])
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
    
    var body: some View {
        
        HStack{
            Text(attribute + " level: \(num)")
            
            Spacer().frame(width: 30)
            Picker("", selection: $num){
                
                ForEach(0...range, id:\.self){
                    Text("\($0)")
                }
            }.frame(width: 40, height: 30).clipped()
        }
        
    }
}
