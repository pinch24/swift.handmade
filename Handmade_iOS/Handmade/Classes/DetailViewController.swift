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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var contentRatingLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var showReleaseNoteButton: UIButton!
    @IBOutlet weak var releaseNoteTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var categoryView: CategoryView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "핸드메이드"
        
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
        releaseNoteTextView.text = serviceItem.releaseNotes
        // 새로운 기능 내용 숨김 처리
        releastNoteButtonTouchUpInside(showReleaseNoteButton)
        
        // 설명
        descriptionTextView.text = serviceItem.description
        let text = serviceItem.description
        let splitText = text.components(separatedBy: "\n")
        
        if splitText.count < 10 {

            descriptionTextView.text = text
        }
        else {

            descriptionTextView.text = splitText[0 ... 9].joined(separator: "\n")
            descriptionTextView.text.append("\n\n...")
        }
        
        // 카테고리
        categoryView.genreList = serviceItem.genres
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
    
    // UIButton Actions
    @IBAction func showButtonTouchUpInside(_ sender: UIButton) {
        
        let trackViewUrl = serviceItem.trackViewUrl     //.replacingOccurrences(of: "?uo=4", with: "")
        
        if let url = URL(string: trackViewUrl) {
            
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender: UIButton) {
        
        let trackViewUrl = serviceItem.trackViewUrl
        let items = [trackViewUrl]
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.excludedActivityTypes = []
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func releastNoteButtonTouchUpInside(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            if sender.isSelected {
                
                // Hidden ReleaseNote
                let height = self.releaseNoteTextView.frame.size.height
                
                self.scrollView.contentSize.height -= height
                self.descriptionTextView.frame.origin.y -= height
                self.contentView.frame.size.height -= height
                self.categoryView.frame.origin.y -= height
                
                self.releaseNoteTextView.frame.size.height = 0
            }
            else {
                
                // Show ReleaseNote
                let size = self.releaseNoteTextView.sizeThatFits(CGSize(width: self.releaseNoteTextView.frame.size.width, height: self.releaseNoteTextView.frame.size.height))
                self.releaseNoteTextView.frame.size.height = size.height
                
                self.scrollView.contentSize.height += size.height
                self.descriptionTextView.frame.origin.y += size.height
                self.contentView.frame.size.height += size.height
                self.categoryView.frame.origin.y += size.height
            }
        })
        
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

class CategoryView: UIView {
    
    var x = 8, y = 54
    
    var genreList: [String]? = nil {
        
        didSet {
            
            update()
        }
    }
    
    func update() {
        
        if let list = genreList {    // 옵셔널 해제하지 않으면 맵 처리 되지 않음
            
            let _ = list.map({ (string) in
                
                let text = "  #\(string)  "
                let textWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]).width
                
                let frame = CGRect(x: x, y: y, width: Int(textWidth), height: 22)
                let label = UILabel(frame: frame)
                label.text = text
                label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1) // 200, 200, 200
                label.font = UIFont.systemFont(ofSize: 12)
                label.cornerRadius = 2
                label.borderWidth = 1
                label.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1) // 200, 200, 200
                addSubview(label)
                
                x = Int(frame.maxX) + 8
            })
        }
    }
}
