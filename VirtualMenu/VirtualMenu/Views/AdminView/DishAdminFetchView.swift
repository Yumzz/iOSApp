//
//  DishAdminFetchView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/18/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase
import SwiftUI

struct DishAdminFetchView: View {
    @State var text: String = ""
    let firestore = Firestore.firestore()
    
    var body: some View{
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack{
                VStack{
                    Text("Let's get that data")
                        .foregroundColor(ColorManager.textGray)
                        .font(.largeTitle).bold()
                        .font(.system(size: 36))
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .position(x: UIScreen.main.bounds.width/2, y: 110)
                }
                
                VStack{
                    Button(action: {
                       //go through dish collection and get all description data and name of dish -> text
                        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = URL(fileURLWithPath: "dishData", relativeTo: directoryURL).appendingPathExtension("txt")
                        
                        firestore.collection("Dish").getDocuments { (snap, err) in
                            if let err = err {
                                print("Error loading documents: \(err)")
                            }
                            else{
                                for s in snap!.documents {
                                    if((s.get("Description") as! String) != ""){
                                        //need to get dish's rest ethnicity
                                        
                                        DispatchQueue.main.sync {
                                            self.getEth(s: s)
                                            text = text + "Name: \(s.get("Name") as! String), Description: \(s.get("Description") as! String);"
                                        }
                                    }
                                    if s == snap!.documents.last{
                                        guard let data = text.data(using: .utf8) else {
                                            print("Unable to convert string to data")
                                            return
                                        }
                                        // Save the data
                                        do {
                                         try data.write(to: fileURL)
                                         print("File saved: \(fileURL.absoluteURL)")
                                        } catch {
                                         // Catch any errors
                                         print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    }){
                        Text("Fetch Data")
                    }
                }
                
            }
        }
    }
    
    func getEth(s: QueryDocumentSnapshot){
        let restRef = firestore.collection("Restaurant").document("\(s.get("RestaurantID"))")
        restRef.getDocument { (sn, e) in
            if let e = e {
                print("Error loading documents: \(e)")
            }
            else{
                text = text + "Ethnicity: \(sn!.get("Ethnicity"))"
            }
        }
    }
    
    
    
}
