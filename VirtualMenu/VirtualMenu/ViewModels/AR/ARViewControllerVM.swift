//
//  ARViewControllerVM.swift
//  YumzzAR
//
//  Created by Rohan Tyagi on 5/20/22.
//

import Foundation
import SwiftUI
#if !APPCLIP
import Firebase
import FirebaseStorage
#endif
//import CloudKit

class ARViewControllerVM: ObservableObject {
    var url: URL? = nil
    
    #if !APPCLIP
    let db = Firestore.firestore()
    
//    let d: CKDatabase
//    let container: CKContainer
//    var restaurant: RestaurantFB
//    var model: Data? = nil
    
    
    //fetch dish model - put an example one in FB
    //must fetch from firebase storage
    //have a boolean in database specfiying
    
//    init(rest: RestaurantFB){
//        self.restaurant = rest
//    }
    init() {
        url = getDocumentsDirectory().appendingPathComponent("message.txt")
//        container = CKContainer.default()
//        d = container.publicCloudDatabase
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    //Restaurant/RestName/dish/DishName/model
    func fetchDishModel(dish: DishFB, d: DispatchGroup) {
//        var model: Data? = nil
//        var url = getDocumentsDirectory().appendingPathComponent("message.txt")
//        let semaphore = DispatchSemaphore(value: 0)
//        let storage = Storage.storage()
//        let modelRef = storage.reference().child("Restaurant/\(dish.restaurant.lowercased())/dish/\(dish.name.lowercased().replacingOccurrences(of: " ", with: "-"))/model/$model")
//        modelRef.write(toFile: url!)
//        modelRef.getData(maxSize: 100 * 100 * 400) { dat, err in
//            if let err = err {
//                print("error getting model")
//                print(err.localizedDescription)
////                dispatch.leave()
////                d.leave()
//            }
//            else{
//                print("model got")
//                model = dat!
//                semaphore.signal()
////                d.leave()
////                return dat!
//            }
//        }
        print("url: \(url)")
//        return url
//        _ = semaphore.wait(timeout: .now()+10)
//        return model
        d.leave()
//        modelRef.get
        
    }
    
//    func fetchDishModell(dishrecord: String) -> CKAsset? {
//        var model_mesh : CKAsset? = nil
//        let semaphore = DispatchSemaphore(value: 0)
//
//        // prevent empty reviews
////        if (dish.model == nil) {
////            return nil
////        }
//        let rec = CKRecord.ID(recordName: "EE620F88-504E-9101-F17C-E227110D3ADF")
//        d.fetch(withRecordID: rec) { record, error in
//            guard error == nil else { print("whay: \(error.debugDescription)"); return }
////            print("yo \(record?.recordID)")
//            print("hero")
//            let model = Model(record: record!, database: self.d)
//            model_mesh = model?.modelMesh!
//            semaphore.signal()
//        }
//        _ = semaphore.wait(timeout: .now()+10)
//        return model_mesh!
//    }
    
    #else
    //use api link to fetch model
//    let d: CKDatabase
//    let container: CKContainer
    
    init() {
//        container = CKContainer.default()
//        d = container.publicCloudDatabase
        url = getDocumentsDirectory().appendingPathComponent("message.txt")
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func fetchDishModel(dishrecord: String, d: DispatchGroup) {
        //retrieve model through api link
        
//        let glbLink = "https://restaurantitem3dmodelproduction.s3.ap-south-1.amazonaws.com/undefined/NewDish/1659164405390modelGLB.glb"

        let usdzLink = "https://restaurantitem3dmodelproduction.s3.ap-south-1.amazonaws.com/undefined/New+Dish/1659164411000modelUSDZ.usdz"

        let modelURL = URL(string: usdzLink)
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.url = documentsUrl.appendingPathComponent("downloadedFile.usdz")
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        let request = URLRequest(url: modelURL!)
//        request.httpMethod = "GET"
        let downloadTask = session.downloadTask(with: request, completionHandler: { (location:URL?, response:URLResponse?, error:Error?) -> Void in
//            let fileManager = FileManager.default
            if let location = location, error == nil{
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
//                    try FileManager.removeItem(atPath: self.url!.path)
                    if FileManager.default.fileExists(atPath: self.url!.path){
                        try FileManager.default.removeItem(at: self.url!)
                        print("file exists here already ")
                    }
                    try FileManager.default.copyItem(at: location, to: self.url!)
//                    self.url = location
                    d.leave()
                }
                catch (let writeError) {
                    print("Error creating a file \(self.url) : \(writeError)")
                }
            }
            else{
                print("error downloading a file")
            }
//            if fileManager.fileExists(atPath: destinationUrl.path) {
//                try! fileManager.removeItem(atPath: destinationUrl.path)
//            }

//            try! fileManager.moveItem(atPath: location!.path, toPath: self.url!.path)
//            d.leave()
//            DispatchQueue.main.async {
//                do {
//                    let object = try Entity.load(contentsOf: destinationUrl) // It is work
//                    let anchor = AnchorEntity(world: [0, 0, 0])
//                    anchor.addChild(object)
//                    self.arView.scene.addAnchor(anchor)
//                }
//                catch {
//                    print("Fail load entity: \(error.localizedDescription)")
//                }
//            }
        })
        downloadTask.resume()
        
//        DiggerManager.shared.download(with: usdzLink as! DiggerURL)
//            .progress({ (progress) in
////                print(progress.fractionComplete)
////                progress.
//            })
//            .completion({ [self] (result) in
//                switch result{
//                case .success(let u):
//                    self.url = u
//                case .failure(_):
//                    print("failed")
//                    print(result)
//                }
//
//            })
//        var request = URLRequest(url: modelURL!)
//        request.httpMethod = "GET"
//        var dat: Data? = nil
//        self.url = URL(string: "")
        
//        try S3Client(region: "ap-south-1")
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
////            guard let httpResponse = response as? HTTPURLResponse,
////                  (200...299).contains(httpResponse.statusCode) else {
////                print("network error")
////                print(response?.description)
//////                    title = "Network Error"
//////                    result = "There was a Network Error while processing your request"
////
////                    return
////            }
//            print("data: \(data)")
//            do{
//                try data?.write(to: self.url!)
//                d.leave()
//            }
//            catch{
//                print("could not write data")
//            }
////            dat = data?.base64EncodedData()
////            print("data2: \(URL(dataRepresentation: (data?.base64EncodedData())!, relativeTo: url!))")
////            data.
////            response.debugDescription
//            print("data1: \(data.unsafelyUnwrapped)")
////            title = "Request Submitted!"
////            result = "Our team will respond shortly"
//        }.resume()
        
//        self.url = url!
//        Data(contentsOf: <#T##URL#>)
//        var model_mesh : CKAsset? = nil
//        let semaphore = DispatchSemaphore(value: 0)

        // prevent empty reviews
//        if (dish.model == nil) {
//            return nil
//        }
//        let rec = CKRecord.ID(recordName: "EE620F88-504E-9101-F17C-E227110D3ADF")
//        d.fetch(withRecordID: rec) { record, error in
//            guard error == nil else { print("whay: \(error.debugDescription)"); return }
////            print("yo \(record?.recordID)")
//            print("hero")
//            let model = Model(record: record!, database: self.d)
//            model_mesh = model?.modelMesh!
//            semaphore.signal()
//        }
//        print("Successful fetch")
//        _ = semaphore.wait(timeout: .now()+10)
//        self.url = model_mesh?.fileURL!
//        return model_mesh!
    }
    
#endif
}

//class Model {
//
//  static let recordType = "Model"
//  private let id: CKRecord.ID
//  let modelMesh: CKAsset?
//  var user: CKRecord.Reference? = nil
//  var dish: CKRecord.Reference? = nil
//
//  init?(record: CKRecord, database: CKDatabase) {
//    id = record.recordID
//    modelMesh = record["ModelMesh"] as? CKAsset
//
//    user = record["User"] as? CKRecord.Reference
//    dish = record["Dish"] as? CKRecord.Reference
//
//  }
//
//}

//extension Model: Hashable {
//  static func == (lhs: Model, rhs: Model) -> Bool {
//    return lhs.id == rhs.id
//  }
//
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(id)
//  }
//}

