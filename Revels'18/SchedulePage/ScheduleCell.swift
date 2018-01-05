//
//  ScheduleCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 05/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell{
    

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    var eid:String!
    
    var delegate:AddToFavoritesProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let highlightedImage = UIImage(named: "BlurFavorites")
        favouriteButton.setImage(highlightedImage, for: .selected)
        location.layer.cornerRadius = 2
        location.clipsToBounds = true
    }
    
    @IBAction func favoritesButtonClicked(_ sender: UIButton) {
        favouriteButton.isSelected = true
        //self.delegate.addToFavorites(eid: self.eid)
    }
}

protocol AddToFavoritesProtocol{
    func addToFavorites(eid:String)
}
