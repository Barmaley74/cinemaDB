//
//  TVSimilarTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 11.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVSimilarTableViewController: UITableViewController, APIControllerProtocol {
    
    @IBOutlet weak var tvTableView: UITableView!
    
    var id: Int = 0
    var tvs = [TV]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiTV)\(id)/similar?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "results")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVSimilarCell")! as! TVSimilarCell
        cell.tvImage.image = UIImage(named: "blank50_75")
        let thumbnailURLString = self.tvs[(indexPath as NSIndexPath).row].poster_path
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.showLabels(self.tvs[(indexPath as NSIndexPath).row], image: img)
            cell.tvImage.image = img
        } else {
            cell.showLabels(self.tvs[(indexPath as NSIndexPath).row], image: nil)
            self.indexPaths[thumbnailURLString] = indexPath
            api.get(thumbnailURLString, key: "")
        }
        
        return cell
    }
    
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: Config.apiImageURL) != nil {
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
            self.imageCache[URL] = scaledImage
            // Update the cell
            DispatchQueue.main.async(execute: {
                let indexPath = self.indexPaths[URL]
                if let cellToUpdate = self.tvTableView.cellForRow(at: indexPath!) as! TVSimilarCell? {
                    cellToUpdate.tvImage.image = scaledImage
                    self.tvTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.tvs = TV.tvsWithJSON(results as! NSArray)
                self.tvTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SimilarToTVSegue" {
            let tvIndex = (tvTableView!.indexPathForSelectedRow! as NSIndexPath).row
            let selectedTV = self.tvs[tvIndex].id
        
            let tvTabBarController = segue.destination as? UITabBarController
            let navigationControllerInfo = tvTabBarController?.viewControllers![0] as? UINavigationController
            let tvInfoTableViewController = navigationControllerInfo!.topViewController as? TVInfoTableViewController
            tvInfoTableViewController!.id = selectedTV
        
            let navigationControllerCredits = tvTabBarController?.viewControllers![1] as? UINavigationController
            let tvCreditsTableViewController = navigationControllerCredits!.topViewController as? TVCreditsTableViewController
            tvCreditsTableViewController!.id = selectedTV
        
            let navigationControllerMedia = tvTabBarController?.viewControllers![2] as? UINavigationController
            let tvMediaTableViewController = navigationControllerMedia!.topViewController as? TMDBMediaTableViewController
            tvMediaTableViewController!.id = selectedTV
            tvMediaTableViewController?.typeMedia = Config.apiTV
        
            let navigationControllerSimilar = tvTabBarController?.viewControllers![3] as? UINavigationController
            let tvSimilarTableViewController = navigationControllerSimilar!.topViewController as? TVSimilarTableViewController
            tvSimilarTableViewController!.id = selectedTV
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}


