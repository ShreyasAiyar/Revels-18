//
//  HomeHeaderCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

protocol SelectMoreButtonProtocol {
    func selectButtonClicked(currentIndex:Int)
}

class HomeHeaderCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    var currentIndex:Int = 0
    var delegate:SelectMoreButtonProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func seeAllButtonClicked(_ sender: UIButton) {
        self.delegate.selectButtonClicked(currentIndex:currentIndex)
    }
    

}

