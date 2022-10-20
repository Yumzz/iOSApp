//
//  ARViewController+Actions.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/20/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import UIKit
import SceneKit

extension ViewController: UIGestureRecognizerDelegate {
    
    enum SegueIdentifier: String {
        case showObjects
        case showSurvey
    }
    
    // MARK: - Interface Actions
    
    /// Displays the `VirtualObjectSelectionViewController` from the `addObjectButton` or in response to a tap gesture in the `sceneView`.
    @IBAction func showVirtualObjectSelectionViewController() {
        // Ensure adding objects is an available action and we are not loading another object (to avoid concurrent modifications of the scene).
        
        guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else { return }
        
        // Added Code
//        let url = Bundle.main.url(forResource: file_name, withExtension: nil)!
//        let virtualObject = (VirtualObject(url: url))!
//        virtualObject.load()
//        if let query = sceneView.getRaycastQuery(for: virtualObject.allowedAlignment),
//            let result = sceneView.castRay(for: query).first {
//            virtualObject.mostRecentInitialPlacementResult = result
//            virtualObject.raycastQuery = query
//        } else {
//            virtualObject.mostRecentInitialPlacementResult = nil
//            virtualObject.raycastQuery = nil
//        }
//
//        guard focusSquare.state != .initializing, let query = virtualObject.raycastQuery else {
//             self.statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
//             if let controller = self.objectsViewController {
//                 self.virtualObjectSelectionViewController(controller, didDeselectObject: virtualObject)
//             }
//             return
//        }
//
//        let trackedRaycast = createTrackedRaycastAndSet3DPosition(of: virtualObject, from: query,
//                                                                   withInitialResult: virtualObject.mostRecentInitialPlacementResult)
//
//        virtualObject.raycast = trackedRaycast
//        virtualObjectInteraction.selectedObject = virtualObject
//        virtualObject.isHidden = false
        // End
        
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: addObjectButton)
    }
    
    /// Determines if the tap gesture for presenting the `VirtualObjectSelectionViewController` should be used.
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return virtualObjectLoader.loadedObjects.isEmpty
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable, !virtualObjectLoader.isLoading else { return }
        isRestartAvailable = false

        statusViewController.cancelAllScheduledMessages()

        virtualObjectLoader.removeAllVirtualObjects()
        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
            self.upperControlsView.isHidden = false
        }
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
              let segueIdentifer = SegueIdentifier(rawValue: identifier),
              segueIdentifer == .showObjects else { return }
        
        let objectsViewController = segue.destination as! VirtualObjectSelectionViewController
        objectsViewController.virtualObjects = models
        objectsViewController.delegate = self
        objectsViewController.sceneView = sceneView
        self.objectsViewController = objectsViewController
        
        let surveyViewHC = segue.destination as! SurveyViewHC
        self.objectsViewController = objectsViewController
        
        
        // Set all rows of currently placed objects to selected.
        for object in virtualObjectLoader.loadedObjects {
            guard let index = models.firstIndex(of: object) else { continue }
            objectsViewController.selectedVirtualObjectRows.insert(index)
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        objectsViewController = nil
    }
}



