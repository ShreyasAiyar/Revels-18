//
//  WorkshopsCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 15/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class WorkshopsCell: UICollectionViewCell {
  
  @IBOutlet weak var workshopName: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var name: UILabel!
  var delegate:WorkshopsFunctions!
  var position:Int?

  @IBAction func didSelectInfoButton(_ sender: Any) {
    self.delegate.selectedInfoButton(position:position!)
  }
  
  
  @IBAction func didSelectCallButton(_ sender: Any) {
    self.delegate.selectedCallButton(position:position!)
  }
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
  }

}

protocol WorkshopsFunctions{
  func selectedInfoButton(position:Int)
  func selectedCallButton(position:Int)
}
