//
//  TVCreditsTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 10.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVCreditsTableViewController: UITableViewController , APIControllerProtocol {
    
    var id: Int = 0
    var credits = [TVCredit]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    
    @IBOutlet var creditsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiTV)\(id)/credits?api_key=\(Config.apiKey)"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCreditCell")! as! TVCreditCell
        cell.profileImage.image = UIImage(named: "blank67_100")
        let thumbnailURLString = self.credits[(indexPath as NSIndexPath).row].profile_path
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.showLabels(self.credits[(indexPath as NSIndexPath).row], image: img)
            cell.profileImage.image = img
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
                if let cellToUpdate = self.creditsTableView.cellForRow(at: indexPath!) as! TVCreditCell? {
                    cellToUpdate.profileImage.image = scaledImage
                    self.creditsTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.credits = TVCredit.tvCreditsWithJSON(results as! NSArray)
                self.creditsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TVToPersonSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TVToPersonSegue" {
            let personIndex = (creditsTableView.indexPathForSelectedRow! as NSIndexPath).row
            let selectedPerson = self.credits[personIndex].id
            let personTabBarController = segue.destination as? UITabBarController
            
            let navigationInfoController = personTabBarController?.viewControllers![0] as? UINavigationController
            let personInfoTableViewController = navigationInfoController!.topViewController as? PersonInfoTableViewController
            personInfoTableViewController!.id = selectedPerson
            
            let navigationMovieController = personTabBarController?.viewControllers![1] as? UINavigationController
            let personMovieTableViewController = navigationMovieController!.topViewController as? PersonMovieCreditsTableViewController
            personMovieTableViewController!.id = selectedPerson
            
            let navigationTVController = personTabBarController?.viewControllers![2] as? UINavigationController
            let personTVTableViewController = navigationTVController!.topViewController as? PersonTVCreditsTableViewController
            personTVTableViewController!.id = selectedPerson
            
            let navigationImagesController = personTabBarController?.viewControllers![3] as? UINavigationController
            let personImagesCollectionViewController = navigationImagesController!.topViewController as? PersonImagesCollectionViewController
            personImagesCollectionViewController!.id = selectedPerson
        }        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
