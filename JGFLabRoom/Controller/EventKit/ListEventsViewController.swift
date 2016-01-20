//
//  ListEventsViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class ListEventsViewController: UITableViewController {
    
    let reuseIdentifier = "EventCell"
    
    var typeListEvents: TypeListEvents = .Year
    var identifier: String?
    var results: [[String:String]]?
    var resultsSorted: [[[String:String]]]?
    var months: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.registerCustomXibForTableView(tableView, name: reuseIdentifier)
        Utils.cleanBackButtonTitle(navigationController)
        
        EventHelper.sharedInstance.requestCalendarPermissions { (granted) -> Void in
            guard granted else {
                let alert = UIAlertView(title: "Calendar Permissions", message: "Please, turn on calendar permissions to access to your calendar.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            
            switch self.typeListEvents {
            case .Calendar:
                guard let calendars = EventHelper.sharedInstance.getCalendarNamesFromUser() else {
                    return
                }
                self.results = calendars
                self.tableView.reloadData()
            case .Year:
                guard let identifier = self.identifier else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    return
                }
                EventHelper.sharedInstance.getEventYearsFromUser(identifier, completion: { (years) -> () in
                    self.results = years
                    self.tableView.reloadData()
                })
            case .Event:
                guard let identifier = self.identifier else {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    return
                }
                EventHelper.sharedInstance.getEventsFromUser(identifier, year: Int(self.title!)!, completion: { (events) -> () in
                    self.results = events
                    let monthsResult = Utils.getMonthsArraysForEvents(events)
                    self.months = monthsResult.months
                    self.resultsSorted = monthsResult.eventsSorted
                    self.tableView.reloadData()
                })
            default:
                break
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let results = results else {
            return 1
        }
        guard results.count > 0 else {
            return 1
        }
        let result = results[0]
        guard let _ = result["date"] else {
            return 1
        }
        guard let months = months else {
            return 1
        }
        return months.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let months = months else {
            return ""
        }
        return months[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let results = results else {
            return 0
        }
        let result = results[indexPath.row]
        guard let _ = result["date"] else {
            return 55
        }
        return 75
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results else {
            return 0
        }
        guard let resultsSorted = resultsSorted else {
            return results.count
        }
        return resultsSorted[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let result = results![indexPath.row]
        guard let dateString = result["date"] else {
            let reuseIdentifier = "cell"
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
            if (cell != nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
            }
            cell!.textLabel!.text = result["title"]
            if let count = result["events"] {
                cell!.detailTextLabel!.text = count + " events"
            }
            cell?.accessoryType = .DisclosureIndicator
            return cell!
        }
        
        var cell: EventCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? EventCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier) as? EventCell
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.dateFromString(dateString) {
            let monthResults = resultsSorted![indexPath.section]
            let todayResult = monthResults[indexPath.row]
            cell?.setupCell(todayResult["title"], date: date)
            cell?.accessoryType = .None
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboardMain = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let vcToShow = storyboardMain.instantiateViewControllerWithIdentifier("ListEventsVC") as? ListEventsViewController {
            if let results = results {
                let result = results[indexPath.row]
                switch self.typeListEvents {
                case .Calendar:
                    vcToShow.typeListEvents = .Year
                case .Year:
                    vcToShow.typeListEvents = .Event
                case .Event:
                    return
                default:
                    break
                }
                vcToShow.identifier = result["identifier"]
                vcToShow.title = result["title"]
            }
            
            navigationController?.pushViewController(vcToShow, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
