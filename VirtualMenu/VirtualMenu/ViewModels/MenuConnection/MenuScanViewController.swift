//
//  MenuScanViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 1/13/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import UIKit
import Instructions

class MenuScanViewController: UIViewController, CoachMarksControllerDelegate, CoachMarksControllerDataSource  {
    //need to make this connect to printer and send dishes to printer to print

    
//    var num: String = ""
    
//    @IBOutlet private weak var button: CircularButton!
//    @IBOutlet private weak var statusLabel: UILabel!
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let coachMarksController = CoachMarksController()
    
//    var rest: RestaurantFB = RestaurantFB.previewRest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
        print("view model call waiter")
        
//                        self.loadingPrinterConnection = false
        
        //need to output text saying wrong qr code if callwait or print info
//        self.reloadReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let host = UIHostingController(rootView: MenuConnectionUI())
        guard let hostView = host.view else {return}
        hostView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostView)
        hostView.center = self.view.center
        self.coachMarksController.start(in: .window(over: self))
    }
    
//    func reloadReady(){
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ReloadMenuScan"), object: nil, queue: .main) { [self] (Notification) in
//            print("just reloadingview")
////            self.viewDidLoad()
//            self.presentationMode.wrappedValue.dismiss()
////            self
//        }
//    }
    

    
    func getQueryStringParameter(url: String, param: String, d: DispatchGroup) -> String? {
      print("url: \(url)")
        var x = ""
//        guard let url = URLComponents(string: url) else { x = ""; return}
        print("url pre: \(url)")

        guard let url = URL(string: url) else { return ""}
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
//
        d.leave()
        return components.queryItems?.first(where: { $0.name == param })?.value!
        
    }

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    let pointOfInterest = UIView()
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        pointOfInterest.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        return coachMarksController.helper.makeCoachMark(for: pointOfInterest)
    }
    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: .top
        )

        coachViews.bodyView.hintLabel.text = "Scan the qr code with blue border!"
//        coachViews.bodyView.nextLabel.text = "Order will be sent!"

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
}

struct MenuConnection: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: MenuScanViewController, context: UIViewControllerRepresentableContext<MenuConnection>) {
        print("wow")
    }
    
//    var num: Int
//    @EnvironmentObject var order : OrderModel
    //add paramter of dishes and pass it through to viewcontroller to send as a message to printer to print
    typealias UIViewControllerType = MenuScanViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<MenuConnection>) -> MenuScanViewController {
//            code
        let connection = MenuScanViewController()
//        connection.num = num
        return connection
        }

}

struct MenuConnectionUI: View {
    @State var wrongQRCode: Bool = false
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
            ZStack{
                QRScanView(completion: { textPerPage in
                    print("ask: \(textPerPage)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PrintInfo"), object: textPerPage)
                    if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PrintInfo"), object: text)
                    }
                }, choice: 0)
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
//                VStack{
//                    Text("Calling Waiter")
//                    Spacer().frame(width: UIScreen.main.bounds.width, height: 50)
//                    Loader(animate: connecting)
//                }
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            .onAppear(){
//                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ReloadMenuScan"), object: nil, queue: .main) { [self] (Notification) in
//                    print("just removingview")
//                    self.presentationMode.wrappedValue.dismiss()
////                    print("just reloadingview")
//                }
//            }

    }
}
