//
//  TVViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TVViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {
    
    @IBOutlet weak var tvsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterButton: UIButton!
    
    var tvs = [TV]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var page = 1
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        searchBar.delegate = self
        tvsTableView.delegate = self
        tvsTableView.dataSource = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadData("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell")! as! TVCell
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
        
        if ((indexPath as NSIndexPath).row + 1) == tvs.count {
            if !loading {
                page += 1
                loadData("")
            }
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
                if let cellToUpdate = self.tvsTableView.cellForRow(at: indexPath!) as! TVCell? {
                    cellToUpdate.tvImage.image = scaledImage
                    self.tvsTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.loading = false
                if self.page == 1 {
                    self.tvs = TV.tvsWithJSON(results as! NSArray)
                } else {
                    let nextTVs = TV.tvsWithJSON(results as! NSArray)
                    self.tvs += nextTVs
                }
                self.tvsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TVDetailsSegue" {
            let tvIndex = (tvsTableView!.indexPathForSelectedRow! as NSIndexPath).row
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
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "TV", message: "Choose filter", preferredStyle: UIAlertControllerStyle.alert)
        for field in Config.tvArray {
            alert.addAction(UIAlertAction(title: field, style: UIAlertActionStyle.default, handler: { alertAction in
                self.filterButton.setTitle(field, for: UIControlState())
                alert.dismiss(animated: true, completion: nil)
                self.loadData("")
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }

    func loadData(_ searchText: String) {
        var urlPath = ""
        if searchText != "" {
            urlPath = "\(Config.apiSearchTV)?query=\(searchText)&api_key=\(Config.apiKey)"
        } else {
            switch filterButton.currentTitle! {
            case "Voted":
                urlPath = "\(Config.apiDiscoverTV)?api_key=\(Config.apiKey)&\(Config.sortByVoteAverage)&page=\(page)"
            case "Popular":
                urlPath = "\(Config.tvPopular)?api_key=\(Config.apiKey)&page=\(page)"
            case "Top Rated":
                urlPath = "\(Config.tvTopRated)?api_key=\(Config.apiKey)&page=\(page)"
            case "On the Air":
                urlPath = "\(Config.tvOnTheAir)?api_key=\(Config.apiKey)&page=\(page)"
            case "Airing Today":
                urlPath = "\(Config.tvAiringToday)?api_key=\(Config.apiKey)&page=\(page)"
            default: break
            }
        }
        loading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.get(urlPath, key: "results")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.page = 1
            loadData("")
        }
    }
    
    
}

