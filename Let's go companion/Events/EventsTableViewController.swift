//
//  EventsTableViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/24/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    var eventsTableArray : Array<Dictionary<String, String>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsTableURL = Bundle.main.url(forResource: "events", withExtension: "plist")
        let eventsTableData = try! Data(contentsOf: eventsTableURL!)
        eventsTableArray = try! PropertyListSerialization.propertyList(from: eventsTableData, options: [], format: nil) as! Array<Dictionary<String, String>>
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return eventsTableArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = eventsTableArray[indexPath.row]["event"]
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "eventClick"{
            let destination = segue.destination as? SingleEventCollectionViewController
            destination?.title = eventsTableArray[(tableView.indexPathForSelectedRow?.row)!]["event"]
            destination?.eventView = eventsTableArray[(tableView.indexPathForSelectedRow?.row)!]["eventView"]
        }
    }

}
