//
//  CategoriesCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
  
    override func awakeFromNib() {
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
      self.layer.shadowOpacity = 0.5
      self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
      self.layer.shadowRadius = 2.0
  
    }
    
}
