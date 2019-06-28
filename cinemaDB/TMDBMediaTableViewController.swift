//
//  TMDBMediaTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 04.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TMDBMediaTableViewController: UITableViewController, APIControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var postersCollecionView: UICollectionView!
    @IBOutlet weak var backdropsCollectionView: UICollectionView!
    
    @IBOutlet weak var videosTableView: UITableView!
    var id: Int = 0
    var backdrops = [TMDBImage]()
    var posters = [TMDBImage]()
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var api : APIController!
    var imagePathForView : String = ""
    var typeMedia = Config.apiMovie

    let videosController = TMDBVideosTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postersCollecionView.delegate = self
        postersCollecionView.dataSource = self
        backdropsCollectionView.delegate = self
        backdropsCollectionView.dataSource = self

        self.videosTableView.delegate = videosController
        self.videosTableView.dataSource = videosController
        
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var urlPath = "\(typeMedia)\(id)/images?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "posters")
        urlPath = "\(typeMedia)\(id)/videos?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "results")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: "images") != nil {
            DispatchQueue.main.async(execute: {
                if key == "posters" {
                    self.posters = TMDBImage.tmdbImagesWithJSON(results as! NSArray)
                    self.postersCollecionView.reloadData()
                    let urlPath = "\(self.typeMedia)\(self.id)/images?api_key=\(Config.apiKey)"
                    self.api.get(urlPath, key: "backdrops")
                } else {
                    self.backdrops = TMDBImage.tmdbImagesWithJSON(results as! NSArray)
                    self.backdropsCollectionView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
        }
        if URL.range(of: "videos") != nil {
            DispatchQueue.main.async(execute: {
                self.videosController.videos = TMDBVideo.tmdbVideosWithJSON(results as! NSArray)
                self.videosTableView.reloadData()
            })
        }
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

            if key == "posters" {
                // Update the cell
                DispatchQueue.main.async(execute: {
                    let indexPath = self.indexPaths[URL]
                    if let cellToUpdate = self.postersCollecionView.cellForItem(at: indexPath!) as! TMDBPosterCell? {
                        cellToUpdate.posterImage.image = scaledImage
                        self.postersCollecionView.reloadData()
                    }
                })
            } else {
                // Update the cell
                DispatchQueue.main.async(execute: {
                    let indexPath = self.indexPaths[URL]
                    if let cellToUpdate = self.backdropsCollectionView.cellForItem(at: indexPath!) as! TMDBBackdropCell? {
                        cellToUpdate.backdropImage.image = scaledImage
                        self.backdropsCollectionView.reloadData()
                    }
                })
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == postersCollecionView {
            return posters.count
        } else {
            return backdrops.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == postersCollecionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! TMDBPosterCell
            cell.posterImage.image = UIImage(named: "blank100_140")

            let thumbnailURLString = self.posters[(indexPath as NSIndexPath).row].file_path
            // If this image is already cached, don't re-download
            if let img = imageCache[thumbnailURLString] {
                cell.posterImage.image = img
            } else {
                if self.indexPaths[thumbnailURLString] == nil {
                    self.indexPaths[thumbnailURLString] = indexPath
                    api.get(thumbnailURLString, key: "posters")
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackdropCell", for: indexPath) as! TMDBBackdropCell
            cell.backdropImage.image = UIImage(named: "blank250_140")
            let thumbnailURLString = self.backdrops[(indexPath as NSIndexPath).row].file_path
            // If this image is already cached, don't re-download
            if let img = imageCache[thumbnailURLString] {
                cell.backdropImage.image = img
            } else {
                if self.indexPaths[thumbnailURLString] == nil {
                    self.indexPaths[thumbnailURLString] = indexPath
                    api.get(thumbnailURLString, key: "backdrops")
                }
            }
            return cell
        }
    }

    func collectionView(_ collecionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieImage: TMDBImage
        if collecionView == postersCollecionView {
            movieImage = posters[(indexPath as NSIndexPath).row]
        } else {
            movieImage = backdrops[(indexPath as NSIndexPath).row]
        }
        imagePathForView = movieImage.file_path
        self.performSegue(withIdentifier: "ImageViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageViewSegue" {
            let navigationController = segue.destination as? UINavigationController
            let imageViewController = navigationController!.topViewController as? ImageViewController
            imageViewController!.imageURL = self.imagePathForView
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
