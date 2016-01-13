//
//  ListEventsViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class ListEventsViewController: UITableViewController {
    
    var typeListEvents: TypeListEvents = .Year
    var results: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        EventHelper.sharedInstance.requestCalendarPermissions { (granted) -> Void in
            guard granted else {
                let alert = UIAlertView(title: "Calendar Permissions", message: "Please, turn on calendar permissions to access to your calendar.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            
            switch self.typeListEvents {
            case .Year:
                guard let calendars = EventHelper.sharedInstance.getCalendarNamesFromUser() else {
                    return
                }
                self.results = calendars
                self.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results else {
            return 0
        }
        
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if (cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        }
        if let results = results {
            cell!.textLabel!.text = results[indexPath.row]
        }
        //cell!.detailTextLabel!.text = "some text"
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboardMain = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let vcToShow = storyboardMain.instantiateViewControllerWithIdentifier("ListEventsVC") as? ListEventsViewController {
            if let results = results {
                vcToShow.title = results[indexPath.row]
            }
            vcToShow.typeListEvents = .Year
            
            navigationController?.pushViewController(vcToShow, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}