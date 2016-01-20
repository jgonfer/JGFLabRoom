//
//  EventViewController.swift
//  JGFLabRoom
//
//  Created by Josep Gonzalez Fernandez on 13/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class EventViewController: UITableViewController {
    
    var results = ["Insert event", "List of events"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.registerStandardXibForTableView(tableView, name: "cell")
        Utils.cleanBackButtonTitle(navigationController)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let vcToShow = segue.destinationViewController as? ListEventsViewController else {
            return
        }
        
        vcToShow.typeListEvents = .Calendar
        vcToShow.title = TypeListEvents.getTitles(.Calendar)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
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
        cell!.textLabel!.text = results[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell?.accessoryType = .None
        default:
            cell?.accessoryType = .DisclosureIndicator
            break
        }
        
        //cell!.detailTextLabel!.text = "some text"
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            setupCalendarForInsertEvent()
        case 1:
            performSegueWithIdentifier(kSegueIdListEvents, sender: tableView)
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCalendarForInsertEvent() {
        EventHelper.sharedInstance.requestCalendarPermissions { (granted) -> Void in
            if granted {
                self.insertEvent(EKEventStore())
            } else {
                print("Access denied")
            }
        }
    }
    
    func insertEvent(store: EKEventStore) {
        //let calendars = store.calendarsForEntityType(.Event) as! [EKCalendar]
        
        let startDate = NSDate()
        
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        
        event.title = "JGFLabRoom: Event Test"
        event.startDate = startDate
        event.endDate = startDate
        
        let controller = EKEventEditViewController()
        controller.eventStore = store
        controller.event = event
        controller.editViewDelegate = self
        
        do {
            try store.saveEvent(event, span: .ThisEvent)
        } catch let specError as NSError {
            print("A specific error occurred: \(specError)")
        } catch {
            print("An error occurred")
        }
    }
}

// MARK: Event Delegate
extension EventViewController: EKEventEditViewDelegate {
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        
    }
}