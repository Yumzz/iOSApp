//
//  ImagePicker.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker){
            self.parent = parent
        }
        
        func showImagePickerController() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let editedImage = info[.editedImage] as?
                UIImage{
                parent.image = editedImage
                
                DispatchQueue.main.async {
                    guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
                        return
                    }
                    
                    do {
                        try editedImage.pngData()?.write(to: imageURL)
                    } catch { }
                    
//                    let imageAsset = CKAsset(fileURL: imageURL)
//
//                    let result = db.editUsePhoto(cloudID: KeychainItem.currentUserIdentifier!, photo: imageAsset)
//                    print("result: \(result)")
                    
                }
                
            }
            
            else if let uiImage = info[.originalImage] as?
                UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    
}
