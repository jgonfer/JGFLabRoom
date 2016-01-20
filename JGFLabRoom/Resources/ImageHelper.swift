//
//  ImageHelper.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit


class ImageHelper {
    
    var cache = NSCache()
    
    class var sharedInstance: ImageHelper {
        struct Static {
            static let instance: ImageHelper = ImageHelper()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(Utils.GlobalBackgroundQueue, {()in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(Utils.GlobalMainQueue, {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    dispatch_async(Utils.GlobalMainQueue, {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadTask.resume()
        })
        
    }
}