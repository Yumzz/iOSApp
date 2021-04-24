//
//  ScannerViewController.swift
//  Alegemeen
//
//  Created by Rohan Tyagi on 3/5/21.

import Foundation
import UIKit
import AVFoundation
import Vision
import CloudKit

@available(iOS 13.0, *)
class ScannerViewController: ScannerFunctions {
    var request: VNRecognizeTextRequest!
    // Temporal string tracker
    @IBOutlet weak var promptLabel: UILabel!
    let numberTracker = StringTracker()
    var dishName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up vision request before letting ViewController set up the camera
        // so that it exists when the first buffer is received.
//        promptLabel = UILabel()
        promptLabel.layer.cornerRadius = 8
        promptLabel.layer.masksToBounds = true
        promptLabel.textAlignment = .center
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        self.navigationController?.isNavigationBarHidden = false
        print("Scanner Done")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if dishes.isEmpty {
//            customActivityIndicator(self.view)
//            DispatchQueue.main.async {
//                restaurant = db.fetchRestaurantWithID(id: "96D93F3C-F03A-2157-B4B7-C6DBFCCC37D0")
//                dishes = db.fetchRestaurantDishes(res: restaurant!)
//                removeActivityIndicator(self.view)
//            }
//        }
    }
    
    // MARK: - Text recognition
    
    // Vision recognition handler.
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        var letters = [String]()
        var redBoxes = [CGRect]() // Shows all recognized text lines
//        var greenBoxes = [CGRect]() // Shows words that might be serials
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let maximumCandidates = 1
        
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            
            // Draw red boxes around any detected text, and green boxes around
            // any detected phone numbers. The phone number may be a substring
            // of the visionResult. If a substring, draw a green box around the
            // number and a red box around the full string. If the number covers
            // the full result only draw the green box.
            
            var name = ""
//            if let menuDish = candidate.string.extractMenuDish(menuItems: dishes){
//                name = menuDish.name
//                letters.append(name)
//            }
            redBoxes.append(visionResult.boundingBox)
        }
        
        // Log any found numbers.
        numberTracker.logFrame(strings: letters)
        show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes)])
        
        // Check if we have any temporally stable numbers.
        if let sureDishName = numberTracker.getStableString() {
//            showString(string: sureNumber)
            dishName = sureDishName
            stopSession()
            //this needs to trigger the prepare function
            self.performSwitch()
        }
    }
    
    func performSwitch(){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                print("perform")
                self.performSegue(withIdentifier: "ARView", sender: self)
                print("perform end")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ARView"){
//            let dish = (dishes.filter{$0.name == dishName})[0]
            print("prepare")
//            guard let detailViewController = segue.destination as? ItemDetailsViewController
//                else {
//                    return
//            }
//            detailViewController.dish = dish
//            print(dish.name)
            print("prepare end")
        }
    }
            
//            guard let detailViewController = segue.destination as? ItemsDetails2ViewController,
//                guard let name = (menuitems.filter{$0.name == dishName})[0]
//
//                if (check.isEmpty == false){
//                print(check[0])
//                detailViewController?.menuitem = check[0]
//                dishName = ""
//                }
//                else{
//                print("Could not find Dish")
//                return
//                }
//            elsedo {
//                return nil
//            }
//        }
//    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            // Configure for running in real-time.
            request.recognitionLevel = .fast
            // Language correction won't help recognizing phone numbers. It also
            // makes recognition slower.
            request.usesLanguageCorrection = false
            // Only run on the region of interest for maximum speed.
            request.regionOfInterest = regionOfInterest
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: textOrientation, options: [:])
            do {
                try requestHandler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Bounding box drawing
    
    // Draw a box on screen. Must be called from main queue.
    var boxLayer = [CAShapeLayer]()
    func draw(rect: CGRect, color: CGColor) {
        let layer = CAShapeLayer()
        layer.opacity = 0.5
        layer.borderColor = color
        layer.borderWidth = 1
        layer.frame = rect
        boxLayer.append(layer)
        previewView.videoPreviewLayer.insertSublayer(layer, at: 1)
    }
    
    // Remove all drawn boxes. Must be called on main queue.
    func removeBoxes() {
        for layer in boxLayer {
            layer.removeFromSuperlayer()
        }
        boxLayer.removeAll()
    }
    
    typealias ColoredBoxGroup = (color: CGColor, boxes: [CGRect])
    
    // Draws groups of colored boxes.
    func show(boxGroups: [ColoredBoxGroup]) {
        DispatchQueue.main.async {
            let layer = self.previewView.videoPreviewLayer
            self.removeBoxes()
            for boxGroup in boxGroups {
                let color = boxGroup.color
                for box in boxGroup.boxes {
                    let rect = layer.layerRectConverted(fromMetadataOutputRect: box.applying(self.visionToAVFTransform))
                    self.draw(rect: rect, color: color)
                }
            }
        }
    }
}
