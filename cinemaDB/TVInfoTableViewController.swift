//
//  TVInfoTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 09.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVInfoTableViewController: UITableViewController , APIControllerProtocol {
    
    @IBOutlet weak var backdropPathImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterPathImage: UIImageView!
    
    @IBOutlet weak var tvDetailsCell: TVDetailsCell!
    @IBOutlet weak var tvArraysCell: TVArraysCell!
    
    lazy var api : APIController = APIController(delegate: self)
    var id: Int = 0
    var backDropPath: String = ""
    var posterPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiTV)\(self.id)?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "results")
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: self.backDropPath) != nil {
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
                // Store the image in to our cache
                self.backdropPathImage.image = scaledImage
            })
        }
        if URL.range(of: self.posterPath) != nil {
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
                // Store the image in to our cache
                self.posterPathImage.image = scaledImage
            })
        }
        if URL.range(of: Config.apiTV) != nil {
            DispatchQueue.main.async(execute: {
                let tvDetails = TVDetails.tvDetailsWithJSON(results as! NSDictionary)
                self.tvDetailsCell.showLabels(tvDetails)
                self.tvArraysCell.showLabels(tvDetails)
                self.overviewLabel.text = tvDetails.overview
                self.overviewLabel.sizeToFit()
                self.backDropPath = tvDetails.backdrop_path
                self.api.get(tvDetails.backdrop_path, key: "")
                self.posterPath = tvDetails.poster_path
                self.api.get(tvDetails.poster_path, key:  "")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
