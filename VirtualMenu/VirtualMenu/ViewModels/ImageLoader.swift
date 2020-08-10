//
//  ImageLoader.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 07/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

final class ImageLoader : ObservableObject {
    @Published var data: Data?

    func loadImage(url: String){
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 2 * 2048 * 2048) { data, error in
            if let error = error {
                print("\(error)")
            }

            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}
