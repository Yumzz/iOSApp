//
//  BannerModifier.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/17/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct BannerModifier: ViewModifier {
    
    @Binding var data: BannerData
    @Binding var show:Bool
    
    struct BannerData {
        var title:String
        var detail:String
    }

    func body(content: Content) -> some View {
        ZStack {
            if show{
                content.overlay(VStack {
                    // Banner Content Here
                    HStack {
                        VStack(alignment: .center, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }.foregroundColor(Color.white)
                    .padding(12)
                    .background(ColorManager.yumzzOrange)
                    .cornerRadius(8)
                    Spacer()
                }.padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            self.show = false
                        }
                    }
                }))
            }
            else{
                content
            }
            
//                .if()
        }
    }
    
    
}

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
