
import ARKit
import SceneKit
import UIKit
//import CloudKit
import SwiftUI
import SceneKit.ModelIO
class ViewController: UIViewController, SCNSceneExportDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        NSURL(fileURLWithPath: self.ARVM.url!.path)
        
    }
#if !APPCLIP
var dish: DishFB?
#endif
var rest: RestaurantFB?
var models: [VirtualObject] = []
var dishModel: SCNScene?
let ARVM: ARViewControllerVM = ARViewControllerVM()
    
//var ARVM: ARViewControllerVM
// MARK: IBOutlets

@IBOutlet var sceneView: VirtualObjectARView!
@IBOutlet weak var addObjectButton: UIButton!
@IBOutlet weak var blurView: UIVisualEffectView!
@IBOutlet weak var spinner: UIActivityIndicatorView!
@IBOutlet weak var upperControlsView: UIView!
@IBOutlet weak var showSurvey: UIButton!
// MARK: - UI Elements

let coachingOverlay = ARCoachingOverlayView()
var focusSquare = FocusSquare()
/// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
/// The view controller that displays the virtual object selection menu.
    var objectsViewController: VirtualObjectSelectionViewController?
// MARK: - ARKit Configuration Properties

    var surveyView: SurveyViewHC = SurveyViewHC()!
/// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
/// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
/// Marks if the AR experience is available for restart.
    ///
    let previewController = QLPreviewController()
    var isRestartAvailable = true
/// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
/// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
return sceneView.session
    }
// MARK: - View Controller Life Cycle

override func viewDidLoad() {
super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
// Set up coaching overlay.
        setupCoachingOverlay()
// Set up scene content.
        sceneView.scene.rootNode.addChildNode(focusSquare)
//    ARVM = ARViewControllerVM(rest: self.rest!)
// Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
self.restartExperience()
        }
let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showVirtualObjectSelectionViewController))
// Set the delegate to ensure this gesture is only used when there are no virtual objects in the scene.
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)
    }
override func viewWillAppear(_ animated: Bool) {
// Added Code
        customActivityIndicator(self.view)
    DispatchQueue.main.async { [self] in
//            let ARVM = ARViewControllerVM()
            let d = DispatchGroup()
            d.enter()
        #if APPCLIP
        //update this method with api link
            print("before fetch dish model")
            ARVM.fetchDishModel(dishrecord: "", d: d)
        #else
            ARVM.fetchDishModel(dish: self.dish!, d: d)
        #endif
            d.notify(queue: .main){
                print("dispatch notified")
//            if(file != nil){
//                let data = NSData(data: file!)
                let data = NSData(contentsOf: (ARVM.url!))
                self.previewController.delegate = self
//                previewController
                self.previewController.dataSource = self
//                previewController.
                self.present(self.previewController, animated: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(30)) {
            //                    // your code here
                    self.previewController.present(self.surveyView, animated: false)
            //                    previewController.performSegue(withIdentifier: "showSurvey", sender: showSurvey)
            ////                    self.performSegue(withIdentifier: "showSurvey", sender: nil)
                }
                
//                let surveyView = SurveyViewHC()
//                previewController.addChild(surveyView!)

                //after 30 seconds perform show Survey segue
            }
        
            removeActivityIndicator(self.view)
        }
// End
    }
override func viewDidAppear(_ animated: Bool) {
super.viewDidAppear(animated)
// Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
// Start the `ARSession`.
        resetTracking()
    }
override var prefersHomeIndicatorAutoHidden: Bool {
return true
    }
override func viewWillDisappear(_ animated: Bool) {
super.viewWillDisappear(animated)
        session.pause()
    }
// MARK: - Session management

/// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        virtualObjectInteraction.selectedObject = nil
let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
    }
// MARK: - Focus Square
func updateFocusSquare(isObjectVisible: Bool) {
if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
// Perform ray casting only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
let query = sceneView.getRaycastQuery(),
let result = sceneView.castRay(for: query).first {
            updateQueue.async {
self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
if !coachingOverlay.isActive {
                addObjectButton.isHidden = false
                showSurvey.isHidden = false
            }
            statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
self.focusSquare.state = .initializing
self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            addObjectButton.isHidden = true
            showSurvey.isHidden = true
            objectsViewController?.dismiss(animated: false, completion: nil)
        }
    }
// MARK: - Error handling

func displayErrorMessage(title: String, message: String) {
// Blur the background.
        blurView.isHidden = false
// Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
self.blurView.isHidden = true
self.resetTracking()
        }
        alertController.addAction(restartAction)
present(alertController, animated: true, completion: nil)
    }
    
//    struct UIARView: UIViewControllerRepresentable {
//        typealias UIViewControllerType = ViewController
//
//        func makeUIViewController(context: Context) -> ViewController {
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let viewController = sb.instantiateViewController(identifier: "ARView") as! ViewController
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//
//        }
//    }
    
}

struct UIARView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    #if !APPCLIP
    var d: DishFB
    #endif

    func makeUIViewController(context: Context) -> ViewController {
        let sb = UIStoryboard(name: "ARView", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "ARView") as! ViewController
//        ViewController(coder: NSCoder())
//        viewController.dish = d
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {

    }
}


extension NSCoder {
  class func empty() -> NSCoder {
    let data = NSMutableData()
      let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.finishEncoding()
      return NSKeyedUnarchiver(forReadingWith: data as Data)
  }
}
