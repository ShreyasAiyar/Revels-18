//
//  ResultsCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ResultsCell: UICollectionViewCell {
  
  @IBOutlet weak var roundNo: UILabel!
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var categoryImage: UIImageView!
  @IBOutlet weak var teamID: UILabel!
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    self.layer.shadowRadius = 4.0
  }
}
