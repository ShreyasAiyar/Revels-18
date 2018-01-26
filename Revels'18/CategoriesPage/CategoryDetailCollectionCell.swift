//
//  CategoryDetailCollectionCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class CategoryDetailCollectionCell: UICollectionViewCell {
  
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var categoryImage: UIImageView!
  
  override func awakeFromNib() {
    categoryImage.layer.cornerRadius = categoryImage.bounds.height/2
    categoryImage.layer.borderWidth = 2
    categoryImage.layer.borderColor = UIColor.black.cgColor
    categoryImage.layer.masksToBounds = true
  }
}
