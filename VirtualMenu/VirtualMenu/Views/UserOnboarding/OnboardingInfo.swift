//
//  Onboarding-Info.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct OnboardingInfo: View {
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 0)

                    VStack{
                        Image("Onboarding-Info")
                            .position(x: UIScreen.main.bounds.width/2, y: 100)
    //                        .frame(width: UIScreen.main.bounds.width/1.3, height: 374)
                        
                        Text("Order food from local restaurants")
                            .foregroundColor(Color(UIColor().colorFromHex("#3A3A3A", 1)))
                            .font(.largeTitle).bold()
                            .font(.system(size: 36))
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .position(x: UIScreen.main.bounds.width/2, y: 110)

                            
                        
                        Text("Choose your food quickly and safely from the app")
                            .foregroundColor(Color(UIColor().colorFromHex("#3A3A3A", 1)))
                            .font(.system(size: 18))
                            .font(.subheadline)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .position(x: UIScreen.main.bounds.width/2, y: 30)

                    }
                    
//                    Spacer().frame(height: 80)
                    
                    //button
                    
                    
                
                    VStack(alignment: .leading){

                        NavigationLink(destination: OnboardingInfo2()){
                            OrangeButton(strLabel: "Get Started", width: 141, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        }
                    }
                    Spacer()
                    
                }

        }.background(Color(UIColor().colorFromHex("#F3F1EE", 1)))
        
    }.background(Color(UIColor().colorFromHex("#F3F1EE", 1)))
        
    }
}

struct OnboardingInfo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInfo()
    }
}
