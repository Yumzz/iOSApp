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
    
    @State private var action: Int? = 0
    
    var body: some View {
        VStack(spacing: 10){
            FBURLImage(url: self.restChosen.coverPhotoURL)
                .frame(width: 220, height:150)
                .cornerRadius(30)
            HStack{
                Text(self.restChosen.name)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.custom("Montserrat", size: 26))
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
            }.frame(alignment: .center)
            Text(self.restChosen.ethnicity)
                .foregroundColor(Color.secondary)
                .font(.footnote)
            HStack{
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Rating")
                    .foregroundColor(Color.secondary)
                    .font(.footnote)
            }
            Divider()
            HStack{
                Button(action: {
                    print("Direction tapped!")
                }) {
                    VStack {
                        Image(systemName: "arrow.uturn.right")
                            .font(.title)
                        Text("Direction")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .frame(width: 80)
                    }
                    .padding()
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(30)
                    
                }
                
                Button(action: {
                    guard let number = URL(string: "tel://" + self.restChosen.phone) else { return }
                UIApplication.shared.open(number)

                }) {
                    VStack {
                        Image(systemName: "phone.fill")
                            .font(.title)
                        Text("Call")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .frame(width: 80)
                    }
                    .padding()
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(30)
                }
                
                
                NavigationLink(destination: ListDishesView(restaurant: self.restChosen)){
                    VStack {
                        Image(systemName: "doc.plaintext")
                            .font(.title)
                        Text("Menu")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .frame(minWidth: 80)
                    }
                    .padding()
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(30)
                }
            }
            Spacer()
        }
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
