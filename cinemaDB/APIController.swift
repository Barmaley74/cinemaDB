//
//  APIController.swift
//  cinemaDB
//
//  Created by Serhiy Vlasevych on 22.02.16.
//  Copyright © 2016 Neo. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String)
}

class APIController {
    
    var delegate: APIControllerProtocol
    var resultKeys = [String:String]()
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(_ path: String, key: String) {
        resultKeys[path] = key

        if let url = URL(string: path) {
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request, completionHandler: handlerGet)
            task.resume()
        }
    
    }
    
    func handlerGet (_ data: Data?, response: URLResponse?, error: Error?) {
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
            let URL = httpResponse.url!.absoluteString as String
            print(URL)
            if (httpResponse.statusCode == 404) {
                print(Messages.pageNotFound)
                return
            }
            if (httpResponse.statusCode == 200 && data != nil) {
                let key = resultKeys[URL]
            do {
                if URL.range(of: Config.apiImageURL) != nil {
                    self.delegate.didReceiveAPIResults(data! as AnyObject, URL: URL, key: key!)
                } else {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    if jsonResult != nil {
                        if let results: NSArray = jsonResult![key!] as? NSArray {
                            self.delegate.didReceiveAPIResults(results, URL: URL, key: key!)
                        } else {
                            let dict: NSDictionary = jsonResult! as NSDictionary
                            self.delegate.didReceiveAPIResults(dict, URL: URL, key: "")
                        }
                    }
                }
            } catch {
                print(Messages.fetchFailed+"\((error as NSError).localizedDescription)")
            }
            } else {
                print(Messages.dataNil)
                self.delegate.didReceiveAPIResults(data! as AnyObject, URL: URL, key: "")
            }
        } else {
            print(Messages.serverNotAvailable)
            return
        }
    }
    
}

