//
//  PersonsViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 07.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class PersonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, UISearchBarDelegate {
    
    @IBOutlet weak var personsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var persons = [Person]()
    var api : APIController!
    var imageCache = [String:UIImage]()
    var indexPaths = [String:IndexPath]()
    var page = 1
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        searchBar.delegate = self
        personsTableView.delegate = self
        personsTableView.dataSource = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadData("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")! as! PersonCell
        cell.personImage.image = UIImage(named: "blank50_75")
        let thumbnailURLString = self.persons[(indexPath as NSIndexPath).row].profile_path
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.showLabels(self.persons[(indexPath as NSIndexPath).row], image: img)
            cell.personImage.image = img
        } else {
            cell.showLabels(self.persons[(indexPath as NSIndexPath).row], image: nil)
            self.indexPaths[thumbnailURLString] = indexPath
            api.get(thumbnailURLString, key: "")
        }
        
        if ((indexPath as NSIndexPath).row + 1) == persons.count {
            if !loading {
                page += 1
                loadData("")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PersonDetailsSegue", sender: self)
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
                if let cellToUpdate = self.personsTableView.cellForRow(at: indexPath!) as! PersonCell? {
                    cellToUpdate.personImage.image = scaledImage
                    self.personsTableView.reloadData()
                }
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.loading = false
                if self.page == 1 {
                    self.persons = Person.personsWithJSON(results as! NSArray)
                } else {
                    let nextPersons = Person.personsWithJSON(results as! NSArray)
                    self.persons += nextPersons
                }
                
                self.personsTableView!.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PersonDetailsSegue" {
            let personIndex = (personsTableView!.indexPathForSelectedRow! as NSIndexPath).row
            let selectedPerson = self.persons[personIndex].id
        
            let personTabBarController = segue.destination as? UITabBarController
            let navigationControllerInfo = personTabBarController?.viewControllers![0] as? UINavigationController
            let personInfoTableViewController = navigationControllerInfo!.topViewController as? PersonInfoTableViewController
            personInfoTableViewController!.id = selectedPerson

            let navigationControllerMovieCredits = personTabBarController?.viewControllers![1] as? UINavigationController
            let personMovieCreditsTableViewController = navigationControllerMovieCredits!.topViewController as? PersonMovieCreditsTableViewController
            personMovieCreditsTableViewController!.id = selectedPerson

            let navigationControllerTVCredits = personTabBarController?.viewControllers![2] as? UINavigationController
            let personTVCreditsTableViewController = navigationControllerTVCredits!.topViewController as? PersonTVCreditsTableViewController
            personTVCreditsTableViewController!.id = selectedPerson

            let navigationControllerImages = personTabBarController?.viewControllers![3] as? UINavigationController
            let personImagesCollectionViewController = navigationControllerImages!.topViewController as? PersonImagesCollectionViewController
            personImagesCollectionViewController!.id = selectedPerson
        }

    }
    
    func loadData(_ searchText: String) {
        var urlPath = ""
        if searchText != "" {
            urlPath = "\(Config.apiSearchPerson)?query=\(searchText)&api_key=\(Config.apiKey)"
        } else {
            urlPath = "\(Config.apiPersonPopular)?api_key=\(Config.apiKey)&page=\(page)"
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
