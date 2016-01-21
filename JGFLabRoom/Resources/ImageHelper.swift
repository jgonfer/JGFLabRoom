//
//  ImageHelper.swift
//  JGFLabRoom
//
//  Created by Josep González on 20/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit


class ImageHelper: NSObject {
    
    var cache = NSCache()
    var objs: [String]?
    
    class var sharedInstance: ImageHelper {
        struct Static {
            static let instance: ImageHelper = ImageHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        cache = NSCache()
        cache.evictsObjectsWithDiscardedContent = true
        cache.delegate = self
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(Utils.GlobalBackgroundQueue, {()in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if var objs = self.objs {
                print("objs != nil")
                if !objs.contains(urlString) {
                    print("objs append")
                    self.objs!.append(urlString)
                }
            } else {
                print("objs == nil")
                self.objs = [urlString]
            }
            
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
                    self.cache.setObject(data!, forKey: urlString, cost: 10)
                    dispatch_async(Utils.GlobalMainQueue, {() in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadTask.resume()
        })
        
    }
    
    func cleanCache() {
        guard let objs = objs else {
            return
        }
        
        for obj: String in objs {
            print("Remove obj: " + obj)
            guard let _ = cache.objectForKey(obj) else {
                continue
            }
            cache.removeObjectForKey(obj)
        }
        self.objs?.removeAll()
    }
}

extension ImageHelper: NSCacheDelegate {
    func cache(cache: NSCache, willEvictObject obj: AnyObject) {
        if let url = obj.key {
            print("url" + url!)
        }
    }
}