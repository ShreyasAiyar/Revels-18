//
//  ScheduleViewController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import ViewAnimator

class ScheduleViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate,UIScrollViewDelegate,UISearchBarDelegate,AddToFavoritesProtocol {
  
  @IBOutlet weak var schedulesCollectionView:UICollectionView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  let scheduleNetworkingObject = ScheduleNetworking()
  let networkingObject = NetworkController()
  let categoriesURL = "https://api.mitportals.in/schedule/"
  var scheduleDataSource:[[Schedules]] = [[]]
  var filteredDataSource:[[Schedules]] = [[]]
  var favoritesDataSource:[Schedules] = []
  var currentIndex:Int = 0
  var didShowAnimation:Bool = false
  var searchBar = UISearchBar()
  var shouldShowSearchResults = false
  let refreshControl = UIRefreshControl()
  var schedule:Schedules!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    createBarButtonItems()
    configureNavigationBar()
    setupCollectionView()
  }
  
  func setupCollectionView(){
    schedulesCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "No Schedules Data Found", secondaryMessage: "Pull To Refresh To Try Again", mainImage: "Revels18_Logo")
    schedulesCollectionView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
    fetchData()
  }
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if(scheduleDataSource[currentIndex].isEmpty){
      NSLog("No Schedules To Present")
      schedulesCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "No Schedules Data Found...", secondaryMessage: "Pull To Refresh To Try Again", mainImage: "Revels18_Logo")
      return 0
    }
    else{
      schedulesCollectionView.backgroundView = nil
      return 1
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return scheduleDataSource[currentIndex].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCollectionCell", for: indexPath) as! ScheduleCollectionViewCell
    cell.delegate = self
    cell.categoryImage.image = UIImage(named:scheduleDataSource[currentIndex][indexPath.row].catname)
    cell.eid = scheduleDataSource[currentIndex][indexPath.row].eid
    cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.row].ename + "(" + scheduleDataSource[currentIndex][indexPath.row].round + ")"
    cell.time.text! = scheduleDataSource[currentIndex][indexPath.row].stime + " - " + scheduleDataSource[currentIndex][indexPath.row].etime
    cell.location.text = scheduleDataSource[currentIndex][indexPath.row].venue
    if favoritesDataSource.contains(where: {$0.eid == cell.eid}){
      cell.favouriteButton.isSelected = true
    }else{
      cell.favouriteButton.isSelected = false
    }
    return cell
  }
  
  @IBAction func didChangeSegmentedIndex(_ sender: Any) {
    currentIndex = segmentedControl.selectedSegmentIndex
    self.schedulesCollectionView.reloadData()
  }
  
  func fetchData(){
    let schedules =  self.scheduleNetworkingObject.fetchScheduleFromCoreData()
    favoritesDataSource = scheduleNetworkingObject.fetchFavoritesFromCoreData()
    NSLog("Size Of Schedules Is %d", schedules.count)
    scheduleDataSource.removeAll()
    let revelsEvents = schedules.filter({return $0.isRevels == "1"})
    self.scheduleDataSource.append(revelsEvents.filter{return $0.day == "1"})
    self.scheduleDataSource.append(revelsEvents.filter{return $0.day == "2"})
    self.scheduleDataSource.append(revelsEvents.filter{return $0.day == "3"})
    self.scheduleDataSource.append(revelsEvents.filter{return $0.day == "4"})
    self.scheduleDataSource.append(schedules.filter({return $0.isRevels == "0"}))
    self.schedulesCollectionView.reloadData()
  }
  
  override func reloadData() {
    networkingObject.fetchAllData{_ in
      self.fetchData()
      self.refreshControl.endRefreshing()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width - 10, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    schedule = scheduleDataSource[currentIndex][indexPath.row]
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "PopupViewSegue"){
      let destinationVC = segue.destination as! PopupViewController
      destinationVC.scheduleDataSource = schedule
    }
  }
  
  func addToFavorites(eid: String) {
    scheduleNetworkingObject.addFavoritesToCoreData(eid: eid)
    fetchData()
    self.schedulesCollectionView.reloadData()
  }
  
  func removeFromFavorites(eid: String) {
    scheduleNetworkingObject.removeFavorites(eid: eid)
    fetchData()
    self.schedulesCollectionView.reloadData()
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    schedule = scheduleDataSource[currentIndex][indexPath.row]
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.contentView.backgroundColor = UIColor(white: 217.0/255.0, alpha: 1.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    cell?.contentView.backgroundColor = nil
  }
  
  
  
  
  
}
