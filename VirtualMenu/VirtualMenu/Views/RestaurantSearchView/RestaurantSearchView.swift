//
//  RestaurantSearchView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 16/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantSearchView: View {
    
    @Binding var searchActive: Bool
    @Binding var strSearch: String
    
    var body: some View {
        VStack{
            HStack(spacing: 16) {
                RestaurantSearchbarView(strSearch: self.$strSearch)
                Button(action: {
                    self.strSearch = ""
                    self.searchActive.toggle()
                    
                }){
                    Text("Cancel")
                }
            }
            
                .padding()
//            RestaurantSearchListView()
        }
    }
}

struct RestaurantSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSearchView(searchActive: .constant(true), strSearch: .constant(""))
    }
}
