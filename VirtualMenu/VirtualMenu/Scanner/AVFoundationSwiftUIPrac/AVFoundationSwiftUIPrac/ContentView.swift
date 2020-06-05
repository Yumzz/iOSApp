//
//  ContentView.swift
//  AVFoundationSwiftUIPrac
//
//  Created by Rohan Tyagi on 5/31/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI


struct ContentView: View {
       var body: some View {
          CameraViewController()
             .edgesIgnoringSafeArea(.top)
       }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
