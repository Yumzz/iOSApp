//
//  StartView.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 6/15/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct StartView: View {
    @State var id:String = ""
    
    var body: some View {
        if(id == ""){
        QRScanView(completion: { textPerPage in
            print(textPerPage)
            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                print(text)
            }
        }).onAppear(){
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "RestId"), object: nil, queue: .main) { (tt) in
                self.id = tt.object as! String
            }
        }
        }
        else{
            ContentView(id: self.id)
        }
        
    }
    
}
