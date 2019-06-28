//
//  PersonImagesCollectionViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 08.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonImagesCollectionViewController: UICollectionViewController, APIControllerProtocol {
    
    @IBOutlet weak var personImagesCollecionView: UICollectionView!
    
    var id: Int = 0

    var images = [PersonImage]()
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var api : APIController!
    var imagePathForView : String = ""
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlPath = "\(Config.apiPerson)\(id)/images?api_key=\(Config.apiKey)"
        api.get(urlPath, key: "profiles")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: "images") != nil {
            DispatchQueue.main.async(execute: {
                    self.images = PersonImage.personImagesWithJSON(results as! NSArray)
                    self.personImagesCollecionView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            let indexPath = self.indexPaths[URL]
                // Update the cell
                DispatchQueue.main.async(execute: {
                    if let cellToUpdate = self.personImagesCollecionView.cellForItem(at: indexPath!) as! PersonImageCell? {
                        cellToUpdate.personImage.image = scaledImage
                        self.personImagesCollecionView.reloadData()
                    }
                })
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonImageCell", for: indexPath) as! PersonImageCell
            cell.personImage.image = UIImage(named: "blank150_225")
        
            let thumbnailURLString = self.images[(indexPath as NSIndexPath).row].file_path
            // If this image is already cached, don't re-download
            if let img = imageCache[thumbnailURLString] {
                cell.personImage.image = img
            } else {
                if self.indexPaths[thumbnailURLString] == nil {
                    self.indexPaths[thumbnailURLString] = indexPath
                    api.get(thumbnailURLString, key: "")
                }
            }
            return cell
    }
    
    override func collectionView(_ collecionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let personImage = images[(indexPath as NSIndexPath).row]
        imagePathForView = personImage.file_path
        self.performSegue(withIdentifier: "PersonImageViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonImageViewSegue" {
            let navigationController = segue.destination as? UINavigationController
            let imageViewController = navigationController!.topViewController as? ImageViewController
            imageViewController!.imageURL = self.imagePathForView
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
