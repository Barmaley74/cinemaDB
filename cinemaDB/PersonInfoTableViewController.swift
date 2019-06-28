//
//  PersonInfoTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonInfoTableViewController: UITableViewController, APIControllerProtocol {

    @IBOutlet weak var profilePathImage: UIImageView!
    
    @IBOutlet var personDetailsTableView: UITableView!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var personDetailsCell: PersonDetailsCell!
    
    lazy var api : APIController = APIController(delegate: self)
    var id: Int = 0
    var profilePath: String = ""
    var homepageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiPerson)\(self.id)?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "")
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: self.profilePath) != nil {
            DispatchQueue.main.async(execute: {
                // Convert the downloaded data in to a UIImage object
                let data = results as! Data
                let image = UIImage(data: data)
                // Create thumbnails
                let size = image!.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                image!.draw(in: CGRect(origin: CGPoint.zero, size: size))
                let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.profilePathImage.image = scaledImage
            })
        }
        if URL.range(of: Config.apiPerson) != nil {
            DispatchQueue.main.async(execute: {
                let personDetails = PersonDetails.personDetailsWithJSON(results as! NSDictionary)
                self.personDetailsCell.showLabels(personDetails)
                self.homepageURL = personDetails.homepage
                if personDetails.homepage == "" {
                    self.homepageButton.isEnabled = false
                }
                self.profilePath = personDetails.profile_path
                self.api.get(personDetails.profile_path, key:  "")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homepageButtonTapped(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: homepageURL)!)
    }
}
