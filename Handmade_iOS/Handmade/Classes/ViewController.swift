//
//  ViewController.swift
//  Handmade
//
//  Created by mk on 2019/12/17.
//  Copyright © 2019 mk. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    var serviceList: ServiceList?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // JSON from File
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let object = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//
//                if let json = object as? Dictionary<String, AnyObject>,
//                    let resultCount = json["resultCount"] as? Int,
//                    let results = json["results"] as? [Any] {
//
//                    print("Count: \(resultCount)")
//                    print("Results: \(results)")
//                }
//                else {
//
//                    print("No Results")
//                }
                
                serviceList = try JSONDecoder().decode(ServiceList.self, from: data)
                //print("JSON Decoder: \(serviceList)")
                
                // Show List Table View Controller
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "ListTableViewControllerSegue", sender: self)
                }
            }
            catch let error {
                
                print(error)
            }
        }
        
        
//        // Json from URL
//        let urlString = "https://itunes.apple.com/search?term=핸드메이드&country=kr&media=software"
//        let escapeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
//
//        if let url = URL(string: escapeString) {
//
//            URLSession.shared.dataTask(with: url) { data, response, error in
//
//                if let data = data {
//
//                    do {
//
//                        let res = try JSONDecoder().decode(Response.self, from: data)
//                        print(res.resultCount)
//                    }
//                    catch let error {
//
//                        print(error)
//                    }
//                }
//            }.resume()
//        }
        
//        let json = ""
//        let startIndex = json.index(json.startIndex, offsetBy: 205166)
//        let endIndex = json.index(startIndex, offsetBy: 100)
//        print("\(startIndex): " + json[startIndex ... endIndex])
//
//        let data = json.data(using: String.Encoding.unicode)!
//
//        do {
//
//            let res = try JSONDecoder().decode(Response.self, from: data)
//            print(res.resultCount)
//        }
//        catch let error {
//
//            print(error)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "ListTableViewControllerSegue":
            let viewController = segue.destination as! ListTableViewController
            viewController.serviceList = serviceList
            
        default:
            break
        }
    }
}

struct ServiceList: Codable {
    
    let resultCount: Int
    let results: [ServiceItem]
}

struct ServiceItem: Codable {
    
    var screenshotUrls: [String]
    var ipadScreenshotUrls: [String]
    var appletvScreenshotUrls: [String]
    
    var isGameCenterEnabled: Bool
    
    var artworkUrl512: String
    var artworkUrl100: String
    var artistViewUrl: String
    
    var supportedDevices: [String]
    
    var advisories: [String]
    var kind: String
    var features: [String]
    var trackCensoredName: String
    
    var languageCodesISO2A: [String]
    var fileSizeBytes: String
    var sellerUrl: String?
    var averageUserRatingForCurrentVersion: Float?
    var userRatingCountForCurrentVersion: Int?
    
    var trackViewUrl: String
    var trackContentRating: String
    var contentAdvisoryRating: String
    var minimumOsVersion: String
    var releaseNotes: String?
    
    var isVppDeviceBasedLicensingEnabled: Bool
    
    var primaryGenreName: String
    var genreIds: [String]
    var primaryGenreId: Int
    var formattedPrice: String
    var trackName: String
    var trackId: Int
    
    var currentVersionReleaseDate: String
    var releaseDate: String
    var sellerName: String
    var currency: String
    var version: String
    var wrapperType: String
    
    var artistId: Int
    var artistName: String
    var genres: [String]
    var price: Float
    var description: String
    
    var bundleId: String
    var averageUserRating: Float?
    var userRatingCount: Int?
}
