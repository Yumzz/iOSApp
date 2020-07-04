//
//  SearchView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State var strSearch: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                VStack(){
                    
                    Text("Support local restaurants")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .padding(.top, 100)
                        .padding(.bottom, 25)
                        .frame(width: geometry.size.width, alignment: .leading)
                        .background(Color(red: 1.0, green: 0.48, blue: 0.45, opacity: 1.0))
                    
                    Spacer()
                        .frame(height: 50)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search restaurant", text: self.$strSearch)
                        
                    }.frame(width: geometry.size.width - 100)
                        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .foregroundColor(.primary)
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(10.0)
                        .shadow(radius: 5)
                    
                    VStack(){
                        Text("Already arrived?")
                        Spacer().frame(height: 0)
                        Button(action: {
                            
                        }, label: {
                            Text("Scan a QRCode")
                        })
                    }.padding(.top, 20)
                        .frame(width: geometry.size.width - 100, alignment: .leading)
                    
                    Spacer()
                }
            }
        }.navigationBarTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
