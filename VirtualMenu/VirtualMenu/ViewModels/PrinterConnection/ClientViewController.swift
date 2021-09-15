//
// ClientViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/28/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import UIKit
import MQTTClient

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

class ClientViewController: UIViewController {
    //need to make this connect to printer and send dishes to printer to print

    let MQTT_HOST = "broker.emqx.io" // or IP address e.g. "192.168.0.194"
    let MQTT_PORT: UInt32 = 1883
    
    var dishes: [DishFB] = []
    var dishInfo: [(String, Double, Int)] = []
    var tableNum: String = ""
    var rest: RestaurantFB = RestaurantFB.previewRest()
    
//    @IBOutlet private weak var button: CircularButton!
//    @IBOutlet private weak var statusLabel: UILabel!
    
    private var transport = MQTTCFSocketTransport()
    fileprivate var session = MQTTSession()
    fileprivate var completion: (()->())?
    
    var loadingPrinterConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session?.delegate = self
        self.transport.host = MQTT_HOST
        self.transport.port = MQTT_PORT
        session?.transport = transport
        
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
    
    private func updateUI(for clientStatus: MQTTSessionStatus) {
//        let view = UIHostingController(rootView: <#T##_#>)
        DispatchQueue.main.async {
            switch clientStatus {
            //have to switch between callwaiter and printer
                case .connected:
                    self.subscribe()
                    //topic needs to be dynamic for each printer - topic = raspberry/{name of rest}
                    print("ask about table num")
                    let dispatch = DispatchGroup()
                    dispatch.enter()
                    self.alertAboutTable(d: dispatch)
                    print("done asking about table num")
                    dispatch.notify(queue: .main){
                        self.publishMessage(" \(userProfile.fullName); \(self.dishInfo); \(self.tableNum)", onTopic: "raspberry/vics")
                        self.loadingPrinterConnection = false
                    }
            //need to dismiss the review order view as well and
//                    self.statusLabel.text = "Connected"
//                    self.button.isEnabled = true
                case .connecting,
                     .created:
                    let host = UIHostingController(rootView: PrintConnectionUI(connecting: false))
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
    
    func alertAboutTable(d: DispatchGroup) {
        //Step : 1
        let alert = UIAlertController(title: "Table number needed", message: "Please Input table number above QR code on table", preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        let save = UIAlertAction(title: "Send Order", style: .default) { (alertAction) in
                let textField = alert.textFields![0] as UITextField
            
            if textField.text != "" {
                        //Read TextFields text data
                print(textField.text!)
                print("Table number : \(textField.text!)")
                self.tableNum = textField.text!
                d.leave()
            } else {
                print("TF 1 is Empty...")
            }
            
        }
        
        alert.addTextField { (textField) in
                textField.placeholder = "Enter your table number"
                textField.textColor = .red
            }
        
        alert.addAction(save)
            //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        self.present(alert, animated:true, completion: nil)
        
    }

    private func subscribe() {
        self.session?.subscribe(toTopic: "raspberry/vics", at: .exactlyOnce) { error, result in
            print("subscribe result error \(String(describing: error)) result \(result!)")
            //need to run connection to POS on raspberry pi as a python script
        }
        print("port: \(self.session?.port)")
    }
    
    private func publishMessage(_ message: String, onTopic topic: String) {
        print("publishing message after asking about table")
        session?.publishData(message.data(using: .utf8, allowLossyConversion: false), onTopic: topic, retain: false, qos: .exactlyOnce)
        
        print("published message after asking about table")
    }
    
    
}

extension ClientViewController: MQTTSessionManagerDelegate, MQTTSessionDelegate {

    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        if let msg = String(data: data, encoding: .utf8) {
            print("topic \(topic!), msg \(msg)")
        }
    }

    func messageDelivered(_ session: MQTTSession, msgID msgId: UInt16) {
        print("delivered")
        DispatchQueue.main.async {
            self.completion?()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrderSent"), object: nil)
            self.dismiss(animated: true)
        }
    }
    
}

struct ClientConnection: UIViewControllerRepresentable {
    var dishes: [DishFB]
    var quantity: [DishFB:Int]
    var rest: RestaurantFB
    //add paramter of dishes and pass it through to viewcontroller to send as a message to printer to print
    typealias UIViewControllerType = ClientViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ClientConnection>) -> ClientViewController {
//            code 
        let connection = ClientViewController()
        connection.dishes = self.dishes
        connection.rest = rest
        var dishInfo: [(String, Double, Int)] = []
        for d in self.dishes{
            //take data for each dish and make into a tuple of (Name, Price)
            let dishTuple: (String, Double, Int) = (d.name, d.price, quantity[d]!)
            dishInfo.append(dishTuple)
            
            if(d == self.dishes.last){
                connection.dishInfo = dishInfo
                return connection
            }
        }
        
        return connection
        }

        func updateUIViewController(_ uiViewController: ClientViewController, context: UIViewControllerRepresentableContext<ClientConnection>) {
//            code
            print("yes")
        }
}

struct PrintConnectionUI: View {
    @State var connecting: Bool
    
    var body: some View {
            ZStack{
                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
                VStack{
                    Text("Sending order to kitchen")
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 50)
                    Loader(animate: connecting)
                }
                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
            }
    }
}

struct Loader: View {
    
    @State var animate = false
    var body: some View {
        
        VStack{
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [Color(UIColor().colorFromHex("#F88379", 1)), Color(UIColor().colorFromHex("#FFFFFF", 1))]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            
            Text("Please Wait...").padding(.top)
            
        }
        .background(Color.white)
        .cornerRadius(15)
            
        .onAppear {
            self.animate.toggle()
        }
        
    }
}
