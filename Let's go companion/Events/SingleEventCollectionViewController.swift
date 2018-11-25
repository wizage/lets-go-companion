//
//  SingleEventCollectionViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/24/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit
import CoreData

class SingleEventCollectionViewController: UICollectionViewController {
    var eventView : String!
    var appDelegate : AppDelegate!
    var data : Array<NSManagedObject>!
    var singleEventTableArray : Array<Dictionary<String, String>>!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: eventView + "Object")
        
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

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return singleEventTableArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EventCollectionViewCell
        
        switch eventView {
        case "TMCollection":
            let TMCombo = singleEventTableArray[indexPath.row]["TMName"]! + "\n" + singleEventTableArray[indexPath.row]["TMTitle"]!
            cell.titleLabel.text = TMCombo
            let imageName = "Bag_TM_" + singleEventTableArray[indexPath.row]["TMType"]! + "_Sprite"
            cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
        case "Gift":
            cell.titleLabel.text = singleEventTableArray[indexPath.row]["PokemonName"]
            cell.imageView.image = UIImage(imageLiteralResourceName: singleEventTableArray[indexPath.row]["ID"]! + "MS")
        case "Trading":
            cell.titleLabel.text = singleEventTableArray[indexPath.row]["PokemonName"]
        case "Daily":
            cell.titleLabel.text = singleEventTableArray[indexPath.row]["DailyEvent"]
            //Replace with an array lookup #duh
            switch indexPath.row {
            case 0:
                cell.imageView.image = #imageLiteral(resourceName: "079MS")
            case 1:
                print("to do")
            case 2:
                print("to do")
            case 3:
                cell.imageView.image = #imageLiteral(resourceName: "050MS")
            case 4:
                print("to do")
            case 5:
                print("to do")
            case 6:
                print("to do")
            case 7:
                print("to do")
            case 8:
                print("to do")
            default:
                print("error")
            }
        case "MasterTrainer":
            var pokemonLeveler = singleEventTableArray[indexPath.row]["Pokemon"]
            let indexOfSpace = pokemonLeveler?.firstIndex(of: " ")
            pokemonLeveler?.replaceSubrange(indexOfSpace!..<indexOfSpace!, with: "\n")
            cell.titleLabel.text = pokemonLeveler
            if (indexPath.row == 151){
                cell.imageView.image = #imageLiteral(resourceName: "808MS")
            } else if (indexPath.row == 152){
                cell.imageView.image = #imageLiteral(resourceName: "809MS")
            } else {
                let imageName = String(format: "%03dMS", indexPath.row+1)
                cell.imageView.image = UIImage(imageLiteralResourceName: imageName)
            }
        case "Outfit":
            cell.titleLabel.text = singleEventTableArray[indexPath.row]["Outfit"]
        default:
            cell.titleLabel.text = "Error"
        }
        cell.selectedMark.tag = indexPath.row
        if(data![indexPath.row].value(forKeyPath: "completed") as! Bool){
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
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        data![sender.tag].setValue(!sender.checked, forKey: "completed")
        do {
            try managedContext.save()
            sender.checked = !sender.checked
            if(data![sender.tag].value(forKeyPath: "completed") as! Bool){
                sender.setImage(#imageLiteral(resourceName: "greenCheck"), for: .normal)
            } else {
                sender.setImage(#imageLiteral(resourceName: "greyCheck"), for: .normal)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
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
