//
//  ScannerViewController.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Vision
import CloudKit
import SwiftUI

@available(iOS 13.0, *)

let db = DatabaseRequest()
var restaurant : Restaurant? = nil
var dishes : [Dish] = []

class ScannerViewController: ScannerFunctions {
    var request: VNRecognizeTextRequest = VNRecognizeTextRequest()
    let numberTracker = StringTracker()
    var dishName: String = ""
    var isClicked: Bool = false
    var foundDish: Bool = false

    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Set up vision request before letting ViewController set up the camera
           // so that it exists when the first buffer is received.
           request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
           self.navigationController?.isNavigationBarHidden = false
           print("Scanner Done")
       }
    
//    init(dishName: Binding<String>, isClicked: Binding<Bool>, foundDish: Binding<Bool>)  {
//        _isClicked = isClicked
//        _dishName = dishName
//        _foundDish = foundDish
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
                if let menuDish = candidate.string.extractMenuDish(menuItems: dishes){
                    name = menuDish.name
                    letters.append(name)
                }
                redBoxes.append(visionResult.boundingBox)
            }
            
            // Log any found numbers.
            numberTracker.logFrame(strings: letters)
            show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes)])
            
            // Check if we have any temporally stable numbers.
            if let sureDishName = numberTracker.getStableString() {
//                showString(string: sureNumber)
                dishName = sureDishName
                //triggers segue
                self.foundDish.toggle()
                stopSession()
            }
        }
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



struct ScanView: View {
    var body: some View {
        VStack{
            ScanView2ControllerRepresentable()
//            .overlay(
//                VStack{
//                    Button(action: ScanView2ControllerRepresentable())
//
//                }
//            )
        }
        
    }


}


//struct ScannerViewControllerRepresentable: UIViewControllerRepresentable {
//
//        @Binding var isClicked: Bool
//        @Binding var dishName: String
//        @Binding var foundDish: Bool
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerViewControllerRepresentable>) -> ScannerViewController {
//        return ScannerViewController(dishName: $dishName, isClicked: $isClicked, foundDish: $foundDish)
//    }
//
//    func updateUIViewController(_ uiViewController: ScannerViewController, context: UIViewControllerRepresentableContext<ScannerViewControllerRepresentable>) {
//        return
//    }
//}


struct ScanView2ControllerRepresentable: UIViewControllerRepresentable {
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanView2ControllerRepresentable>) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Scanner", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "Scan")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ScanView2ControllerRepresentable>) {
        return
    }
    
}
