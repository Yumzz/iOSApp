//
// ClientViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/11/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import UIKit
import MQTTClient
import Instructions

// This MQTT client lib is a bit confusing in terms of what callbacks etc to use. The best example I found that works is here:
// https://github.com/novastone-media/MQTT-Client-Framework/blob/master/MQTTSwift/MQTTSwift/MQTTSwift.swift
//class CircularButton: UIButton {
//
//    override var isSelected: Bool {
//        didSet {
//            self.backgroundColor = isSelected ? .blue : .clear
//        }
//    }
//
//    override func awakeFromNib() {
//        self.layer.cornerRadius = self.bounds.width * 0.5
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.blue.cgColor
//    }
//}

class WaiterViewController: UIViewController, CoachMarksControllerDelegate, CoachMarksControllerDataSource  {
    //need to make this connect to printer and send dishes to printer to print

    let MQTT_HOST = "broker.emqx.io" // or IP address e.g. "192.168.0.194"
    let MQTT_PORT: UInt32 = 1883
    
    var num: String = ""
    var wrongQRCode: Bool = false
    
//    @IBOutlet private weak var button: CircularButton!
//    @IBOutlet private weak var statusLabel: UILabel!
    
    private var transport = MQTTCFSocketTransport()
    fileprivate var session = MQTTSession()
    fileprivate var completion: (()->())?
    let coachMarksController = CoachMarksController()
    
    var rest: RestaurantFB = RestaurantFB.previewRest()
    
    var loadingPrinterConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session?.delegate = self
        self.transport.host = MQTT_HOST
        self.transport.port = MQTT_PORT
        session?.transport = transport
        self.coachMarksController.dataSource = self
        print("view model call waiter")
        
        
        //need to output text saying wrong qr code if printinfo or choose rest
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CallWait"), object: nil, queue: .main) { [self] (Notification) in
//                        self.pastOrders = Notification.object as! [Order]
            var text = Notification.object as! String
            //parse out table num
            let d = DispatchGroup()
            d.enter()
            var topic = self.rest.name.lowercased()
            if(topic.lowercased().contains("vics")){
                topic = "vics"
            }
            self.num = getQueryStringParameter(url: text, param: "table", d: d)!
            d.notify(queue: .main){
                print("yaaa: \(self.num)")
                //vics => topic
                print("publishtopic: raspberry/" + "vics" + "-callwaiter")
                self.publishMessage("\(self.num)", onTopic: "raspberry/" + "vics" + "-callwaiter")
            }
//                        self.loadingPrinterConnection = false
        }
//                        self.loadingPrinterConnection = false
        
        updateUI(for: self.session?.status ?? .created)
        session?.connect() { error in
            print("connection completed with status \(String(describing: error))")
            if error != nil {
                
                self.updateUI(for: self.session?.status ?? .created)
            } else {
                self.updateUI(for: self.session?.status ?? .error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.coachMarksController.start(in: .window(over: self))
    }
    
    private func updateUI(for clientStatus: MQTTSessionStatus) {
//        let view = UIHostingController(rootView: <#T##_#>)
        DispatchQueue.main.async {
            switch clientStatus {
            //have to switch between callwaiter and printer
                case .connected:
                    self.subscribe()
                    //topic needs to be dynamic for each printer - topic = raspberry/{name of rest}
                    print("ask about table num")
//                    let dispatch = DispatchGroup()
//                    dispatch.enter()
//                    self.alertAboutTable(d: dispatch)
                    print("done asking about table num")
//                    dispatch.notify(queue: .main){
//                        print("okkk \(self.num)")
//                        self.publishMessage("\(self.num)", onTopic: "raspberry/vics-callwaiter")
//                        self.loadingPrinterConnection = false
//                    }
            //need to dismiss the review order view as well and
//                    self.statusLabel.text = "Connected"
//                    self.button.isEnabled = true
                case .connecting,
                     .created:
                    let host = UIHostingController(rootView: WaiterConnectionUI())
                    guard let hostView = host.view else {return}
                    hostView.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(hostView)
                    hostView.center = self.view.center
//                    hostView.centerYAnchor
                    
                    self.loadingPrinterConnection = true
                    print("trying to connect")
//                    self.statusLabel.text = "Trying to connect..."
//                    self.button.isEnabled = false
                default:
                    print("connection failed")
//                    self.statusLabel.text = "Connection Failed"
//                    self.button.isSelected = false
//                    self.button.isEnabled = false
            }
        }
    }
    
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
//    func alertAboutTable(d: DispatchGroup) {
//        //Step : 1
//        let alert = UIAlertController(title: "Table number needed", message: "Please Input table number above QR code on table", preferredStyle: UIAlertController.Style.alert )
//        //Step : 2
//        let save = UIAlertAction(title: "Call Waiter", style: .default) { (alertAction) in
//                let textField = alert.textFields![0] as UITextField
//
//            if textField.text != "" {
//                        //Read TextFields text data
//                print(textField.text!)
//                print("Table number : \(textField.text!)")
//                var txt = textField.text!
////                if txt.isNumber {
////                    self.num = String(txt)
////                }
//                self.num = txt
//                d.leave()
//            } else {
//                print("TF 1 is Empty...")
//            }
//
//        }
//
//        alert.addTextField { (textField) in
//                textField.placeholder = "Enter your table number"
//                textField.textColor = .red
//            }
//
//        alert.addAction(save)
//            //Cancel action
//        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
//        alert.addAction(cancel)
//
//        self.present(alert, animated:true, completion: nil)
//
//    }

    private func subscribe() {
//        let topic =
        var topic = self.rest.name.lowercased()
        if(topic.lowercased().contains("vics")){
            print("in vics")
            topic = "vics"
        }
        print("topic \(topic)")
        //vics => topics
        print("subscribetopic: raspberry/" + "vics" + "-callwaiter")
        self.session?.subscribe(toTopic: "raspberry/" + "vics" + "-callwaiter", at: .exactlyOnce) { error, result in
            print("subscribe result error \(String(describing: error)) result \(result!)")
            //need to run connection to POS on raspberry pi as a python script
        }
        print("port: \(self.session?.port)")
    }
    
    private func publishMessage(_ message: String, onTopic topic: String) {
        print("publishing message after asking about table \(self.num)")
        session?.publishData(message.data(using: .utf8, allowLossyConversion: false), onTopic: topic, retain: false, qos: .exactlyOnce)
        
        print("published message after asking about table")
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

        coachViews.bodyView.hintLabel.text = "Scan the qr code with red border!"
//        coachViews.bodyView.nextLabel.text = "Order will be sent!"

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
}

extension WaiterViewController: MQTTSessionManagerDelegate, MQTTSessionDelegate {

    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        if let msg = String(data: data, encoding: .utf8) {
            print("topic \(topic!), msg \(msg)")
        }
    }

    func messageDelivered(_ session: MQTTSession, msgID msgId: UInt16) {
        print("delivered")
        DispatchQueue.main.async {
            self.completion?()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WaiterCalled"), object: nil)
            self.dismiss(animated: true)
        }
    }
    
}

struct WaiterConnection: UIViewControllerRepresentable {
    var rest: RestaurantFB
    func updateUIViewController(_ uiViewController: WaiterViewController, context: UIViewControllerRepresentableContext<WaiterConnection>) {
        print("wow")
    }
    
//    var num: Int
//    @EnvironmentObject var order : OrderModel
    //add paramter of dishes and pass it through to viewcontroller to send as a message to printer to print
    typealias UIViewControllerType = WaiterViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<WaiterConnection>) -> WaiterViewController {
//            code
        let connection = WaiterViewController()
        connection.rest = rest
//        connection.num = num
        return connection
        }

}

struct WaiterConnectionUI: View {
    @State var wrongQRCode: Bool = false
    
    var body: some View {
            ZStack{
                QRScanView(completion: { textPerPage in
                    print("ask: \(textPerPage)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CallWait"), object: textPerPage)
                    if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CallWait"), object: text)
                    }
                }, choice: 1)
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
//                VStack{
//                    Text("Calling Waiter")
//                    Spacer().frame(width: UIScreen.main.bounds.width, height: 50)
//                    Loader(animate: connecting)
//                }
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            .onAppear(){
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PrintInfoWrong"), object: nil, queue: .main) { [self] (Notification) in
                    self.wrongQRCode = true
                }
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ChooseRestWrong"), object: nil, queue: .main) { [self] (Notification) in
                        self.wrongQRCode = true
                }
            }
            .alert(isPresented: self.$wrongQRCode){
                return Alert(title: Text("Wrong QR Code! Please drag down this view, reclick the qr scanner, and scan the QR Code with the red border!"))
                self.wrongQRCode = false
//                        print("just displayed alert and about to ask to reload")
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMenuScan"), object: nil)
//                        self.view.
            }
    }
    
}

//struct Loader: View {
//
//    @State var animate = false
//    var body: some View {
//
//        VStack{
//            Circle()
//                .trim(from: 0, to: 0.8)
//                .stroke(AngularGradient(gradient: .init(colors: [Color(UIColor().colorFromHex("#F88379", 1)), Color(UIColor().colorFromHex("#FFFFFF", 1))]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
//                .frame(width: 45, height: 45)
//                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
//                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
//
//            Text("Please Wait...").padding(.top)
//
//        }
//        .background(Color.white)
//        .cornerRadius(15)
//
//        .onAppear {
//            self.animate.toggle()
//        }
//
//    }
//}
