//
//  RestaurantMapView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantMapView: View {
    @State var strSearch: String = ""
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                MapView().edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search restaurant", text: self.$strSearch)
                        
                    }.frame(width: geometry.size.width - 100)
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.primary)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(10.0)
                    .shadow(radius: 5)
                    
                    Spacer()
                    HStack(spacing: 10){
                        Spacer()
                        Button(action: {
                            print("Locate button tapped!")
                        }) {
                            Image(systemName: "location")
                            
                            
                        }.padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .frame(width: geometry.size.width - 60)
                    .padding(.bottom, 75)
                    
                }
            }
        }
    }
}

struct RestaurantMapView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMapView()
    }
}

