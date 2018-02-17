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
  var categoryName:[String] = []
  var schedulesDataSource:[Schedules]?
  var categoriesDataSource:[Categories]?
  var resultsDataSource:[Results]?
  var sectionIndex:Int?
  var delegate:HomePageSelectionProtocol?
}

extension HomeViewCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(sectionIndex == 0){
      let count = schedulesDataSource!.count > 10 ? 10:schedulesDataSource!.count
      return count
    } else if(sectionIndex == 1){
      let count = categoriesDataSource!.count > 10 ? 10:categoriesDataSource!.count
      return count
    }else {
      let count = resultsDataSource!.count > 10 ? 10:resultsDataSource!.count
      return count
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! NewHomeViewCell
    if(sectionIndex == 0){
      cell.homeLabel.text = schedulesDataSource![indexPath.row].ename
      let imageName = schedulesDataSource![indexPath.row].catname + " Large"
      cell.homeImage.image = UIImage(named: imageName)
    }else if(sectionIndex == 1){
      cell.homeLabel.text = categoriesDataSource![indexPath.row].cname
      let imageName = categoriesDataSource![indexPath.row].cname + " Large"
      cell.homeImage.image = UIImage(named: imageName)
    }else{
      cell.homeLabel.text = resultsDataSource![indexPath.row].eve
      //let imageName = resultsDataSource![indexPath.row].cat + " Large"
      cell.homeImage.image = UIImage(named: "Revels18_Logo")
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 70, height: 110)
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
    if(sectionIndex! == 0){
      delegate?.selectedSchedule(indexPosition: indexPath.row)
    }
    if(sectionIndex! == 1){
      delegate?.selectedCategories(indexPosition: indexPath.row)
    }
    if(sectionIndex! == 2){
      delegate?.selectedResults(indexPosition: indexPath.row)
    }
  }
}

protocol HomePageSelectionProtocol{
  func selectedCategories(indexPosition:Int)
  func selectedResults(indexPosition:Int)
  func selectedSchedule(indexPosition:Int)
}
