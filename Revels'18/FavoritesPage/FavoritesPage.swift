//
//  FavoritesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class FavoritesPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var favoritesCollectionView: UICollectionView!
  let scheduleObject = ScheduleNetworking()
  var favoritesDataSource:[[Schedules]] = []
  let days:[String] = ["Day 1","Day 2","Day 3","Day 4"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchFavorites()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 4
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
    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FavoritesHeaderView", for: indexPath) as! FavoritesHeaderView
    headerView.dayLabel.text = days[indexPath.section]
    return headerView
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
  
  
  
}
