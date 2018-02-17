//
//  RevelsCupCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 15/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class RevelsCupCell: UICollectionViewCell {
    
  @IBOutlet weak var sportName: UILabel!
  @IBOutlet weak var sportTime: UILabel!
  @IBOutlet weak var teamID1: UILabel!
  @IBOutlet weak var sportDate: UILabel!
  @IBOutlet weak var teamID2: UILabel!
  @IBOutlet weak var sportVenue: UILabel!
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    self.layer.shadowRadius = 4.0
  }
  
}
