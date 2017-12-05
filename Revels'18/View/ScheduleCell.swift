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
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
