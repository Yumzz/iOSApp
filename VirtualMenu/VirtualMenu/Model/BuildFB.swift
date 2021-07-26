//
//  BuildFB.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 11/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
#if !APPCLIP
import FirebaseFirestore
import Firebase
import FirebaseDatabase
#endif
//when individCost == true, only individual costs add to price and there is only individual costs
struct BuildFB {
    let name: String
    let description: String
    let rest: String
    let addOns: [String:[String]]
    var exclusiveOpts: [String:[String]] = ["":[]]
    var priceOpts: [String:[String: NSArray]] = [String:[String: NSArray]]()
    var id: UUID
    var typePrice: [String] = []
    var typeOpt: [String] = []
    var sizePrice: [String: [String]] = ["": []]
    var individCost: Bool = false
    var individualCosts: [String:[String]] = ["":[]]
    
    
    #if !APPCLIP
    init(name: String, description: String, rest: String, addOns: [String:[String]], exclusiveOpts: [String:[String]], priceOpts:[String:[String: NSArray]], sizePrice: [String: [String]], individualCost: Bool, individCosts: [String:[String]]) {
        self.name = name
        self.description = description
        self.rest = rest
        self.addOns = addOns
        self.exclusiveOpts = exclusiveOpts
        self.priceOpts = priceOpts
        self.id = UUID()
        self.sizePrice = sizePrice
        self.individCost = individualCost
        self.individualCosts = individCosts
        for x in addOns.keys {
            if(!self.typeOpt.contains(x)){
                self.typeOpt.append(x)
            }
        }
        for y in priceOpts.values {
            for ya in y.keys {
                if(!self.typePrice.contains(ya)){
                    self.typePrice.append(ya)
                }
                
            }
        }
        
        
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        let individCost = snapshot.data()["individualCost"] as? Bool
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
        if !individCost! {
            guard
                let exclusiveopts = snapshot.data()["Exclusive-Opts"] as? [String:[String]] else {
                    print("no excl opts:\(snapshot.data())")
                    return nil
            }
            guard
                let priceopts = snapshot.data()["PriceOpts"] as? [String:[String:NSArray]] else {
                print("no price opts1:\(snapshot.data())")
                    return nil
            }
            guard
                let sizeprice = snapshot.data()["SizePrice"] as? [String:[String]] else {
                    print("no size price:\(snapshot.data())")
                    return nil
            }
            self.priceOpts = priceopts
            self.sizePrice = sizeprice
            self.exclusiveOpts = exclusiveopts
            print("keys: \(priceopts.keys)")
            print("priceopt: \(priceopts.values)")
            for y in priceOpts.values {
                for ya in y.keys {
                    if(!self.typePrice.contains(ya)){
                        self.typePrice.append(ya)
                    }
                }
            }
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
        self.id = UUID()

        self.individCost = individCost!

//        self.priceOpts = self.extractPrices(opts: priceopts)
        for x in addOns.keys {
            if(!self.typeOpt.contains(x)){
                self.typeOpt.append(x)
            }
        }
        if self.individCost {
            self.individualCosts = (snapshot.data()["individCosts"] as? [String:[String]])!
            
        }
        
        
    }
    
    init?(snapshot: DocumentSnapshot) {
        let individCost = snapshot.data()!["individualCost"] as? Bool

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
        if !individCost! {
            guard
                let exclusiveopts = snapshot.data()?["Exclusive-Opts"] as? [String:[String]] else {
                    print("no excl opts:\(snapshot.data())")
                    return nil
            }
            guard
                let priceopts = snapshot.data()?["PriceOpts"] as? [String:[String: NSArray]] else {
                    print("no price opts2:\(snapshot.data())")
                    return nil
            }
            guard
                let sizeprice = snapshot.data()?["SizePrice"] as? [String:[String]] else {
                    print("no size price:\(snapshot.data())")
                    return nil
            }
            self.priceOpts = priceopts
            self.sizePrice = sizeprice
            self.exclusiveOpts = exclusiveopts
            for y in priceOpts.values {
                for ya in y.keys {
                    if(!self.typePrice.contains(ya)){
                        self.typePrice.append(ya)
                    }
                }
            }
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
        self.id = UUID()

        self.individCost = individCost!
//        self.priceOpts = self.extractPrices(opts: priceopts)
        for x in addOns.keys {
            if(!self.typeOpt.contains(x)){
                self.typeOpt.append(x)
            }
        }
        self.individualCosts = ["":[]]
        if self.individCost {
            self.individualCosts = (snapshot.data()!["individCosts"] as? [String:[String]])!
        }

    }
    #else
    init?(json: [String:Any?]){
        
        
        guard
            let name = json["Name"] as? String, let description = json["Description"] as? String, let rest = json["Restaurant"] as? String, let addons = json["Add-Ons"] as? [String:[String]], let individCost = json["individualCost"] as? Bool
        else{
            print("initialization failed")
            return nil
        }
        print("individualToppings: \(individCost)")
        if !individCost{
            guard let exclusiveopts = json["Exclusive-Opts"] as? [String:[String]], let priceopts = json["PriceOpts"] as? [String:[String: NSArray]], let sizeprice = json["SizePrice"] as? [String:[String]]
            else{
                print("initialization failed")
                return nil
            }
            self.priceOpts = priceopts
            self.sizePrice = sizeprice
            self.exclusiveOpts = exclusiveopts
            for y in priceOpts.values {
                for ya in y.keys {
                    if(!self.typePrice.contains(ya)){
                        self.typePrice.append(ya)
                    }
                }
            }

        }
        
//        let exclusiveopts = json["Exclusive-Opts"] as? [String:[String]], let priceopts = json["PriceOpts"] as? [String:[String: NSArray]], let sizeprice = json["SizePrice"] as? [String:[String]]
        self.name = name
        self.description = description
        self.rest = rest
        self.addOns = addons
        self.id = UUID()
        self.individCost = individCost
//        self.priceOpts = self.extractPrices(opts: priceopts)
        for x in addOns.keys {
            if(!self.typeOpt.contains(x)){
                self.typeOpt.append(x)
            }
        }
        self.individualCosts = ["":[]]
        if self.individCost {
            let individCosts = json["individCosts"] as! [String:[String]]
            self.individualCosts = individCosts
            print(self.individualCosts)
        }
    }
    
    #endif

    
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
        #if !APPCLIP
        return BuildFB(name: "", description: "", rest: "", addOns: ["":[""]], exclusiveOpts: ["":[""]], priceOpts: ["":["":[]]], sizePrice: ["":[""]], individualCost: false, individCosts: ["":[]])
        #else
        return BuildFB(json: ["Name": "", "Description": "", "Restaurant": "", "Add-Ons": [], "Exclusive-Opts" : [], "PriceOpts": [], "SizePrice": [], "individualCost": false])!
        #endif
    }
    
//    func extractPrices(opts: [String:[String: NSArray]]) -> [String:[String: [Float]]]{
//        var result: [String:[String: [Float]]] = [String:[String: [Float]]]()
//        for k in opts.keys {
//            for ka in opts[k]!{
//                let v = ka.value
//                var b : [String: [Float]] = [String: [Float]]()
//                var fl : [Float] = [Float]()
//                for val in v {
//                    fl.append(Float(val))
//                }
//                b[ka.key] = Float(ka.value)
//                result[k] = b
//            }
//        }
//        print("result: \(result)")
//        return result
//    }
}
