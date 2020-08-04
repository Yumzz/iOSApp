//
//  StartViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/30/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct StartView: View {
    
    
    @State private var isShowingScannerSheet = false
    @State private var text: String = ""
    
    @State var restChosen: RestaurantFB
    
    
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                
                Text("Restaurant: \(self.restChosen.name)")

                Spacer()
            }
            
            VStack(spacing: 50){
//                NavigationLink(destination: RestaurantMapView()) {
//                    Text("Find on the Map")
//                }
                
                Text("Menu viewing options:")
                
                NavigationLink(destination: ListDishesView(dishes: self.restChosen.dishes!).navigationBarHidden(false)) {
                    Text("Digital Menu")
                }
                
                CustomButton(action: {self.isShowingScannerSheet.toggle() })
                {
                    Text("Scan Menu")
                }.sheet(isPresented: self.$isShowingScannerSheet) { ScanView() }
                
            }
        }
    }
    
    //    private func makeScannerView() -> SignInView {
    //
    //        ScannerViewController(completion: { textPerPage in
    //            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
    //                self.text = text
    //            }
    //            self.isShowingScannerSheet = false
    //        })
    //
    //    }
}

//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            StartView(restChosen: RestaurantFB(name: "", description: <#T##String#>, averagePrice: <#T##Double#>, type: <#T##String#>, ethnicity: <#T##String#>, dishes: <#T##[DishFB]#>, coordinate: <#T##GeoPoint#>))
//        }
//
//    }
//}
