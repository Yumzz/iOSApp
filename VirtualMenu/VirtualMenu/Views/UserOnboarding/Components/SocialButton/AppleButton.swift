//
//  AppleButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import PassKit

struct AppleButton: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                Image("Apple")
                                
                Text("Continue with Apple")
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
            .frame(width: width, height: height)

           
        }
        .background((Color(UIColor().colorFromHex("#000000", 1))))
    }
}

struct ApplePayButton: View {

    let paymentHandler = PaymentHandler()
    var total: Float
    
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                Text("PAY WITH")
                    .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                Image("Apple")
                
                Text("APPLE")
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
            .frame(width: 330, height: 48)
            .onTapGesture(){
                self.paymentHandler.startPayment( completion: { (success) in
                    if success {
                        print("Success")
                    } else {
                        print("Failed")
                    }
                }, total: total, tax: total*0.1028)
            }

           
        }
        .background((Color(UIColor().colorFromHex("#000000", 1))))
    }

//    var body: some View {
//        Button(action: {
//            self.paymentHandler.startPayment( completion: { (success) in
//                    if success {
//                        print("Success")
//                    } else {
//                        print("Failed")
//                    }
//                }, total: total, tax: total*0.1028)
//            }, label: {
//                Text("PAY WITH  APPLE")
////                .font(Font.custom("HelveticaNeue-Bold", size: 16))
//                .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
////                .padding(10)
////                .foregroundColor(.white)
//        }).background((Color(UIColor().colorFromHex("#000000", 1))))
//            .frame(width: 330, height: 48)
//    }

}

