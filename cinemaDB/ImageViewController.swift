//
//  ImageViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 06.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, APIControllerProtocol {

    var api : APIController!
    var imageURL: String = ""
    
    @IBOutlet weak var viewedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.get(imageURL, key: "")
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String) {
        if URL.range(of: self.imageURL) != nil {
            DispatchQueue.main.async(execute: {
                // Convert the downloaded data in to a UIImage object
                let data = results as! Data
                let image = UIImage(data: data)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.viewedImage.image = image
            })
        }
    }
    
}
