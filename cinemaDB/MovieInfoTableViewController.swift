//
//  MovieInfoTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 01.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieInfoTableViewController: UITableViewController, APIControllerProtocol {

    @IBOutlet weak var backdropPathImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterPathImage: UIImageView!

    @IBOutlet weak var movieDetailsCell: MovieDetailsCell!
    @IBOutlet weak var movieArraysCell: MovieArraysCell!
    
    lazy var api : APIController = APIController(delegate: self)
    var id: Int = 0
    var backDropPath: String = ""
    var posterPath: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiMovie)\(self.id)?api_key=\(Config.apiKey)"
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
                self.posterPathImage.image = scaledImage
            })
        }
        if URL.range(of: Config.apiMovie) != nil {
            DispatchQueue.main.async(execute: {
                let movieDetails = MovieDetails.movieDetailsWithJSON(results as! NSDictionary)
                self.movieDetailsCell.showLabels(movieDetails)
                self.movieArraysCell.showLabels(movieDetails)
                self.overviewLabel.text = movieDetails.overview
                self.overviewLabel.sizeToFit()
                self.backDropPath = movieDetails.backdrop_path
                self.api.get(movieDetails.backdrop_path, key: "")
                self.posterPath = movieDetails.poster_path
                self.api.get(movieDetails.poster_path, key:  "")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
