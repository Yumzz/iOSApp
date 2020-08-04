//
//  MenuSelectionView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct MenuSelectionView: View {
    @State var restChosen : RestaurantFB
    
    @State var isScannerSelected = false
    
    var body: some View {
        VStack{
            
            VStack{
                Text("Choose how you would like to view \(restChosen.name)'s menu")
                .padding(.horizontal)
                .foregroundColor(.black)
                .font(.custom("Futura Bold", size: 24))

            }
            
            Spacer().frame(height: 50)
            
            VStack(spacing: 30){
                NavigationLink(destination: ListDishesView(dishes: self.restChosen.dishes!)) {
                    Text("View Digital Menu")
                }
                
                CustomButton(action: {
                    self.isScannerSelected = true
                }) {
                    Text("Scan Physical Menu")
                }
                
                
                
            }
            Spacer().frame(height: 20)
            
        }.background(Color(UIColor().colorFromHex("#F88379", 1)))
        .navigationBarTitle("Menu Selection")
        .navigationBarHidden(false)
    }
}

//struct MenuSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuSelectionView(restChosen: <#T##RestaurantFB#>)
//    }
//}
