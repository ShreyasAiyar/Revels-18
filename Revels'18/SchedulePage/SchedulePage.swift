//
//  SchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreData
import ViewAnimator


class SchedulePage: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AddToFavoritesProtocol,UITabBarControllerDelegate,UIScrollViewDelegate{
  
  @IBOutlet var favoritesView: UIView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: Creating Objects
  let scheduleNetworkingObject = ScheduleNetworking()
  let categoriesURL = "https://api.mitportals.in/schedule/"
  var scheduleDataSource:[[Schedules]] = [[]]
  var filteredDataSource:[[Schedules]] = [[]]
  var favoritesDataSource:[Schedules] = []
  var currentIndex:Int = 0
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
    //tableView.animateRandom()
  }
  
  //MARK: Reload Data When Reload Button Clicked
  override func reloadData(){
    //fetchSchedules()
    self.tableView.reloadData()
  }
  
  //MARK: Configure Search Button
  override func searchButtonPressed() {
    super.searchButtonPressed()
    searchBar.text = ""
    searchBar.prompt = "Search Here"
    searchBar.showsCancelButton = true
    searchBar.alpha = 1
    navigationItem.titleView = searchBar
    self.searchBar.becomeFirstResponder()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    shouldShowSearchResults = true
    searchBar.showsCancelButton = true
    tableView.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    shouldShowSearchResults = false
    hideSearchBar()
    tableView.reloadData()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scheduleDataSource[currentIndex].count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
    cell.delegate = self
    cell.eid = scheduleDataSource[currentIndex][indexPath.row].eid + "(" + scheduleDataSource[currentIndex][indexPath.row].round + ")"
    cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.row].ename
    cell.time.text! = scheduleDataSource[currentIndex][indexPath.row].stime + " - " + scheduleDataSource[currentIndex][indexPath.row].etime
    cell.location.text = scheduleDataSource[currentIndex][indexPath.row].venue
    
    if favoritesDataSource.contains(where: {$0.eid == cell.eid}){
      cell.favouriteButton.isSelected = true
    }else{
      cell.favouriteButton.isSelected = false
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isSelectedIndex[currentIndex] = indexPath.row
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(70)
  }
  
  @IBAction func segmentedValueChanged(_ sender: Any) {
    currentIndex = segmentedControl.selectedSegmentIndex
    self.tableView.reloadSections([0], with: .automatic)
  }
  
  
  func fetchSchedules(){
    let schedules =  self.scheduleNetworkingObject.fetchScheduleFromCoreData()
    NSLog("Size Of Schedules Is %d", schedules.count)
    scheduleDataSource.removeAll()
    self.scheduleDataSource.append(schedules.filter{return $0.day == "1"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "2"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "3"})
    self.scheduleDataSource.append(schedules.filter{return $0.day == "4"})
    self.tableView.reloadData()
  }
  
  func addToFavorites(eid:String) {
    scheduleNetworkingObject.addFavoritesToCoreData(eid: eid)
    fetchFavorites()
    tableView.reloadData()
  }
  
  func removeFromFavorites(eid: String) {
    scheduleNetworkingObject.removeFavorites(eid: eid)
    fetchFavorites()
    tableView.reloadData()
  }
  
  func fetchFavorites(){
    self.favoritesDataSource = scheduleNetworkingObject.fetchFavoritesFromCoreData()
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.tableView.setContentOffset(CGPoint.zero, animated: true)
  }
  
}
