//
//  BuildFB.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase

struct BuildFB {
    let name: String
    let description: String
    let rest: String
    let addOns: [String:[String]]
    let exclusiveOpts: [String:[String]]
    let priceOpts: [String:[String]]
    var id: UUID

    init(name: String, description: String, rest: String, addOns: [String:[String]], exclusiveOpts: [String:[String]], priceOpts:[String:[String]]) {
        self.name = name
        self.description = description
        self.rest = rest
        self.addOns = addOns
        self.exclusiveOpts = exclusiveOpts
        self.priceOpts = priceOpts
        self.id = UUID()

    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no build name:\(snapshot.data())")
                return nil
        }
        guard
            let description = snapshot.data()["Description"] as? String else {
                print("no build description:\(snapshot.data())")
                return nil
        }
        guard
            let rest = snapshot.data()["Restaurant"] as? String else {
                print("no build description:\(snapshot.data())")
                return nil
        }
        guard
            let exclusiveopts = snapshot.data()["Exclusive-Opts"] as? [String:[String]] else {
                print("no excl opts:\(snapshot.data())")
                return nil
        }
        guard
            let priceopts = snapshot.data()["PriceOpts"] as? [String:[String]] else {
                print("no price opts:\(snapshot.data())")
                return nil
        }
        guard
            let sizeprice = snapshot.data()["SizePrice"] as? [String:[String]] else {
                print("no size price:\(snapshot.data())")
                return nil
        }
        guard
            let addons = snapshot.data()["Add-Ons"] as? [String:[String]] else {
                print("no size price:\(snapshot.data())")
                return nil
        }
        self.name = name
        self.description = description
        self.rest = rest
        self.addOns = addons
        self.exclusiveOpts = exclusiveopts
        self.priceOpts = priceopts
        self.id = UUID()
        
    }
    
    init?(snapshot: DocumentSnapshot) {
        
        guard
            let name = snapshot.data()?["Name"] as? String else {
                print("no dish name: \(snapshot.data())")
                return nil
        }
        guard
            let description = snapshot.data()?["Description"] as? String else {
                print("no build description:\(snapshot.data())")
                return nil
        }
        guard
            let rest = snapshot.data()?["Restaurant"] as? String else {
                print("no build description:\(snapshot.data())")
                return nil
        }
        guard
            let exclusiveopts = snapshot.data()?["Exclusive-Opts"] as? [String:[String]] else {
                print("no excl opts:\(snapshot.data())")
                return nil
        }
        guard
            let priceopts = snapshot.data()?["PriceOpts"] as? [String:[String]] else {
                print("no price opts:\(snapshot.data())")
                return nil
        }
        guard
            let sizeprice = snapshot.data()?["SizePrice"] as? [String:[String]] else {
                print("no size price:\(snapshot.data())")
                return nil
        }
        guard
            let addons = snapshot.data()?["Add-Ons"] as? [String:[String]] else {
                print("no size price:\(snapshot.data())")
                return nil
        }
        
        self.name = name
        self.description = description
        self.rest = rest
        self.addOns = addons
        self.exclusiveOpts = exclusiveopts
        self.priceOpts = priceopts
        self.id = UUID()

    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
}
extension BuildFB: Hashable {
    static func == (lhs: BuildFB, rhs: BuildFB) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func previewBuild() -> BuildFB {
        return BuildFB(name: "", description: "", rest: "", addOns: ["":[""]], exclusiveOpts: ["":[""]], priceOpts: ["":[""]])
    }
}
