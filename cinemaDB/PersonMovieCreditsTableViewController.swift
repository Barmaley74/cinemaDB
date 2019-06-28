//
//  PersonMovieCreditsTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonMovieCreditsTableViewController: UITableViewController, APIControllerProtocol {
    
    var id: Int = 0
    var credits = [PersonMovieCredit]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    
    @IBOutlet var creditsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiPerson)\(id)/movie_credits?api_key=\(Config.apiKey)"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonMovieCreditCell")! as! PersonMovieCreditCell
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
                if let cellToUpdate = self.creditsTableView.cellForRow(at: indexPath!) as! PersonMovieCreditCell? {
                    cellToUpdate.posterImage.image = scaledImage
                    self.creditsTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.credits = PersonMovieCredit.personMovieCreditsWithJSON(results as! NSArray)
                self.creditsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonToMovieSegue" {
            let movieIndex = (creditsTableView!.indexPathForSelectedRow! as NSIndexPath).row
            let selectedMovie = self.credits[movieIndex].id
            
            let movieTabBarController = segue.destination as? UITabBarController
            let navigationControllerInfo = movieTabBarController?.viewControllers![0] as? UINavigationController
            let movieInfoTableViewController = navigationControllerInfo!.topViewController as? MovieInfoTableViewController
            movieInfoTableViewController!.id = selectedMovie
            
            let navigationControllerCredits = movieTabBarController?.viewControllers![1] as? UINavigationController
            let movieCreditsTableViewController = navigationControllerCredits!.topViewController as? MovieCreditsTableViewController
            movieCreditsTableViewController!.id = selectedMovie
            
            let navigationControllerReviews = movieTabBarController?.viewControllers![2] as? UINavigationController
            let movieReviewsTableViewController = navigationControllerReviews!.topViewController as? MovieReviewsTableViewController
            movieReviewsTableViewController!.id = selectedMovie
            
            let navigationControllerMedia = movieTabBarController?.viewControllers![3] as? UINavigationController
            let movieMediaTableViewController = navigationControllerMedia!.topViewController as? TMDBMediaTableViewController
            movieMediaTableViewController!.id = selectedMovie
            movieMediaTableViewController?.typeMedia = Config.apiMovie
            
            let navigationControllerSimilar = movieTabBarController?.viewControllers![4] as? UINavigationController
            let movieSimilarTableViewController = navigationControllerSimilar!.topViewController as? MovieSimilarTableViewController
            movieSimilarTableViewController!.id = selectedMovie
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
