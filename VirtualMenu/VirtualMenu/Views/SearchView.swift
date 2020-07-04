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
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search restaurant", text: self.$strSearch)
                
            }.frame(width: geometry.size.width - 100)
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10.0)
                .shadow(radius: 5)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
