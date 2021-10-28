//
//  PastOrders.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import Foundation
import Combine

struct PastOrders: View {
    
    @ObservedObject var pastOrdersVM: PastOrdersViewModel
    
    @State var pastOrders: [Order] = []
    
    let dispatchGroup = DispatchGroup()
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var order : OrderModel

    @State var isNavBarHidden = false
    @GestureState private var dragOffset = CGSize.zero


    
    init() {
        
        print("Past Orders Vm created")
        
        self.dispatchGroup.enter()
        
        self.pastOrdersVM = PastOrdersViewModel(dispatch: self.dispatchGroup)
        
    }



    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            if !self.pastOrders.isEmpty {
                ScrollView(.vertical) {
                    ForEach(self.pastOrders, id: \.self){ pOrder in
                        OrderCard(order: pOrder)
                        
                        Spacer().frame(height: 20)
                    }
                    
                }
            }
            else{
                Text("No past orders... go make one!")
            }
            
        }.onAppear{
//            print("past orders: \(self.pastOrders)")
            self.isNavBarHidden = false
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PastOrders"), object: nil, queue: .main) { (Notification) in
                self.pastOrders = Notification.object as! [Order]
            }
//            self.dispatchGroup.notify(queue: .main){
////                print("past orders: \(self.pastOrders)")
////                print("yaaaaa")
//                self.pastOrders = self.pastOrdersVM.pastOrders
//                
//            }
        }
        .navigationBarTitle("Past Orders")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(self.isNavBarHidden)
        .navigationBarItems(leading: BackButton(mode: self.mode))
        .onDisappear(){
            self.isNavBarHidden = true
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
            
    }


}

