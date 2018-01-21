//
//  FavoritesHeaderView.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 20/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class FavoritesHeaderView: UICollectionReusableView {
        
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var clearButton: UIButton!
  var day:Int?
  var delegate:RemoveDayFromFavoritesProtocol!

  
  @IBAction func didSelectClearButton(_ sender: UIButton) {
    print(day!)
    self.delegate!.removeDayFromFavorites(day: day!)
  }

}

protocol RemoveDayFromFavoritesProtocol{
  func removeDayFromFavorites(day:Int)
}
