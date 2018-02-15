//
//  FavoritesCollectionViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
  
  var dataSource:[Schedules] = []
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    self.layer.cornerRadius = 5
  }
}

extension FavoritesCollectionViewCell:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFavoritesCollectionCell", for: indexPath) as! NewFavoritesCollectionViewCell
    cell.eventName.text = dataSource[indexPath.row].ename
    cell.favoriteImage.image = UIImage(named: dataSource[indexPath.row].catname)
    return cell
  }
  
  

}
