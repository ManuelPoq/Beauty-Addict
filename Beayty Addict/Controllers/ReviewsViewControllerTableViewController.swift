//
//  ReviewsViewControllerTableViewController.swift
//  Beayty Addict
//
//  Created by Dan  Tatar on 23/09/2018.
//  Copyright © 2018 Dany. All rights reserved.
//

import UIKit
import Firebase

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var productReviews: Product?
    
    var reviews = [Reviews]()
    
    func createReview(newReview: String) {
        productReviews?.review.append(newReview)

        print(productReviews?.review)
 
    }
       var cellID = "CellID"
    
        let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
        layoutSubviews()
        tableView.backgroundColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-150)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: cellID)
        
        retrieveData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ReviewCell
//        cell?.review.text = productReviews?.review[indexPath.row]
        cell?.review.text = reviews[indexPath.row].review

        
        cell?.backgroundColor = UIColor(red: 240/255, green: 239/255, blue: 241/255, alpha: 1)
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return productReviews?.review.count ?? 1
        return reviews.count
    }
    
    var addReviewButton : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(red: 240/255, green: 111/255, blue: 107/255, alpha: 1)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action:  #selector(review), for: .touchUpInside)
        return button
    }()
    
    @objc func review() {
        let popup = AddReviewViewController()
        // At presentation time of your AddReviewController, set property with correct value (the presenter)
        popup.reviewsVC = self
        popup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popup.doneSaving =
            { [weak self] in

            self?.tableView.reloadData()

        }
       self.present(popup, animated: true)
    }
    
    // Retrieve reviews from the Firebsse database
    func retrieveData() {
        
        let reviewDB = Database.database().reference().child("Reviews")
        
        reviewDB.observe(.childAdded, with: { (snapshot) in
            let snapShotValue = snapshot.value as? Dictionary<String, String>
            let product = snapShotValue?["Product"]!
            let rev = snapShotValue?["review"]!
            let name = snapShotValue?["name"]!
            let rating = snapShotValue?["rating"]!
            
            print(product, rev)
            
            if product == self.productReviews?.name {
            let newReview = Reviews(name: product!, review: rev!)
            self.reviews.append(newReview)
            self.tableView.reloadData()
        
            }
        })
    }
    
    // Setup autolayout
    func layoutSubviews() {
        
        view.addSubview(addReviewButton)
        
        addReviewButton.rightAnchor.constraint(equalTo: view.rightAnchor , constant: -15).isActive = true
        addReviewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        addReviewButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addReviewButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
