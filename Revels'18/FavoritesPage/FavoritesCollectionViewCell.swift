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
  var delegate:DidSelectFavoritesProtocol!
  var indexPosition:Int!
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
    let image = dataSource[indexPath.row].catname + " Large"
    cell.favoriteImage.image = UIImage(named: image)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate.didSelectFavorites(outerIndex: indexPosition, innerIndex: indexPath.row)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 120)
  }
}

protocol DidSelectFavoritesProtocol{
  func didSelectFavorites(outerIndex:Int,innerIndex:Int)
}
