//
//  MovieGenresController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 12.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class MovieGenresController: UIViewController , UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    @IBOutlet weak var genresButton: UIButton!
    
    var movies = [Movie]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var genres = [Genre]()
    var page = 1
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiGenresList)?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "genres")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGenreCell")! as! MovieGenreCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
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
                if let cellToUpdate = self.moviesTableView.cellForRow(at: indexPath!) as! MovieGenreCell? {
                    cellToUpdate.movieImage.image = scaledImage
                    self.moviesTableView.reloadData()
                }
            })
            return
        }
        if URL.range(of: Config.apiGenresList) != nil  {
            DispatchQueue.main.async(execute: {
                self.genres = Genre.genresWithJSON(results as! NSArray)
                var genre = UserDefaults.standard.string(forKey: "genre")
                if genre == nil {
                    genre = self.genres[0].name
                    UserDefaults.standard.set(genre, forKey: "genre")
                    UserDefaults.standard.synchronize()
                }
                self.genresButton.setTitle(genre, for: UIControlState())
                self.loadData(genre!)
            })
            return
        }
        if URL.range(of: Config.apiGenre) != nil  {
                DispatchQueue.main.async(execute: {
                self.loading = false
                if self.page == 1 {
                    self.movies = Movie.moviesWithJSON(results as! NSArray)
                } else {
                    let nextMovies = Movie.moviesWithJSON(results as! NSArray)
                    self.movies += nextMovies
                    print(self.movies.count)
                }
                self.moviesTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            return
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
    
    @IBAction func genresButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Genres", message: "Choose genre", preferredStyle: UIAlertControllerStyle.alert)
        for field in genres {
            alert.addAction(UIAlertAction(title: field.name, style: UIAlertActionStyle.default, handler: { alertAction in
                self.genresButton.setTitle(field.name, for: UIControlState())
                UserDefaults.standard.set(field.name, forKey: "genre")
                UserDefaults.standard.synchronize()
                alert.dismiss(animated: true, completion: nil)
                self.loadData(field.name)
            }))
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadData(_ genre: String) {
        var id = genres[0].id
        for field in genres {
            if field.name == genre {
                id = field.id
            }
        }
        let urlPath = "\(Config.apiGenre)\(id)/movies?api_key=\(Config.apiKey)&page=\(page)"
        loading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.get(urlPath, key: "results")
    }
    
}

