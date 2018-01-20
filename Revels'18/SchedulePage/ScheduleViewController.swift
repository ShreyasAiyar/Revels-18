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
  let categoriesURL = "https://api.mitportals.in/schedule/"
  var scheduleDataSource:[[Schedules]] = [[]]
  var filteredDataSource:[[Schedules]] = [[]]
  var favoritesDataSource:[Schedules] = []
  var currentIndex:Int = 0
  var didShowAnimation:Bool = false
  var searchBar = UISearchBar()
  var shouldShowSearchResults = false
  var isSelectedIndex:[Int] = [-1,-1,-1,-1]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    createBarButtonItems()
    configureNavigationBar()
    fetchFavorites()
    fetchSchedules()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
    if didShowAnimation == false{
      let animation = AnimationType.from(direction: .left, offset: 30)
      schedulesCollectionView.animateViews(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.3, animationInterval: 0.075, completion: nil)
      didShowAnimation = true
    }
    
  }
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return scheduleDataSource[currentIndex].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCollectionCell", for: indexPath) as! ScheduleCollectionViewCell
    cell.delegate = self
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
  
  func fetchSchedules(){
    let schedules =  self.scheduleNetworkingObject.fetchScheduleFromCoreData()
    NSLog("Size Of Schedules Is %d", schedules.count)
    scheduleDataSource.removeAll()
    self.scheduleDataSource.append(schedules.filter{return $0.day == "1"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "2"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "3"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "4"})
    self.schedulesCollectionView.reloadData()
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
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let popupViewController = storyboard.instantiateViewController(withIdentifier: "PopupView")
    popupViewController.modalPresentationStyle = .overCurrentContext
    popupViewController.modalTransitionStyle = .crossDissolve
    self.tabBarController?.present(popupViewController, animated: true, completion: nil)
  }
  
  func fetchFavorites(){
    favoritesDataSource = scheduleNetworkingObject.fetchFavoritesFromCoreData()
  }
  
  func addToFavorites(eid: String) {
    scheduleNetworkingObject.addFavoritesToCoreData(eid: eid)
    fetchFavorites()
    self.schedulesCollectionView.reloadData()
  }
  
  func removeFromFavorites(eid: String) {
    scheduleNetworkingObject.removeFavorites(eid: eid)
    fetchFavorites()
    self.schedulesCollectionView.reloadData()
  }
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.schedulesCollectionView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  
  
}
