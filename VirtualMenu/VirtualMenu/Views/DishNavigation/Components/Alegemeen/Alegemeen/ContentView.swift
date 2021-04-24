//
//  ContentView.swift
//  Alegemeen
//
//  Created by Rohan Tyagi on 3/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var scannerShow = false
    
    var body: some View {
        
        Text("Click this to turn scanner on")
//            .onTapGesture{
//                self.scannerShow = true
//            }
//            .sheet(isPresented: self.$scannerShow) {
//                Scanner(completion: { textPerPage in
//                    if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
//                        print("wow: \(text)")
//                    }
//                })
//                //dismiss once confirmation alert is sent
//            }
            
        
//        Text
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
