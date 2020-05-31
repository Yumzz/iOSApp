//
//  ItemDetailsViewController.swift
//  ARMenu
//
//  Created by Sally Gao on 2/26/20.
//  Copyright © 2020 CS5150-ARMenu. All rights reserved.
//

import UIKit
import CloudKit

class ItemDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var viewARButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var dish: Dish?
    var reviews: [Review] = []
    var reviewUsers: [ARMUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = dish?.name
        descriptionLabel.text = dish?.description
        descriptionLabel.sizeToFit()
        
        let price = dish!.price
        let strPrice = price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price)
        priceLabel.text = "Price: $" + strPrice
        
        let file : CKAsset? = dish?.coverPhoto
        let data = NSData(contentsOf: (file?.fileURL!)!)
        let img = UIImage(data: data! as Data)
        itemImage.image = img
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        if dish?.model == nil {
            viewARButton.isEnabled = false
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        if (KeychainItem.currentUserIdentifier == nil) {
            self.performSegue(withIdentifier: "AddReviewLogin", sender: self)
        } else {
            self.performSegue(withIdentifier: "AddReview", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customActivityIndicator(self.view)
        DispatchQueue.main.async {
            let newDish = db.fetchDish(recordID: self.dish!.id.recordName)
            self.dish = newDish
            
            let data = db.fetchDishReviews(d: self.dish!)
            self.reviews = data
            
            for review in self.reviews {
                let user = db.fetchReviewUser(review: review)
                self.reviewUsers.append(user)
            }
            
            self.reviewsTableView.reloadData()
            if self.reviews == [] {
                self.emptyState(message: "No reviews yet... Add yours!")
            } else {
                self.reviewsTableView.backgroundView = nil
                self.reviewsTableView.separatorStyle = .singleLine
            }
            removeActivityIndicator(self.view)
        }
    }
    
    func emptyState(message:String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        reviewsTableView.backgroundView = messageLabel;
        reviewsTableView.separatorStyle = .none;
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addReview" {
            guard let reviewViewController = segue.destination as? AddReviewViewController
                else {
                    return
            }
            reviewViewController.dish = dish
            print("sent")
        }
        
        guard let viewController = segue.destination as? ViewController
            else {
                return
        }
        viewController.dish = dish
        
    }
    
}

extension ItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count == 0 {
            return 0
        }
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        let user = reviewUsers[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewTableViewCell
        
        cell.headlineLabel.text = review.headLine
        cell.reviewTextLabel.text = review.description
        cell.reviewTextLabel.sizeToFit()
        cell.usernameLabel.text = user.userName
        if user.profilePhoto != nil {
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2
            let imageAsset: CKAsset? = user.profilePhoto
            let data = NSData(contentsOf: (imageAsset?.fileURL!)!)
            let img = UIImage(data: data! as Data)
            cell.profileImageView.image = img
        } else {
            cell.profileImageView.image = UIImage(named: "Image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
