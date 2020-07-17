//
//  SwiftUIView.swift
//  
//
//  Created by Valentin Porcellini on 16/07/2020.
//

import SwiftUI

struct restaurantSearchLabel: View {
    
    var restaurantName: String = "Restaurant"
    var restaurantAddress: String = "Address"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.restaurantName)
                .font(.headline)
            Text(self.restaurantAddress)
                .font(.caption)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        restaurantSearchLabel()
    }
}
