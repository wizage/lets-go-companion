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
    
    var fullData : Dictionary<String, Any>!
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
            let TMCombo = String(describing:fullData["TMName"]!) + "\n" + String(describing:fullData["TMTitle"]!)
            titleView.text = TMCombo
            let imageName = "Bag_TM_" + String(describing:fullData["TMType"]!) + "_Sprite"
            imageView.image = UIImage(imageLiteralResourceName: imageName)
            longTextView.text = String(describing:fullData["TMLocation"]!)
        case "Gift":
            titleView.text = String(describing:fullData["PokemonName"]!)
            imageView.image = UIImage(imageLiteralResourceName: String(describing:fullData["ID"]!) + "MS")
            longTextView.text = "Location: " + String(describing:fullData["Location"]!) + "\nRequirement: " + String(describing:fullData["Requirement"]!)
        case "Trading":
            titleView.text = String(describing:fullData["PokemonName"]!)
            let imageName = String(describing:fullData["ID"]!) + "AMS"
            imageView.image = UIImage(imageLiteralResourceName: imageName)
            longTextView.text = "Location: " + String(describing:fullData["Location"]!) + "\nRequirement: " + String(describing:fullData["Requirement"]!)
        case "Daily":
            titleView.text = String(describing:fullData["DailyEvent"]!)
            imageView.image = UIImage(imageLiteralResourceName: String(describing:fullData["Image"]!))
            longTextView.text = "Location: " + String(describing:fullData["Location"]!) + "\nReward: " + String(describing:fullData["Reward"]!)
        case "MasterTrainer":
            var pokemonLeveler = String(describing:fullData["Pokemon"]!)
            let indexOfSpace = pokemonLeveler.firstIndex(of: " ")
            pokemonLeveler.replaceSubrange(indexOfSpace!..<indexOfSpace!, with: "\n")
            titleView.text = pokemonLeveler
            if (location == 151){
                imageView.image = #imageLiteral(resourceName: "808MS")
            } else if (location == 152){
                imageView.image = #imageLiteral(resourceName: "809MS")
            } else {
                let imageName = String(format: "%03dMS", location!+1)
                imageView.image = UIImage(imageLiteralResourceName: imageName)
            }
            longTextView.text = "Location: " + String(describing:fullData["Location"]!)
        case "Outfit":
            titleView.text = String(describing:fullData["Outfit"]!)
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
