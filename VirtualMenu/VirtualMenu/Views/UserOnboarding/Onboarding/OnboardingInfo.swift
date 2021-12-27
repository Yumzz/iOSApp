//
//  Onboarding-Info.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.slide
    }
}

struct OnboardingInfo: View {
//    @State var isNavigationBarHidden: Bool = true
    @Environment (\.colorScheme) var colorScheme : ColorScheme

    var body: some View {
        ZStack{
            NavigationView{
                ZStack{
                    Color(colorScheme == .dark ? ColorManager.darkBack : #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
//                    Color(colorScheme == .dark ? Color("black") as! CGColor : Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)) as! CGColor).edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 0)

                    VStack{
                        Image("Onboarding-Info")
                            .position(x: UIScreen.main.bounds.width/2, y: 100)
    //                        .frame(width: UIScreen.main.bounds.width/1.3, height: 374)
                        
                        Text("Order food from local restaurants")
                            .foregroundColor(colorScheme == .dark ? ColorManager.white : ColorManager.black)
                            .font(.largeTitle).bold()
                            .font(.system(size: 36))
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .position(x: UIScreen.main.bounds.width/2, y: 110)

                            
                        
                        Text("Choose your food quickly and call your waiter safely from the app!")
                            .foregroundColor(colorScheme == .dark ? ColorManager.white : ColorManager.black)
                            .font(.system(size: 18))
                            .font(.subheadline)
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                            .position(x: UIScreen.main.bounds.width/2, y: 30)

                    }
                    
                    VStack(alignment: .leading){

                        NavigationLink(destination: OnboardingInfo2()){
                            OrangeButton(strLabel: "Get Started", width: 141, height: 48, dark: colorScheme == .dark)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        }
                    }
                    Spacer()
                    
                }
            }
                

        }.navigationBarTitle("")
        .navigationBarHidden(true)
//            .onAppear(){
//                self.isNavigationBarHidden = true
//            }
//            .onDisappear(){
//                self.isNavigationBarHidden = false
//
//            }
    }
        
    }
}

struct OnboardingInfo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInfo()
    }
}
