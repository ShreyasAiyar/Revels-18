//
//  HomeViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 08/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var dataSource:[String] = []
  var section:Int?
  var delegate:HomePageSelectionProtocol?
}

extension HomeViewCell: UICollectionViewDataSource,UICollectionViewDelegate{
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(dataSource.count > 10){
      return 10
    }
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! NewHomeViewCell
    cell.homeLabel.text = dataSource[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.alpha = 0.5
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.alpha = 1
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if(section! == 0){
      delegate?.selectedSchedule(indexPosition: indexPath.row)
    }
    if(section! == 1){
      delegate?.selectedCategories(indexPosition: indexPath.row)
    }
    if(section! == 2){
      delegate?.selectedResults(indexPosition: indexPath.row)
    }
  }
}

protocol HomePageSelectionProtocol{
  func selectedCategories(indexPosition:Int)
  func selectedResults(indexPosition:Int)
  func selectedSchedule(indexPosition:Int)
}
