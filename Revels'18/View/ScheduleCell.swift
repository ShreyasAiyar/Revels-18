//
//  ScheduleCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 05/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let highlightedImage = UIImage(named: "Favorites")
        favouriteButton.setImage(highlightedImage, for: .selected)
    }


}
