//
//  MovieReviewsTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 03.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieReviewsTableViewController: UITableViewController, APIControllerProtocol {
    
    var id: Int = 0
    var reviews = [MovieReview]()
    var api : APIController!
    
    @IBOutlet var reviewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiMovie)\(id)/reviews?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "results")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieReviewCell")! as! MovieReviewCell
        cell.showLabels(self.reviews[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
            DispatchQueue.main.async(execute: {
                self.reviews = MovieReview.movieReviewsWithJSON(results as! NSArray)
                self.reviewsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(URL(string: reviews[(indexPath as NSIndexPath).row].url)!)
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
