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
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
    self.categoryImage.layer.cornerRadius = categoryImage.frame.height/2
    categoryImage.layer.borderWidth = 2
    categoryImage.layer.borderColor = UIColor.black.cgColor
    categoryImage.layer.masksToBounds = true
    //self.backgroundColor = UIColor.red
    
  }
}
