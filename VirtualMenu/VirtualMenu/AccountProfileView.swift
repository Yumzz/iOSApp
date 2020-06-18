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
    
    let dbb = DatabaseRequest()
    
    func fetchUser() {
        DispatchQueue.main.async {
            self.user = db.fetchUserWithCloudID(cloudID: KeychainItem.currentUserIdentifier!)
            self.username = self.user?.userName
        }
    }
    
    func getProfPhoto() -> UIImage? {
        if self.user?.profilePhoto != nil {
            let imageAsset: CKAsset? = self.user?.profilePhoto
            let data = NSData(contentsOf: (imageAsset?.fileURL!)!)
            let image = UIImage(data: data! as Data)
            return image
        }
        else{
            return UIImage(imageLiteralResourceName: "profile_photo_edit")
        }
    }
    
}

struct AccountProfileView: View {
    
    @ObservedObject var AccountProf = AccountProfileViewModel()
    
    var body: some View {
            VStack(spacing: 40){
                VStack{
                    Image(uiImage: AccountProf.getProfPhoto() ?? UIImage(imageLiteralResourceName: "profile_photo_edit"))
                    .frame(width: 40, height: 40)
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
        }
    
}

struct AccountProfile_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileView()
    }
}


