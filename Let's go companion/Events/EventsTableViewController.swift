//
//  EventsTableViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/24/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit
import CoreData

class EventsTableViewController: UITableViewController {
    var eventsTableArray : Array<Dictionary<String, String>>!
    var total : Float = 0
    var completed : Float = 0

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        total = 0
        completed = 0
        self.tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        let headerHeight = 60 + window.safeAreaInsets.top + window.safeAreaInsets.left
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: headerHeight))
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [ UIColor(displayP3Red: 227/255, green: 93/255, blue: 99/255, alpha: 1.0).cgColor,  UIColor(displayP3Red: 146/255, green: 29/255, blue: 34/255, alpha: 1.0).cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        gradientLayer.backgroundColor = UIColor.blue.cgColor
        gradientLayer.type = .axial
        gradientLayer.frame = sectionView.bounds
        sectionView.layer.addSublayer(gradientLayer)
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.bounds.width, height: headerHeight))
        headerLabel.text = "Game Completion"
        headerLabel.textColor = .white
        headerLabel.font = UIFont.preferredFont(forTextStyle: .callout).withSize(25)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let percentLabel = UILabel(frame:CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: headerHeight))
        percentLabel.textColor = .white
        print(total)
        print(completed)
        percentLabel.text = String(format: "%.0f%%", Float(completed)/Float(total)*100)
        percentLabel.font = UIFont.preferredFont(forTextStyle: .callout).withSize(25)
        percentLabel.textAlignment = .right
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerHeaderHorizontalConstraint = NSLayoutConstraint.init(item: headerLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: (window.safeAreaInsets.top + window.safeAreaInsets.left)/3)
        let xPosHeaderConstraint = NSLayoutConstraint.init(item: headerLabel, attribute: .leading, relatedBy: .equal, toItem: sectionView, attribute: .leadingMargin, multiplier: 1, constant: 15)
        let centerPercentHorizontalConstraint = NSLayoutConstraint.init(item: percentLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: (window.safeAreaInsets.top + window.safeAreaInsets.left)/3)
        let xPosPercentConstraint = NSLayoutConstraint.init(item: percentLabel, attribute: .trailing, relatedBy: .equal, toItem: sectionView, attribute: .trailingMargin, multiplier: 1, constant: -15)
        sectionView.addSubview(headerLabel)
        sectionView.addSubview(percentLabel)
        NSLayoutConstraint.activate([centerHeaderHorizontalConstraint, centerPercentHorizontalConstraint, xPosHeaderConstraint, xPosPercentConstraint])
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        return 60 + window.safeAreaInsets.top + window.safeAreaInsets.left
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 100
        } else {
           return 60
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : EventTableViewCell
        var data : Array<NSManagedObject>!
        var count = 0
        if (indexPath.row == 0){
            cell = tableView.dequeueReusableCell(withIdentifier: "daily", for: indexPath) as! EventTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! EventTableViewCell
        }
        cell.titleLabel?.text = eventsTableArray[indexPath.row]["event"]
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate?.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: eventsTableArray[indexPath.row]["eventView"]! + "Object")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            data = try managedContext?.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if (data.count == 0){
            cell.progressBar.progress = 0
            cell.percentLabel.text = "0%"
        } else {
            for cell in data {
                if (cell.value(forKeyPath: "completed") as! Bool){
                    count = count+1
                }
            }
            if (indexPath.row != 0){
                total = total + Float(data.count)
                completed = completed + Float(count)
                //headerLabel.text = String(format: "%.0f%%", Float(completed)/Float(total)*100)
            }
            cell.progressBar.progress = Float(count)/Float(data.count)
            cell.percentLabel.text = String(format: "%.0f%%", Float(count)/Float(data.count)*100)
        }
        cell.progressBar.layer.cornerRadius = 3.5
        cell.progressBar.layer.masksToBounds = true
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
