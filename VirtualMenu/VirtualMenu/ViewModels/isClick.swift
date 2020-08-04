//
//  isClick.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/3/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class isClick: ObservableObject {
    
    @Published var isClicked: Bool
    @Published var restChosen: RestaurantFB?
    @Published var numClicks: Int
    

    init(){
        print("click made")
        self.numClicks = 0
        self.isClicked = false
        self.restChosen = nil
        NotificationCenter.default.addObserver(self, selector: #selector(self.restClicked(_:)), name: Notification.Name(rawValue: "annotationPressed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.restUnclicked(_:)), name: Notification.Name(rawValue: "XPressed"), object: nil)
    }

    @objc private func restClicked(_ notification: NSNotification){
            print(notification.userInfo ?? "damn")
            print("click switch called")
            self.restChosen = (notification.userInfo!["Restaurant"] as? RestaurantFB)!
            self.isClicked = true
            self.numClicks = self.numClicks + 1
            print(isClicked)
    }
//    func changeClick(isClick: Bool, rest: RestaurantFB){
//        self.restChosen = rest
//        self.isClicked.toggle()
//        print(self.restChosen)
//        print(isClicked)
//    }

    @objc private func restUnclicked(_ notification: NSNotification){
        self.isClicked = false
    }
}
