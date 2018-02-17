//
//  ScheduleCollectionViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var favouriteButton: UIButton!
  @IBOutlet weak var categoryImage: UIImageView!
  var eid:String?
  
  var delegate:AddToFavoritesProtocol!

  override func awakeFromNib() {
    let highlightedImage = UIImage(named: "BlurFavorites")
    favouriteButton.setImage(highlightedImage, for: .selected)
    location.layer.cornerRadius = 2
    location.clipsToBounds = true
    layer.cornerRadius = 5
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    self.layer.shadowRadius = 4.0
  }
  
  @IBAction func didSelectFavoritesButton(_ sender: UIButton) {
    if favouriteButton.isSelected == true{
      print("Selected")
      favouriteButton.isSelected = false
      self.delegate.removeFromFavorites(eid: self.eid!)
    }
    else{
      print("Not Selected")
      favouriteButton.isSelected = true
      self.delegate.addToFavorites(eid: self.eid!)
    }
  }
  
}

protocol AddToFavoritesProtocol{
  func addToFavorites(eid:String)
  func removeFromFavorites(eid:String)
}
