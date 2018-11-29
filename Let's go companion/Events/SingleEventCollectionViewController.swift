//
//  SingleEventCollectionViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/24/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit
import CoreData

class SingleEventCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var eventView : String!
    var appDelegate : AppDelegate!
    var data : Array<NSManagedObject>!
    var singleEventTableArray : Array<Dictionary<String, String>>!
    var sorted = false
    var completed : Array<NSManagedObject> = []
    var notcompleted : Array<NSManagedObject> = []
    var layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: eventView + "Object")
        let sort = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        
        
        do {
            data = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let singleEventTableURL = Bundle.main.url(forResource: eventView + "View", withExtension: "plist")
        let singleEventTableData = try! Data(contentsOf: singleEventTableURL!)
        singleEventTableArray = try! PropertyListSerialization.propertyList(from: singleEventTableData, options: [], format: nil) as! Array<Dictionary<String, String>>
        
        if (data.count == 0){
            let entity = NSEntityDescription.entity(forEntityName: eventView + "Object", in: managedContext)
            var i = 0;
            for _ in singleEventTableArray{
                let entry = NSManagedObject(entity: entity!, insertInto: managedContext)
                entry.setValue(false, forKey: "completed")
                entry.setValue(i, forKey: "index")
                i = i + 1
            }
            do {
                try managedContext.save()
                data = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else if (data.count < singleEventTableArray.count){
            //Fix shit
        }
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        
        if (screenWidth > screenHeight){
            layout.sectionInset = UIEdgeInsets(top: 10, left: (screenHeight - 300)/3, bottom: 10, right: (screenHeight - 300)/3)
        } else {
            layout.sectionInset = UIEdgeInsets(top: 10, left: (screenWidth - 300)/3, bottom: 10, right: (screenWidth - 300)/3)
        }
 
        //layout.sectionInset = UIEdgeInsets(top: 10, left: (screenWidth - 300)/3, bottom: 10, right: (screenWidth - 300)/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 150, height: 150)
        collectionView!.collectionViewLayout = layout
        
        sortItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }
    
    func sortItems(){
        for item in data {
            if (item.value(forKeyPath: "completed") as! Bool){
                completed.append(item)
            } else {
                notcompleted.append(item)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if (sorted){
            return 2
        }
        else {
            return 1
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if (sorted && section == 0){
            return notcompleted.count
        } else if (sorted && section == 1) {
            return completed.count
        } else {
            return singleEventTableArray.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionViewCell
        var indexOfObject = indexPath.row
        if (sorted && indexPath.section == 0){
            indexOfObject = notcompleted[indexPath.row].value(forKeyPath: "index") as! Int
        } else if (sorted && indexPath.section == 1){
            indexOfObject = completed[indexPath.row].value(forKeyPath: "index") as! Int
        }
        switch eventView {
        case "TMCollection":
            let TMCombo = singleEventTableArray[indexOfObject]["TMName"]! + "\n" + singleEventTableArray[indexOfObject]["TMTitle"]!
            cell.titleLabel.text = TMCombo
            let imageName = "Bag_TM_" + singleEventTableArray[indexOfObject]["TMType"]! + "_Sprite"
            cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
        case "Gift":
            cell.titleLabel.text = singleEventTableArray[indexOfObject]["PokemonName"]
            cell.imageView.image = UIImage(imageLiteralResourceName: singleEventTableArray[indexOfObject]["ID"]! + "MS")
        case "Trading":
            cell.titleLabel.text = singleEventTableArray[indexOfObject]["PokemonName"]
            let imageName = singleEventTableArray[indexOfObject]["ID"]! + "AMS"
            cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
            
        case "Daily":
            cell.titleLabel.text = singleEventTableArray[indexOfObject]["DailyEvent"]
            cell.imageView.image = UIImage(imageLiteralResourceName: singleEventTableArray[indexOfObject]["Image"]!)
        case "MasterTrainer":
            var pokemonLeveler = singleEventTableArray[indexOfObject]["Pokemon"]
            let indexOfSpace = pokemonLeveler?.firstIndex(of: " ")
            pokemonLeveler?.replaceSubrange(indexOfSpace!..<indexOfSpace!, with: "\n")
            cell.titleLabel.text = pokemonLeveler
            if (indexOfObject == 151){
                cell.imageView.image = #imageLiteral(resourceName: "808MS")
            } else if (indexOfObject == 152){
                cell.imageView.image = #imageLiteral(resourceName: "809MS")
            } else {
                let imageName = String(format: "%03dMS", indexOfObject+1)
                cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
            }
        case "Outfit":
            cell.titleLabel.text = singleEventTableArray[indexOfObject]["Outfit"]
        default:
            cell.titleLabel.text = "Error"
        }
        if(data![indexOfObject].value(forKeyPath: "completed") as! Bool){
            cell.selectedMark.setImage(#imageLiteral(resourceName: "greenCheck"), for: .normal)
            cell.selectedMark.checked = true
        } else {
            cell.selectedMark.setImage(#imageLiteral(resourceName: "greyCheck"), for: .normal)
            cell.selectedMark.checked = false
        }
        cell.selectedMark.addTarget(self, action:#selector(markComplete), for: .touchUpInside)
        //cell.titleLabel.sizeToFit()
        cell.titleLabel.textAlignment = .center
        
        // Configure the cell
    
        return cell
    }

    
    @objc func markComplete(_ sender:CheckButton){
        
        guard let cell = sender.superview?.superview as? EventCollectionViewCell else {
            return // or fatalError() or whatever
        }
        let location = collectionView.indexPath(for: cell)
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var dataObject : NSManagedObject
        if (!sorted){
            dataObject = data![(location?.row)!]
        } else if (location?.section == 0 && sorted){
            dataObject = notcompleted[(location?.row)!]
        } else if (location?.section == 1 && sorted){
            dataObject = completed[(location?.row)!]
        } else {
            print("Shouldn't be here")
            return
        }
        dataObject.setValue(!sender.checked, forKey: "completed")
        
        do {
            try managedContext.save()
            if (sorted && location?.section == 0){
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [location!])
                    let index = dataObject.value(forKey: "index") as! Int
                    let insertIndex = completed.index(where: { $0.value(forKey: "index") as! Int > index })
                    completed.insert(dataObject, at: insertIndex ?? completed.count)
                    notcompleted.remove(at: location!.row)
                    collectionView.insertItems(at: [IndexPath.init(item: insertIndex ?? completed.count-1, section: 1)])
                }, completion: nil)
            } else if (sorted && location?.section == 1){
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [location!])
                    let index = dataObject.value(forKey: "index") as! Int
                    let insertIndex = notcompleted.index(where: { $0.value(forKey: "index") as! Int > index })
                    notcompleted.insert(dataObject, at: insertIndex ?? notcompleted.count)
                    completed.remove(at: location!.row)
                    collectionView.insertItems(at: [IndexPath.init(item: insertIndex ?? notcompleted.count-1, section: 0)])
                }, completion: nil)
            } else if (sender.checked){
                let index = dataObject.value(forKey: "index") as! Int
                let insertIndex = notcompleted.index(where: { $0.value(forKey: "index") as! Int > index })
                notcompleted.insert(dataObject, at: insertIndex ?? notcompleted.count)
                completed.removeAll(where: {$0.value(forKey: "index") as! Int == location!.row})
            } else if (!sender.checked){
                let index = dataObject.value(forKey: "index") as! Int
                let insertIndex = completed.index(where: { $0.value(forKey: "index") as! Int > index })
                completed.insert(dataObject, at: insertIndex ?? completed.count)
                notcompleted.removeAll(where: {$0.value(forKey: "index") as! Int == location!.row})
            }
            sender.checked = !sender.checked
            if(dataObject.value(forKeyPath: "completed") as! Bool){
                sender.setImage(#imageLiteral(resourceName: "greenCheck"), for: .normal)
            } else {
                sender.setImage(#imageLiteral(resourceName: "greyCheck"), for: .normal)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize{
        if (sorted){
            return CGSize(width:self.collectionView.frame.size.width, height:50)
        } else {
            return CGSize(width:0, height:0)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSection", for: indexPath) as! EventSectionHeaderView
        if (indexPath.section == 0){
            sectionHeader.sectionTitle.text = "Not Completed"
        } else {
            sectionHeader.sectionTitle.text = "Completed"
        }
        
        return sectionHeader
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "DetailSelect"{
            self.modalPresentationStyle = .currentContext
            let selectedView = collectionView.indexPath(for: sender as! EventCollectionViewCell)
            
            let dest = segue.destination as! DetailsViewController
            if (sorted && selectedView?.section == 0){
                dest.eventObject = notcompleted[selectedView!.row]
            } else if (sorted && selectedView?.section == 1) {
                dest.eventObject = completed[selectedView!.row]
            } else {
                dest.eventObject = data![selectedView!.row]
            }
            dest.fullData = singleEventTableArray[dest.eventObject.value(forKey: "index") as! Int]
            dest.eventView = eventView
        }
    }
    
    @IBAction func sort(){
        if (!sorted){
            collectionView.performBatchUpdates({
                sorted = !sorted
                collectionView.deleteItems(at: completed.map {IndexPath(item: $0.value(forKeyPath: "index") as! Int, section: 0)})
                collectionView.insertSections(IndexSet.init(integer: 1))
                collectionView.insertItems(at: (0..<completed.count).map {IndexPath(item: $0, section: 1)})
            }, completion: nil)
        } else {
            collectionView.performBatchUpdates({
                sorted = !sorted
                collectionView.insertItems(at: completed.map {IndexPath(item: $0.value(forKeyPath: "index") as! Int, section: 0)})
                collectionView.deleteSections(IndexSet.init(integer: 1))
                collectionView.deleteItems(at: (0..<completed.count).map {IndexPath(item: $0, section: 1)})
            }, completion: nil)
        }
        
        
        //collectionView.reloadData()
    }
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
