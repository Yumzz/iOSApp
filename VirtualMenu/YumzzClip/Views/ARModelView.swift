//
//  ARModelView.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 7/8/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct ARModelView: View {
    @State var dish: DishFB? = nil
    @State var finished: String = ""
    @State private var questionsShow = false
    @State private var arShow = true
//    @ObservedObject var ARVM: ARModelViewModel
    let dispatchGroup = DispatchGroup()
    
    init(id: String, dishname: String, restname: String){
//        ARVM = ARModelViewModel(dis: dispatchGroup, dishname: dishname, restname: restname, id: id)
//        self.finished = "done"
    }
    
    var body: some View{
        ZStack{
//            if(finished == ""){
//                Text("Loading...")
//                    .onAppear(){
//                        print("yes: \(finished)")
//                    }
//            }
//            else{
//            if(self.questionsShow){
//                SurveyView(survey: SampleSurvey).preferredColorScheme(.light)
//            }
//            if(self.arShow){
//            DishAdminView()
            UIARView()
//            NavigationLink(destination:
//                            SurveyView(survey: SampleSurvey).onDisappear(){
//                self.questionsShow = false
//            },
//               isActive: self.$questionsShow) {
//                 EmptyView()
//            }.hidden()
//                .onAppear(){
//                    print("yea")
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(30)) {
//                        print("show survey")
//                        self.questionsShow = true
//                        self.arShow = false
//                        // set your var here
//                    }
//                }
//                    .opacity(arShow ? 0 : 1)
//            }
//            }
        }
        .onAppear(){
//            print("yea")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(30)) {
                print("show survey")
                self.questionsShow = true
//                self.arShow = false
                // set your var here
            }
        }
//        .popover(isPresented: self.$questionsShow){
//            SurveyView(survey: SampleSurvey).preferredColorScheme(.light)
//                .onAppear(){
//                    print("survey view")
//                }
//        }
//        .pop
        
    }
    
    
    
}
