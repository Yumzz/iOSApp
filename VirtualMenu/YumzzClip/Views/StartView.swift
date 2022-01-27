//
//  SceneDelegate.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 12/21/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct StartView: View {
    @State var id:String = ""
    
    var body: some View {
        ZStack{
            if(id == ""){
                QRScanView(completion: { textPerPage in
                    print(textPerPage)
                }, choice: 0)
                    .onAppear(){
                    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "RestId"), object: nil, queue: .main) { (tt) in
                        let i = tt.object as! String
                        guard let url = URL(string: i) else {return}
                        var components = URLComponents(
                            url: url,
                            resolvingAgainstBaseURL: false
                        )!
                        print("wow: \(url.absoluteString)")
                        self.id = (components.queryItems?.first(where: { $0.name == "restaurant" })?.value!)!
                        print("id-2: \(self.id)")
                    }
                }
            }
            else{
                ContentView(id: self.id)
            }
        }
//        .onAppear(){
//            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "RestId"), object: nil, queue: .main) { (tt) in
//                let i = tt.object as! String
//                guard let url = URL(string: i) else {return}
//                var components = URLComponents(
//                    url: url,
//                    resolvingAgainstBaseURL: false
//                )!
//                print("wow: \(url.absoluteString)")
//                self.id = (components.queryItems?.first(where: { $0.name == "restaurant" })?.value!)!
//                print("id-3: \(self.id)")
//            }
//        }
        
    }
    
}
