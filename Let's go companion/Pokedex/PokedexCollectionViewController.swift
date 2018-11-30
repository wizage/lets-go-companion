//
//  PokedexCollectionViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/25/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class PokedexCollectionViewController: UICollectionViewController {
    
    var pokedexArray : Array<Dictionary<String, Any>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pokedexURL = Bundle.main.url(forResource: "PokedexView", withExtension: "plist")
        let pokedexData = try! Data(contentsOf: pokedexURL!)
        pokedexArray = try! PropertyListSerialization.propertyList(from: pokedexData, options: [], format: nil) as! Array<Dictionary<String, Any>>

        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
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
        //Minus 18 to deal with alolan types
        return pokedexArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EventCollectionViewCell
    
        cell.titleLabel.text = pokedexArray[indexPath.row]["PokemonName"] as? String
        
        // Configure the cell
    
        return cell
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
