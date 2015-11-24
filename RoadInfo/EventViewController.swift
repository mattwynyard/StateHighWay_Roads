//
//  EventViewController.swift
//  RoadInfo
//
//  Created by Matt Wynyard on 21/11/15.
//  Copyright © 2015 Niobium. All rights reserved.
//

import UIKit

class EventViewController: UITableViewController {
    
    var event: RoadEvent!
    var items: [String]?

    //@IBOutlet weak var cell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        if let e = event {
            print(e)
            items = event.getEventDetails()
            print(items)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        items = event.getEventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: "cell")
        cell.textLabel?.text = items![indexPath.row]
        //cell.selectionStyle = UITableViewCellSelectionStyleNone
        
        cell.textLabel?.numberOfLines = 0
        if indexPath.row % 2 == 0 {
            let altCellColor: UIColor  = UIColor(white:0.7, alpha:0.1)
            cell.backgroundColor = altCellColor
        }
        if indexPath.row == 4 {
            cell.textLabel?.text = "Expected Resolution"
            cell.detailTextLabel?.text  = items![indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(18.0)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(16.0)
        }
        return cell
    }
    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    
//    }

    /*
    // MARK: - Navigatio

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
