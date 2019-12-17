//
//  DetailViewController.swift
//  Handmade
//
//  Created by mk on 2019/12/18.
//  Copyright © 2019 mk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var serviceItem: ServiceItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        print(serviceItem)
        
        trackNameLabel.text = serviceItem.trackName
        artistNameLabel.text = serviceItem.sellerName
        priceLabel.text = serviceItem.formattedPrice
        
        fileSizeLabel.text = serviceItem.fileSizeBytes
        contentRatingLabel.text = serviceItem.trackContentRating
        versionLabel.text = serviceItem.version
        
        releaseNoteLabel.text = serviceItem.releaseNotes
        descriptionTextView.text = serviceItem.description
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 200)
        imageScrollView.contentSize = CGSize(width: imageScrollView.frame.width * 2, height: imageScrollView.frame.height)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
