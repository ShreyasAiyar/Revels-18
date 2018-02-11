//
//  FavoritesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class FavoritesPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RemoveDayFromFavoritesProtocol {
  
  @IBOutlet weak var favoritesCollectionView: UICollectionView!
  let scheduleObject = ScheduleNetworking()
  var favoritesDataSource:[[Schedules]] = []
  let days:[String] = ["Day 1","Day 2","Day 3","Day 4"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchFavorites()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if(favoritesDataSource[0].isEmpty && favoritesDataSource[1].isEmpty && favoritesDataSource[2].isEmpty && favoritesDataSource[3].isEmpty){
      favoritesCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "You Have No Favorites", secondaryMessage: "You should try adding some", mainImage: "Love")
      return 0
    }
    else{
      return 4
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if(favoritesDataSource[indexPath.section].isEmpty){
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoFavoritesCell", for: indexPath)
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCollectionCell", for: indexPath) as! FavoritesCollectionViewCell
    cell.collectionView.reloadData()
    cell.backgroundColor = UIColor.white
    cell.dataSource = favoritesDataSource[indexPath.section]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if(favoritesDataSource[indexPath.section].isEmpty){
      return CGSize(width: self.view.bounds.width - CGFloat(20), height: 40)
    }
    else{
      return CGSize(width: self.view.bounds.width - CGFloat(20), height: 100)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if(kind == UICollectionElementKindSectionHeader){
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FavoritesHeaderView", for: indexPath) as! FavoritesHeaderView
      NSLog("%d", indexPath.section)
      headerView.delegate = self
      headerView.dayLabel.text = days[indexPath.section]
      headerView.day = indexPath.section + 1
      if(favoritesDataSource[indexPath.section].isEmpty){
        headerView.clearButton.isHidden = true
      }
      return headerView
    }
    else{
      return UICollectionReusableView()
    }
  }
  
  @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func fetchFavorites(){
    let favorites = scheduleObject.fetchFavoritesFromCoreData()
    favoritesDataSource.removeAll()
    favoritesDataSource.append(favorites.filter{return $0.day == "1"})
    favoritesDataSource.append(favorites.filter{return $0.day == "2"})
    favoritesDataSource.append(favorites.filter{return $0.day == "3"})
    favoritesDataSource.append(favorites.filter{return $0.day == "4"})
    NSLog("The Favorites Data Source %d", favoritesDataSource[0].count)
    favoritesCollectionView.reloadData()
  }
  
  func removeDayFromFavorites(day: Int) {
    scheduleObject.removeDayFavorites(day: String(day))
    fetchFavorites()
    self.favoritesCollectionView.reloadData()
  }
  
  @IBAction func didSelectRemoveAllFavorites(_ sender: Any) {
    scheduleObject.removeAllFavorites()
    self.favoritesCollectionView.reloadData()
  }
  
  
  
}
