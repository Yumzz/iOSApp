//
//  FavoriteView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        ZStack{
            VStack{
                Text("My favorites")
            }
        }.background(GradientView().edgesIgnoringSafeArea(.top))

    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
