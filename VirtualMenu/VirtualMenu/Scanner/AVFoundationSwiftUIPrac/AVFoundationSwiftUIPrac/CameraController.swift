//
//  CameraViewController.swift
//  AVFoundationSwiftUIPrac
//
//  Created by Rohan Tyagi on 5/31/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import AVFoundation

var x = 1
var capSession: AVCaptureSession?

class CameraController: NSObject{
    
    var captureSession: AVCaptureSession?
    var backCamera: AVCaptureDevice?
    var backCameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let captureSessionQueue = DispatchQueue(label: "ARMenuRequests.CaptureSessionQueue")
    
    var currentOrientation = UIDeviceOrientation.portrait
    
    var reset = 0
    
    var captureDevice: AVCaptureDevice?
    
    var videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "ARMenuRequests.VideoDataOutputQueue")
    
    // MARK: - Region of interest (ROI) and text orientation
    // Region of video data output buffer that recognition should be run on.
    // Gets recalculated once the bounds of the preview layer are known.
    var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
    // Orientation of text to search for in the region of interest.
    var textOrientation = CGImagePropertyOrientation.up
    
    // MARK: - Coordinate transforms
    var bufferAspectRatio: Double!
    // Transform from UI orientation to buffer orientation.
    var uiRotationTransform = CGAffineTransform.identity
    // Transform bottom-left coordinates to top-left.
    var bottomToTopTransform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
    // Transform coordinates in ROI to global coordinates (still normalized).
    var roiToGlobalTransform = CGAffineTransform.identity
    
    // Vision -> AVF coordinate transform.
    var visionToAVFTransform = CGAffineTransform.identity
    
    enum CameraControllerError: Swift.Error {
       case captureSessionAlreadyRunning
       case captureSessionIsMissing
       case inputsAreInvalid
       case invalidOperation
       case noCamerasAvailable
       case unknown
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void){
        func createCaptureSession(){
            self.captureSession = AVCaptureSession()
        }
        func configureCaptureDevices() throws {
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            
            self.backCamera = camera
            
            try camera?.lockForConfiguration()
            camera?.unlockForConfiguration()
                
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            capSession = captureSession
               
            if let frontCamera = self.backCamera {
                self.backCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                   
                if captureSession.canAddInput(self.backCameraInput!) { captureSession.addInput(self.backCameraInput!)}
                else { throw CameraControllerError.inputsAreInvalid }
                   
            }
            else { throw CameraControllerError.noCamerasAvailable }
               
            captureSession.startRunning()
               
        }
           
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            }
                
            catch {
                DispatchQueue.main.async{
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
            
        
        capSession = captureSession
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
        
        func setupCamera() {
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
                print("Could not create capture device.")
                return
            }
            self.captureDevice = captureDevice
            
            // NOTE:
            // Requesting 4k buffers allows recognition of smaller text but will
            // consume more power. Use the smallest buffer size necessary to keep
            // down battery usage.
            
            if(reset == 1){
                for output in captureSession!.outputs{
                    captureSession!.removeOutput(output)
                }
                for input in captureSession!.inputs{
                    captureSession!.removeInput(input)
                }
            }
            
            if captureDevice.supportsSessionPreset(.hd4K3840x2160) {
                captureSession!.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
                bufferAspectRatio = 3840.0 / 2160.0
            } else {
                captureSession!.sessionPreset = AVCaptureSession.Preset.hd1920x1080
                bufferAspectRatio = 1920.0 / 1080.0
                x = 2
            }
            
            guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
                print("Could not create device input.")
                return
            }
            if captureSession!.canAddInput(deviceInput) {
                captureSession!.addInput(deviceInput)
                print("added input")
            }
            
            // Configure video data output.
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
            if captureSession!.canAddOutput(videoDataOutput) {
                captureSession!.addOutput(videoDataOutput)
                print("outputAdded")
                // NOTE:
                // There is a trade-off to be made here. Enabling stabilization will
                // give temporally more stable results and should help the recognizer
                // converge. But if it's enabled the VideoDataOutput buffers don't
                // match what's displayed on screen, which makes drawing bounding
                // boxes very hard. Disable it in this app to allow drawing detected
                // bounding boxes on screen.
                videoDataOutput.connection(with: AVMediaType.video)?.preferredVideoStabilizationMode = .off
            } else {
                print("Could not add VDO output")
                return
            }
            
            // Set zoom and autofocus to help focus on very small text.
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.videoZoomFactor = 2
                captureDevice.autoFocusRangeRestriction = .near
                captureDevice.unlockForConfiguration()
            } catch {
                print("Could not set zoom level due to error: \(error)")
                return
            }
            reset = 0
            captureSession!.startRunning()
        }
        
        // MARK: - UI drawing and interaction
        
        func stopSession() {
            // Found a definite number.
            // Stop the camera synchronously to ensure that no further buffers are
            // received. Then update the number view asynchronously.
            captureSessionQueue.sync {
                self.captureSession!.stopRunning()
            }
        }

        
    //    func showDish(string: String){
    //        var menuCards: MenuCardViewController?
    //
    //        let detailViewController = segue.destination as? ItemDetailsViewController
    //
    //
    //        detailViewController.menuitem = (menuCards?.menuitems.filter{$0.name == String(self)})
    //    }
        
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // This is implemented in ScannerViewController.
    }
}

// MARK: - Utility extensions

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
}
