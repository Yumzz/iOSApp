//
//  MenuSelectionView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

struct MenuSelectionView: View {
    var restChosen : RestaurantFB
    
    @State private var action: Int? = 0
    
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    
    init(restChosen: RestaurantFB) {
        self.restChosen = restChosen
        self.menuSelectionVM = MenuSelectionViewModel(restaurant: self.restChosen)
    }
    
    var body: some View {
        VStack(spacing: 10){
            FBURLImage(url: self.restChosen.coverPhotoURL, imageWidth: 220, imageHeight: 160)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            HStack{
                Text(self.restChosen.name)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .font(.custom("Montserrat", size: 26))
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
                    let regionDistance:CLLocationDistance = 10000
                    let coordinates = CLLocationCoordinate2DMake(self.restChosen.coordinate.latitude, self.restChosen.coordinate.longitude)
                    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                    let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                    ]
                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name=self.restChosen.name
                    mapItem.openInMaps(launchOptions: options)
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
//            ScrollView(.horizontal) {
//                HStack(spacing: 15) {
//                    ForEach(0..<(self.menuSelectionVM.featuredDishes.count/2 + 1), id: \.self) {
//                        column in
//                        VStack(alignment: .leading, spacing: 15) {
//                            if column*2 < self.menuSelectionVM.featuredDishes.count {
//                                PreviewDish(dish: self.menuSelectionVM.featuredDishes[column*2], restChosen: self.restChosen).frame(alignment: .top)
//                            }
//                            if column*2+1 < self.menuSelectionVM.featuredDishes.count {
//                                PreviewDish(dish: self.menuSelectionVM.featuredDishes[column*2+1], restChosen: self.restChosen)
//                            }
//                        }.frame(height: 180)
//                    }
//                }
//            }
            .padding(15)
            .frame(height: 180)
            Spacer()
        }
        .navigationBarHidden(false)
    }
}

struct MenuSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MenuSelectionView(restChosen: RestaurantFB.previewRest())
    }
}

struct PreviewDish: View {
    @State var dish: DishFB
    @State var restChosen: RestaurantFB
    
    var body: some View {
        NavigationLink(destination: DishDetailsView(dish: self.dish, restaurant: self.restChosen).navigationBarHidden(false)) {
            FBURLImage(url: self.dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 160, imageHeight: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
}

