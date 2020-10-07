//
//  HomeScreenView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var HomeScreenVM : HomeScreenViewModel
    
    init() {
        self.HomeScreenVM = HomeScreenViewModel()
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Yumzz").font(.system(size: 36, weight: .bold)).frame(alignment: .leading)
                        Spacer()
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 24, weight: .bold)).padding()
                        Image(systemName: "person.crop.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1))).frame(alignment: .top).padding()
                    
                    HStack {
                        Text("Near you").font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }.padding()
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(self.HomeScreenVM.allRestaurants, id:\.id) { restaurant in
                                Text(restaurant.name)
                            }
                        }
                    }.frame(height: 135).padding()
                    
                    Spacer()
                }
            }
        }
    }
}

struct HSRestaurantCard: View {
    var restaurant: RestaurantFB
    
    var body: some View {
        VStack {
            FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 175, imageHeight: 88)
                .frame(width: 175, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(restaurant.name).font(.system(size: 18, weight: .bold)).tracking(-0.41)
            Text("$$ | Asian | 200m").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
        }.frame(width: 175, height: 130)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
