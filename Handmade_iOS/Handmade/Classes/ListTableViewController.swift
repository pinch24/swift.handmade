//
//  ListTableViewController.swift
//  Handmade
//
//  Created by mk on 2019/12/18.
//  Copyright © 2019 mk. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var serviceList: ServiceList? = nil {
        
        didSet {
            
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceList?.results.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceItemCell", for: indexPath) as! ServiceItemCell
        cell.index = indexPath.row
        
        if let item = serviceList?.results[indexPath.row] {
            
            if let url = URL(string: item.artworkUrl512) {
                
                do {
                    
                    let data = try Data(contentsOf: url)
                    cell.serviceImage.image = UIImage(data: data)
                }
                catch let error {
                    
                    print(error)
                }
            }
            
            cell.serviceLabel.text = item.trackName
            cell.licenseLabel.text = item.sellerName
            
            cell.categoryLabel.text = item.genres.joined(separator: ", ")
            cell.priceLabel.text = item.formattedPrice
            
            // 별점
            if let rating = item.averageUserRating {
                
                // 별점 표시
                cell.ratingView.rating = Double(rating)
                cell.ratingView.isHidden = false
            }
            else {
                
                // 별점 없음
                cell.ratingView.isHidden = true
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! ServiceItemCell
        
        if let index = cell.index {
            
            let item = serviceList?.results[index]
            
            let viewController = segue.destination as! DetailViewController
            viewController.serviceItem = item
        }
    }

}

class ServiceItemCell: UITableViewCell {
    
    var index: Int!
    
    @IBOutlet weak var serviceImage: UIImageView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var ratingView: StarRatingView!
}
