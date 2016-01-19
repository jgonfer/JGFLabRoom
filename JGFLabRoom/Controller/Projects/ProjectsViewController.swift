//
//  ProjectsViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 15/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController {
    
    var typeListEvents: TypeListEvents = .Year
    var identifier: String?
    var results = [
        ["title": "Slide Me!", "url": "https://itunes.apple.com/app/id1061794183", "img": "http://jgonfer.com/images/slider/portfolio/11.jpg"],
        ["title": "TaxiMés", "url": "https://itunes.apple.com/app/id1061794183", "img": "http://jgonfer.com/images/portfolio/taximes.jpg"],
        ["title": "TaxiClick", "url": "https://itunes.apple.com/app/id1061794183", "img": "http://jgonfer.com/images/portfolio/taxiclick.jpg"],
        ["title": "Animal Conga: Mountains", "url": "https://itunes.apple.com/app/id1061794183", "img": "http://jgonfer.com/images/portfolio/animal_conga_mountains.jpg"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 225
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
            let project = self.results[indexPath.row]
            if let url = NSURL(string: project["img"]!) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let imageView = UIImageView(frame: cell!.frame)
                    imageView.image = image
                    cell?.imageView?.image = image
                }
            }
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        let storyboardMain = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let vcToShow = storyboardMain.instantiateViewControllerWithIdentifier("ListEventsVC") as? ListEventsViewController {
            if let results = results {
                let result = results[indexPath.row]
                switch self.typeListEvents {
                case .Calendar:
                    vcToShow.typeListEvents = .Year
                case .Year:
                    vcToShow.typeListEvents = .Event
                default:
                    break
                }
                vcToShow.identifier = result["identifier"]
                vcToShow.title = result["title"]
            }
            
            navigationController?.pushViewController(vcToShow, animated: true)
        }
        */
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}