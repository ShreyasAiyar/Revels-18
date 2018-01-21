//
//  NewHomeViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 09/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class NewHomeViewCell: UICollectionViewCell {
  
  @IBOutlet weak var homeLabel: UILabel!

  
  override var isHighlighted: Bool{
    didSet{
      self.alpha = 0.5
    }
  }
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
  }
  
  
  
}
