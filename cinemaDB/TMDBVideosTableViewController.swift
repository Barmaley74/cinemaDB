//
//  TMDBVideosTableViewController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 06.06.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import UIKit

class TMDBVideosTableViewController: UITableViewController {

    var videos = [TMDBVideo]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell")! as! TMDBVideoCell
        if videos.count > 0 {
            cell.nameLabel.text = videos[(indexPath as NSIndexPath).row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if videos[(indexPath as NSIndexPath).row].site == "YouTube" {
            let url = "https://www.youtube.com/watch?v=\(videos[(indexPath as NSIndexPath).row].key)"
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }

}
