//
//  AccountProfileView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/17/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import AuthenticationServices

struct ProfileButton: View {
    
    var imageName: String
    var label: String
    
    var body: some View{
        HStack {
           Image(imageName)
               .shadow(radius: 10)
               .frame(width: 40, height: 40)
           VStack(alignment: .leading) {
               Text(label)
                   .font(.custom("Futura Bold", size: 18))
           }
        }
    }
}

class AccountProfileViewModel: ObservableObject {
    
    @Published var user: ARMUser? = nil
    @Published var username: String? = nil
    
    let dbb2 = DatabaseRequest()
    
    func fetchUser() {
        var fetchUser: ARMUser? = nil
        DispatchQueue.main.async {
            fetchUser = self.dbb2.fetchUserWithCloudID(cloudID: KeychainItem.currentUserIdentifier!)
            self.user = fetchUser
            self.username = self.user?.userName
        }
    }
    
    func getProfPhoto() -> UIImage {
        print("gettin photo")
        if self.user != nil {
            let imageAsset: CKAsset? = self.user!.profilePhoto
            let data = NSData(contentsOf: (imageAsset?.fileURL!)!)
            let image = UIImage(data: data! as Data)
            if image == nil {
                print("nil image but user is there")
                return UIImage(imageLiteralResourceName: "profile_photo_edit")
            }
            else{
                print("image exists")
                return image!
            }
        }
        else{
            print("user does not exist")
            return UIImage(imageLiteralResourceName: "profile_photo_edit")
        }
    }
    
    func getUIImageFromCKAsset(image: CKAsset?) -> UIImage? {
        if(self.user != nil){
            let file: CKAsset? = image
            let data = NSData(contentsOf: (file?.fileURL!)!)
        
            return UIImage(data: data! as Data) ?? nil
        }
        else {
            return UIImage(imageLiteralResourceName: "profile_photo_edit")
        }
    }
    
}

struct AccountProfileView: View {
    
    @ObservedObject var AccountProf = AccountProfileViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    var body: some View {
            VStack(spacing: 40){
                ZStack{
                    if image ==  nil {
                        Image(uiImage: self.AccountProf.getUIImageFromCKAsset(image: self.AccountProf.user?.profilePhoto)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
    //                    if AccountProf.username != nil{
    //                        Text("\(AccountProf.username!)")
    //                    }
                    }
                    else{
                        image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    }
                }
                List{
                    NavigationLink(destination: Text("Orders")) {
                        ProfileButton(imageName: "contact_us", label: "Order History")
                    }

                    NavigationLink(destination: Text("Reviews/Pics")) {
                        ProfileButton(imageName: "contact_us", label: "Restaurants Visted")
                    }

                    NavigationLink(destination: Text("Contact Us")) {
                        ProfileButton(imageName: "contact_us", label: "Contact Us")
                    }

                    NavigationLink(destination: Text("Report Problem")) {
                        ProfileButton(imageName: "report_problem", label: "Report Problem")
                    }

                    NavigationLink(destination: Text("Suggest Restaurant")) {
                        ProfileButton(imageName: "report_problem", label: "Suggest Restaurant")
                    }

                    NavigationLink(destination: Text("Sign Out")) {
                        ProfileButton(imageName: "report_problem", label: "Sign Out")
                    }

                }
                
            }.navigationBarTitle("Account Profile")
            .navigationBarItems(trailing: Button(action: {
                self.showingImagePicker.toggle()
            }, label: {
                    Text("Edit Profile Photo")
        }))
            .onAppear{
                    if self.AccountProf.user == nil {
                        print("calling fetching")
                        self.AccountProf.fetchUser()
                    }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: changePhoto){ ImagePicker(image: self.$inputImage)
            }

        }
    
    func changePhoto(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

struct AccountProfile_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileView()
    }
}


