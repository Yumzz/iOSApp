//
//  ContentView.swift
//  Scanner
//
//  Created by Rohan Tyagi on 5/31/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import Vision
import VisionKit
import SwiftUI

struct ContentView: View {
    private let buttonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
     
    var body: some View {
        VStack(spacing: 32) {
            Text("Vision Kit Example")
            Button(action: openCamera) {
                Text("Scan").foregroundColor(.white)
            }.padding(buttonInsets)
                .background(Color.blue)
                .cornerRadius(3.0)
            Text(text).lineLimit(nil)
        }.sheet(isPresented: self.$isShowingScannerSheet) { self.makeScannerView() }
    }
     
    @State private var isShowingScannerSheet = false
    @State private var text: String = ""
     
    private func openCamera() {
        isShowingScannerSheet = true
    }
     
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                self.text = text
            }
            self.isShowingScannerSheet = false
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
