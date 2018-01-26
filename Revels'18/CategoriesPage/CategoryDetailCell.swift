//
//  CategoryDetailCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class CategoryDetailCell: UITableViewCell {
  
  var dataSource:[Schedules]?
  var delegate:SelectedCategoriesProtocol!
}

extension CategoryDetailCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (dataSource?.count)!
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailCollectionCell", for: indexPath) as! CategoryDetailCollectionCell
    cell.eventName.text = dataSource![indexPath.row].ename
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 110)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  delegate.selectedCategory(scheduleObject: dataSource![indexPath.row])
  }
  
  
}

protocol SelectedCategoriesProtocol{
  func selectedCategory(scheduleObject:Schedules)
}
