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
import Instructions
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift

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
var pastOrders: [Order] = []

class ClientViewController: UIViewController, CoachMarksControllerDelegate, CoachMarksControllerDataSource
{
    
    //need to make this connect to printer and send dishes to printer to print

    let MQTT_HOST = "broker.emqx.io" // or IP address e.g. "192.168.0.194"
    let MQTT_PORT: UInt32 = 1883
    
    var dishes: [DishFB] = []
    var dishInfo: [(String, Double, Int, String)] = []
    var tableNum: String = ""
    var rest: RestaurantFB = RestaurantFB.previewRest()
    let coachMarksController = CoachMarksController()
    private var db = Firestore.firestore()
//    @Published
    var newOrder: Order = Order(dishes: [], totalPrice: 0.0, rest: "")
//    @EnvironmentObject var order : OrderModel
    
//    @IBOutlet private weak var button: CircularButton!
//    @IBOutlet private weak var statusLabel: UILabel!
    
    private var transport = MQTTCFSocketTransport()
    fileprivate var session = MQTTSession()
    fileprivate var completion: (()->())?
    
//    var loadingPrinterConnection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session?.delegate = self
        self.coachMarksController.dataSource = self
//        QRScanViewController()
        self.transport.host = MQTT_HOST
        self.transport.port = MQTT_PORT
        session?.transport = transport
//        self.coach
        print("view model print order")
//        self.presentingViewController = QRScanViewController()
        
        //need to output text saying wrong qr code if callwait or choose rest
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CallWait"), object: nil, queue: .main) { [self] (Notification) in
//            var text = "Wrong QR code scanned"
//
//        }
        var forgetMessage = false
        //turn this true and subsequently delete dishInfo if wrong QR
        //add each sent message dish info to a global list of past orders
        //if dishInfo is same as one before, then dont send it
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CallWaitWrong"), object: nil, queue: .main) { [self] (Notification) in
            forgetMessage = true
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ChooseRestWrong"), object: nil, queue: .main) { [self] (Notification) in
            forgetMessage = true
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PrintInfo"), object: nil, queue: .main) { [self] (Notification) in
//                        self.pastOrders = Notification.object as! [Order]
            print("asked and gotten")
            var text = Notification.object as! String
            //parse out table num
            print("ask: \(text)")
            let dispatch = DispatchGroup()
            dispatch.enter()
            print("enter")
            self.tableNum = getQueryStringParameter(url: text, param: "table", d: dispatch)!
//            let tab = text.queryItems?.first(where: { $0.name == "table" })?.value
            dispatch.notify(queue: .main){
                print("ask: \(self.tableNum)")
    //            self.tableNum = getQueryStringParameter(url: text, param: "table", d: dispatch)!
                var topic = self.rest.name.lowercased()
                if(topic.lowercased().contains("vics")){
                    topic = "vics"
                }
                if(!forgetMessage){
                    var total = 0.0
                    var specInstructs = ""
                    for inf in self.dishInfo{
                        total += inf.1
                        specInstructs = specInstructs + ", \(inf.3)"
                    }
                    
                    newOrder = Order(dishes: self.dishes, totalPrice: total, rest: self.rest.name, id: userProfile.userId, time: NSDate(timeIntervalSince1970: TimeInterval(NSDate().timeIntervalSince1970)) as Date, specialInstruc: specInstructs)
                    var orderAlreadySent = false
                    for pO in pastOrders{
                        if (pO.rest == newOrder.rest && pO.dishes == newOrder.dishes && pO.specialInstruc == newOrder.specialInstruc) {
                            orderAlreadySent = true
                            print("already sent")
                        }
                    }
                    if(!orderAlreadySent){
                        self.publishMessage(" \(userProfile.fullName); \(self.dishInfo); \(self.tableNum)", onTopic: "raspberry/vics")
                        pastOrders.append(newOrder)
                        self.addOrder()
                    }
                    else{
                        self.dishInfo = []
                        self.tableNum = ""
                    }
                }
                else{
                    print("forget message")
                    forgetMessage = false
                    self.dishInfo = []
                    self.tableNum = ""
                }
                //need to notiffy this 
            }
//                        self.loadingPrinterConnection = false
        }
        
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
        DispatchQueue.main.async {
            switch clientStatus {
            //have to switch between callwaiter and printer
                case .connected:
                    self.subscribe()
                    //topic needs to be dynamic for each printer - topic = raspberry/{name of rest}
//                    print("ask about table num")
//                    self.alertAboutTable(d: dispatch)
//                    print("done asking about table num")
//                    dispatch.notify(queue: .main){
                    
//                    }
            //need to dismiss the review order view as well and
//                    self.statusLabel.text = "Connected"
//                    self.button.isEnabled = true
                case .connecting,
                     .created:
                    let host = UIHostingController(rootView: PrintConnectionUI())
                    guard let hostView = host.view else {return}
                    hostView.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(hostView)
                    hostView.center = self.view.center
//                    host.view = QRScanViewController()
//                    hostView.centerYAnchor
                    
//                    self.loadingPrinterConnection = true
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
    
    func addOrder(){
        
        var data: [String : Any] = [:]
        //go through all dishes and retrieve reference of them
        var dishRefs : [String] = []
        for d in self.newOrder.dishes {
            let docRef = db.collection("Dish").whereField("Name", isEqualTo: d.name).whereField("Restaurant", isEqualTo: d.restaurant)
            docRef.getDocuments { [self] snap, err in
                for doc in snap!.documents{
                    print("Dish/\(doc.reference.documentID)")
                    dishRefs.append("\(doc.reference.documentID)")
                    if(d == self.newOrder.dishes.last){
                        newOrder.specialInstruc.removeFirst()
                        newOrder.specialInstruc.removeFirst()
                        print("Dish/\(newOrder.specialInstruc)")
                        data = ["instruct": newOrder.specialInstruc, "userId": (newOrder.id == "" ? "guest" : newOrder.id), "totalPrice": newOrder.totalPrice, "rest": d.restaurant, "time": newOrder.time, "dishes":dishRefs] as [String : Any]
                        print("Dish/\(data)")
                        do {
                            let _ = try db.collection("Order").addDocument(data: data)
                        }
                        catch{
                            print(error)
                        }
                    }
                }
            }
            data = ["instruct": newOrder.specialInstruc, "userId": (newOrder.id == "" ? "guest" : newOrder.id), "totalPrice": newOrder.totalPrice, "rest": newOrder.rest, "time": newOrder.time, "dishes":dishRefs] as [String : Any]
//        }
        
        }
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
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
//        let save = UIAlertAction(title: "Send Order", style: .default) { (alertAction) in
//                let textField = alert.textFields![0] as UITextField
//
//            if textField.text != "" {
//                        //Read TextFields text data
//                print(textField.text!)
//                print("Table number : \(textField.text!)")
//                self.tableNum = textField.text!
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
        print("restname: \(self.rest.name)")
        var topic = self.rest.name.lowercased()
        if(topic.lowercased().contains("vics")){
            topic = "vics"
        }
        print("topic: \(topic)")
        self.session?.subscribe(toTopic: "raspberry/vics", at: .exactlyOnce) { error, result in
            print("subscribe result error \(String(describing: error)) result \(result!)")
            //need to run connection to POS on raspberry pi as a python script
        }
        print("port: \(self.session?.port)")
        print("raspberry/" + topic)
    }
    
    private func publishMessage(_ message: String, onTopic topic: String) {
        print("publishing message after asking about table")
        session?.publishData(message.data(using: .utf8, allowLossyConversion: false), onTopic: topic, retain: false, qos: .exactlyOnce)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrderSent"), object: nil)
        print("published message after asking about table")
    }
//#if !APPCLIP
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

        coachViews.bodyView.hintLabel.text = "Scan the qr code with green border!"
//        coachViews.bodyView.fillSuperviewHorizontally()
//        coachViews.bodyView.nextLabel.text = "Order will be sent!"

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
//    #endif
    
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
            print("here in deliverance")
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrderSent"), object: nil)
            self.dismiss(animated: true)
        }
    }
    
}

struct ClientConnection: UIViewControllerRepresentable {
    var dishes: [DishFB]
    var quantity: [DishFB:Int]
    var rest: RestaurantFB
    @EnvironmentObject var order : OrderModel
    //add paramter of dishes and pass it through to viewcontroller to send as a message to printer to print
    typealias UIViewControllerType = ClientViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ClientConnection>) -> ClientViewController {
//            code
        let connection = ClientViewController()
        connection.dishes = self.dishes
        connection.rest = rest
        var dishInfo: [(String, Double, Int, String)] = []
        for d in self.dishes{
            //take data for each dish and make into a tuple of (Name, Price)
//            print(self.order.dishChoice[d]!)
            let dishTuple: (String, Double, Int, String)
            if(self.order.dishChoice[d] == nil){
//                print("yessss: \(self.order.dishChoice[d])
                dishTuple = (d.name, d.price, quantity[d]!, "")
            }
            else{
                print("yessss: \(self.order.dishChoice[d]!)")
                print("noooo: \(quantity[d]!)")
                dishTuple = (d.name, d.price, quantity[d]!, self.order.dishChoice[d]!)
            }
            dishInfo.append(dishTuple)
            
            
            if(d == self.dishes.last){
                connection.dishInfo = dishInfo
                connection.rest = rest
                return connection
            }
        }
        connection.rest = rest
        return connection
    }

        func updateUIViewController(_ uiViewController: ClientViewController, context: UIViewControllerRepresentableContext<ClientConnection>) {
//            code
            print("update")
        }
}

struct PrintConnectionUI: View {
    @State var wrongQRCode: Bool = false
    @State var string: String = ""
    
    var body: some View {
            ZStack{
                QRScanView(completion: { textPerPage in
                    print("aa: \(textPerPage)")
//                    print("ask: \(text)")
                    if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                        print("ask: \(text)")
//                        self.string = text
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PrintInfo"), object: self.string)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PrintInfo"), object: self.string)
                    }
                   
                }, choice: 2)
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
//                VStack{
//                    Text("Sending order to kitchen")
//                    Spacer().frame(width: UIScreen.main.bounds.width, height: 50)
//                    Loader(animate: connecting)
//                }
//                Spacer().frame(width: UIScreen.main.bounds.width, height: 100)
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .onAppear(){
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "CallWaitWrong"), object: nil, queue: .main) { [self] (Notification) in
                    print("callwaitwrong")
                    self.wrongQRCode = true
                }
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ChooseRestWrong"), object: nil, queue: .main) { [self] (Notification) in
                        print("chooserestwrong")
                        self.wrongQRCode = true
                }
            }
            .alert(isPresented: self.$wrongQRCode){
                return Alert(title: Text("Wrong QR Code! Please drag down this view, reclick the qr scanner, and scan the QR Code with the green border!"))
                self.wrongQRCode = false
            }
        
//            .onAppear(){
//            }
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
