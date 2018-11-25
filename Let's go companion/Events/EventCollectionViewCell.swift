//
//  EventCollectionViewself.swift
//  Let's go companion
//
//  Created by Sam Patzer on 11/24/18.
//  Copyright © 2018 wizage. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var selectedMark : CheckButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.contentView.layer.cornerRadius = 10.0;
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.borderColor = UIColor.clear.cgColor;
        self.contentView.layer.masksToBounds = true;
        self.backgroundColor = .white
        self.layer.cornerRadius = 20.0;
        
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.5;
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20.0).cgPath
    }
}
