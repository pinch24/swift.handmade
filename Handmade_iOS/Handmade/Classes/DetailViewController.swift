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
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var showReleaseNoteButton: UIButton!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        //print(serviceItem)
        
        // Screenshots ScrollView
        imageScrollView.imageUrlList = serviceItem.screenshotUrls
        
        // Contents View
        trackNameLabel.text = serviceItem.trackName
        artistNameLabel.text = serviceItem.sellerName
        
        // 포맷터(가격, 파일 크기)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // 가격
        if serviceItem.formattedPrice.contains("무료") {
            
            priceLabel.text = "무료"
        }
        else {
            
            let price = Int(serviceItem.price)
            
            if let formattedNumber = formatter.string(from: NSNumber(value: price)) {
                
                let string = NSMutableAttributedString(string: "\(formattedNumber) 원")
                
                let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let range = NSRange(location: string.length - 1, length: 1)
                string.addAttributes(attribute, range: range)
                
                priceLabel.attributedText = string
            }
        }
        
        // 파일 크기
        let fileSize = Int(serviceItem.fileSizeBytes)
        let mbSize = (fileSize ?? 0) / 1024 / 1024
        
        if let formatterSize = formatter.string(from: NSNumber(value: mbSize)) {
            
            fileSizeLabel.text = "\(formatterSize)MB"
        }
        
        // 연령
        contentRatingLabel.text = serviceItem.trackContentRating
        
        // 새로운 기능: 버전
        versionLabel.text = serviceItem.version
        
        // 새로운 기능: 내용
        releaseNoteLabel.text = serviceItem.releaseNotes
        //releaseNoteLabel.isHidden = true
        var frame = releaseNoteLabel.frame
        frame.size.height = 0.0
        releaseNoteLabel.frame = frame
        
        // 카테고리
        descriptionTextView.text = serviceItem.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        
        // Set Main ScrollView
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 200)
        
        // Set Image ScrollView
        if let list = imageScrollView.imageUrlList {
            
            let contentWidth = list.count * imageScrollView.imageSpace + 10     // 10: 컨텐츠 사이즈 오른쪽 끝 여백
            imageScrollView.contentSize = CGSize(width: contentWidth, height: imageScrollView.height)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func releastNoteButtonTouchUpInside(_ sender: UIButton) {
        
        //releaseNoteLabel.isHidden = !sender.isSelected
        if sender.isSelected {
            
            var frame = releaseNoteLabel.frame
            frame.size.height = 0.0
            releaseNoteLabel.frame = frame
        }
        else {
            
            var frame = releaseNoteLabel.frame
            frame.size.height = 41.0
            releaseNoteLabel.frame = frame
        }
        
        sender.isSelected = !sender.isSelected
    }
    
}


class ImageScrollView: UIScrollView {
    
    let imageSpace = 219    // 219 = Image Space(10) + Image Width(209)
    
    var x = 10, y = 10
    var width = 209, height = 352
    
    var imageUrlList: [String]? = nil {
        
        didSet {
            
            update()
        }
    }
    
    func update() {
        
        if let list = imageUrlList {    // 옵셔널 해제하지 않으면 맵 처리 되지 않음
            
            let _ = list.map({ (string) in
                
                let frame = CGRect(x: x, y: y, width: width, height: height)
                let imageView = UIImageView(frame: frame)
                
                if let url = URL(string: string) {
                    
                    do {
                        
                        let data = try Data(contentsOf: url)
                        imageView.image = UIImage(data: data)
                    }
                    catch let error {
                        
                        print(error)
                    }
                }
                
                imageView.contentMode = .scaleAspectFit
                addSubview(imageView)
                
                x += imageSpace
            })
        }
    }
}
