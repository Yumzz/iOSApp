//
//  RestaurantSearchbarView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 16/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantSearchbarView: View {
    
    @Binding var strSearch:String
    
    var body: some View {
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search restaurant", text: self.$strSearch)
                
            }.frame(minWidth: 0, maxWidth: .infinity)
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.primary)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10.0)
                .shadow(radius: 5)
    }
}

struct RestaurantSearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSearchbarView(strSearch: .constant(""))
    }
}
