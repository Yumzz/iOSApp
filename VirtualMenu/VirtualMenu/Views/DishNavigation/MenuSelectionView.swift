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
            VStack(spacing: 60){
                NavigationLink(destination: ListDishesView(restaurant: self.restChosen)){
                    MenuButton()
                }
                .buttonStyle(PlainButtonStyle())
                

                NavigationLink(destination: ScanView(rest: self.restChosen)){
                    ScannerButton()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitle("Menu Selection")
        .navigationBarHidden(false)
    }
}

//struct MenuSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuSelectionView(restChosen: <#T##RestaurantFB#>)
//    }
//}

struct MenuButton: View {
    var body: some View {
        ZStack {
            
            
            VStack {
                Spacer()
            }
            .frame(width: 330, height: 120)
            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .opacity(0.1)
            
            VStack {
                Spacer()
            }
            .frame(width: 330, height: 120)
            .background(Color.init(red: 1.00,green: 0.48,blue: 0.45))
                .blur(radius: 5)
                .opacity(1)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            HStack(spacing: 16) {
                
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("See the Menu")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            
        }
    }
}

struct ScannerButton: View {
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
            }
            .frame(width: 330, height: 120)
            .background(Color.init(red: 0.24,green: 0.80, blue: 1.00))
                .blur(radius: 5)
                .opacity(1)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            HStack(spacing: 16) {
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 32, height: 24)
                
                Text("Scan the menu")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
}
