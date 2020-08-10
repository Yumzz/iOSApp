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
            Spacer().frame(height: 100)
            VStack{
                
                VStack{
                    Text("How do you want to view \(restChosen.name)'s menu")
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.custom("Futura Bold", size: 24))
                }
                
                Spacer()
                
                VStack(spacing: 30){
                    HStack{
                        Image("ar").resizable().frame(width: 200, height: 55).overlay(NavigationLink(destination: ListDishesView(rest: self.restChosen)){
                            Text("View Digital Menu")
                        })
                    }
                    
                    HStack{
                        Image("ar").resizable().frame(width: 200, height: 55).overlay(NavigationLink(destination: ScanView(rest: self.restChosen)){
                            Text("Scan Physical Menu")
                        })
                    }
                }
                
            }
            
        }.navigationBarTitle("Menu Selection")
        .navigationBarHidden(false)
        .background(Color(UIColor().colorFromHex("#F88379", 1)))
    }
}

//struct MenuSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuSelectionView(restChosen: <#T##RestaurantFB#>)
//    }
//}
