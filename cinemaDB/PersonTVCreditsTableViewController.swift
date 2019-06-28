//
//  PersonTVCreditsTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonTVCreditsTableViewController: UITableViewController, APIControllerProtocol {
    
    var id: Int = 0
    var credits = [PersonTVCredit]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    
    @IBOutlet var creditsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiPerson)\(id)/tv_credits?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "cast")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTVCreditCell")! as! PersonTVCreditCell
        cell.posterImage.image = UIImage(named: "blank67_100")
        let thumbnailURLString = self.credits[(indexPath as NSIndexPath).row].poster_path
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.showLabels(self.credits[(indexPath as NSIndexPath).row], image: img)
            cell.posterImage.image = img
        } else {
            cell.showLabels(self.credits[(indexPath as NSIndexPath).row], image: nil)
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
                if let cellToUpdate = self.creditsTableView.cellForRow(at: indexPath!) as! PersonTVCreditCell? {
                    cellToUpdate.posterImage.image = scaledImage
                    self.creditsTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.credits = PersonTVCredit.personTVCreditsWithJSON(results as! NSArray)
                self.creditsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonToTVSegue" {
            let tvIndex = (creditsTableView!.indexPathForSelectedRow! as NSIndexPath).row
            let selectedTV = self.credits[tvIndex].id
            
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
