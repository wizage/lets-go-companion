//
//  DetailsViewController.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/25/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    var fullData : Dictionary<String, String>!
    var eventView : String!
    var eventObject : NSManagedObject!
    var location : Int?
    
    @IBOutlet var popoverView : UIView!
    @IBOutlet var longTextView : UITextView!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleView : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch eventView {
        case "TMCollection":
            let TMCombo = fullData["TMName"]! + "\n" + fullData["TMTitle"]!
            titleView.text = TMCombo
            let imageName = "Bag_TM_" + fullData["TMType"]! + "_Sprite"
            imageView.image = UIImage(imageLiteralResourceName: imageName)
            longTextView.text = fullData["TMLocation"]
        case "Gift":
            titleView.text = fullData["PokemonName"]
            imageView.image = UIImage(imageLiteralResourceName: fullData["ID"]! + "MS")
            longTextView.text = "Location: " + fullData["Location"]! + "\nRequirement: " + fullData["Requirement"]!
        case "Trading":
            titleView.text = fullData["PokemonName"]
            let imageName = fullData["ID"]! + "AMS"
            imageView.image = UIImage(imageLiteralResourceName: imageName)
            longTextView.text = "Location: " + fullData["Location"]! + "\nRequirement: " + fullData["Requirement"]!
        case "Daily":
            titleView.text = fullData["DailyEvent"]
            imageView.image = UIImage(imageLiteralResourceName: fullData["Image"]!)
            longTextView.text = "Location: " + fullData["Location"]! + "\nReward: " + fullData["Reward"]!
        case "MasterTrainer":
            var pokemonLeveler = fullData["Pokemon"]
            let indexOfSpace = pokemonLeveler?.firstIndex(of: " ")
            pokemonLeveler?.replaceSubrange(indexOfSpace!..<indexOfSpace!, with: "\n")
            titleView.text = pokemonLeveler
            if (location == 151){
                imageView.image = #imageLiteral(resourceName: "808MS")
            } else if (location == 152){
                imageView.image = #imageLiteral(resourceName: "809MS")
            } else {
                let imageName = String(format: "%03dMS", location!+1)
                imageView.image = UIImage(imageLiteralResourceName: imageName)
            }
            longTextView.text = "Location: " + fullData["Location"]!
        case "Outfit":
            titleView.text = fullData["Outfit"]
        default:
            titleView.text = "Error"
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPopover(){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
