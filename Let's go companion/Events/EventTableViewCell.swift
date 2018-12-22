//
//  EventTableViewCell.swift
//  Let's go companion
//
//  Created by Sam Patzer on 12/21/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var percentLabel : UILabel!
    @IBOutlet var progressBar: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
