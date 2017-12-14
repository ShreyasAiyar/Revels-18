//
//  NewHomeViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 09/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class NewHomeViewCell: UICollectionViewCell {

    @IBOutlet weak var homeLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        self.layer.cornerRadius = 5
    }
    
}
