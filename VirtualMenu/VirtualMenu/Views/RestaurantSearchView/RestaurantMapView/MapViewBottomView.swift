//
//  MapViewBottomView.swift
//  VirtualMenu
//
//  Created by William Bai on 9/12/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import SwiftUI
import MapKit

struct MapViewBottomView: View {
    var restChosen : RestaurantFB
    
    @State private var action: Int? = 0
    
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var showPopUp = false

    
    init(restChosen: RestaurantFB) {
        self.restChosen = restChosen
        self.menuSelectionVM = MenuSelectionViewModel(restaurant: self.restChosen)
    }
    
    var body: some View {
        ZStack{
            ScrollView{
            VStack(spacing: 10){
                VStack{
//                    FBURLImage(url: self.restChosen.coverPhotoURL, imageWidth: 190, imageHeight: 133)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    HStack{
                        Text(self.restChosen.name)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                            .font(.custom("Montserrat", size: 26))
                    }
                    Text(self.restChosen.ethnicity)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                        
                    HStack(spacing: 20){
                        if self.restChosen.n_Ratings > 0 {
                            StarRatingView(rating: .constant(Int(Float(self.restChosen.ratingSum) / Float(self.restChosen.n_Ratings))), fontSize: 12)
                            Text(String(format: "%.2f", Double(self.restChosen.ratingSum) / Double(self.restChosen.n_Ratings)))
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                            Text("(" + String(self.restChosen.n_Ratings) + " ratings)")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                        } else {
                            Text("No Ratings Yet")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                        }
                    }
                }
                Divider()
                HStack(spacing: 30){
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
                                .font(.system(size: 18))
                            Text("Direction")
                                .fontWeight(.semibold)
                                .font(.system(size: 10))
                                .frame(width: 46)
                        }
                        .padding()
                        .foregroundColor(.red)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    
                    Button(action: {
                        guard let number = URL(string: "tel://" + self.restChosen.phone) else { return }
                    UIApplication.shared.open(number)

                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 18))
                            Text("Call")
                                .font(.system(size: 10))
                                .font(.footnote)
                                .frame(width: 46)
                        }
                        .padding()
                        .foregroundColor(.red)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    
                    
                    NavigationLink(destination: ListDishesView(restaurant: self.restChosen)){
                        VStack {
                            Image(systemName: "doc.plaintext")
                                 .font(.system(size: 18))
                            Text("Menu")
                                .font(.system(size: 10))
                                .font(.footnote)
                                .frame(width: 46)
                        }
                        .padding()
                        .foregroundColor(.red)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
                Button(action: {
                    self.showPopUp = true
                }) {
                    HStack {
                        Image(systemName:"square.and.pencil")
                            .font(.system(size: 18))
                        Text("Add Your Rating")
                            .fontWeight(.semibold)
                            .font(.system(size: 10))
                            .frame(width: 100)
                    }
                    .padding()
                    .foregroundColor(.red)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(0..<(self.menuSelectionVM.featuredDishes.count/2 + 1), id: \.self) {
                            column in
                            HStack(alignment: .center, spacing: 15) {
                                if column*2 < self.menuSelectionVM.featuredDishes.count {
                                    PreviewDish(dish: self.menuSelectionVM.featuredDishes[column*2], restChosen: self.restChosen).frame(alignment: .top)
                                }
                                if column*2+1 < self.menuSelectionVM.featuredDishes.count {
                                    PreviewDish(dish: self.menuSelectionVM.featuredDishes[column*2+1], restChosen: self.restChosen)
                                }
                            }.frame(height: 180)
                        }
                    }
                }
//                .padding(15)
                .frame(height: 110)
                Spacer()
            }.padding(.top, 15)
            }.background(BottomMapGradientView().edgesIgnoringSafeArea(.all))
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
                
            if $showPopUp.wrappedValue {
                ZStack {
                    Color.white
                    VStack {
                        EmptyView()
                        Button(action: {
                            self.showPopUp = false
                        }, label: {
                            Text("No Thanks")
                            .underline()
                        })
                    }.padding()
                }
                .frame(width: 350, height: 450)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
    }
}

struct MapViewBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewBottomView(restChosen: RestaurantFB.previewRest())
    }
}
