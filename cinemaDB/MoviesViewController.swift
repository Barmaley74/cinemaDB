//
//  MoviesViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 22.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterButton: UIButton!
    
    var movies = [Movie]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var page = 1
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        searchBar.delegate = self
        moviesTableView.delegate = self
        moviesTableView.dataSource = self

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadData("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")! as! MovieCell
        cell.movieImage.image = UIImage(named: "blank50_75")
        let thumbnailURLString = self.movies[(indexPath as NSIndexPath).row].poster_path
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.showLabels(self.movies[(indexPath as NSIndexPath).row], image: img)
            cell.movieImage.image = img
        } else {
            cell.showLabels(self.movies[(indexPath as NSIndexPath).row], image: nil)
            self.indexPaths[thumbnailURLString] = indexPath
            api.get(thumbnailURLString, key: "")
        }
        
        if ((indexPath as NSIndexPath).row + 1) == movies.count {
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
                if let cellToUpdate = self.moviesTableView.cellForRow(at: indexPath!) as! MovieCell? {
                    cellToUpdate.movieImage.image = scaledImage
                    self.moviesTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.loading = false
                if self.page == 1 {
                    self.movies = Movie.moviesWithJSON(results as! NSArray)
                } else {
                    let nextMovies = Movie.moviesWithJSON(results as! NSArray)
                    self.movies += nextMovies
                }
                self.moviesTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieIndex = (moviesTableView!.indexPathForSelectedRow! as NSIndexPath).row
        let selectedMovie = self.movies[movieIndex].id

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
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Movies", message: "Choose filter", preferredStyle: UIAlertControllerStyle.alert)
        for field in Config.moviesArray {
            alert.addAction(UIAlertAction(title: field, style: UIAlertActionStyle.default, handler: { alertAction in
                self.filterButton.setTitle(field, for: UIControlState())
                alert.dismiss(animated: true, completion: nil)
                self.page = 1
                self.loadData("")
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadData(_ searchText: String) {
        var urlPath = ""
        if searchText != "" {
            urlPath = "\(Config.apiSearchMovie)?query=\(searchText)&api_key=\(Config.apiKey)"
        } else {
        switch filterButton.currentTitle! {
            case "Voted":
                urlPath = "\(Config.apiDiscoverMovie)?api_key=\(Config.apiKey)&\(Config.sortByVoteAverage)&page=\(page)"
            case "Now playing":
                urlPath = "\(Config.movieNowPlaying)?api_key=\(Config.apiKey)&page=\(page)"
            case "Popular":
                urlPath = "\(Config.moviePopular)?api_key=\(Config.apiKey)&page=\(page)"
            case "Top rated":
                urlPath = "\(Config.movieTopRated)?api_key=\(Config.apiKey)&page=\(page)"
            case "Upcoming":
                urlPath = "\(Config.movieUpcoming)?api_key=\(Config.apiKey)&page=\(page)"
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
    
    @IBAction func unwindToMoviesViewController(_ segue: UIStoryboardSegue) {
        //nothing goes here
    }
    
}

