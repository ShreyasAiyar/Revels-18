//
//  ResultsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData

class ResultsPage: UIViewController,NVActivityIndicatorViewable,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITabBarControllerDelegate {
  
  let segmentLabels:[String] = ["Results","Sports Results"]
  
  @IBOutlet weak var segmentView: UIView!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  @IBOutlet weak var resultsCollectionView: UICollectionView!
  
  let resultNetworkingObject = ResultNetworking()
  var resultsDataSource:[Results] = []
  var filteredDataSource:[Results] = []
  var searchBar = UISearchBar()
  var searchActive:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchResults()
    createBarButtonItems()
    configureNavigationBar()
    searchBar.delegate = self
    tabBarController?.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
  }
  
  override func searchButtonPressed() {
    super.searchButtonPressed()
    self.searchBar.becomeFirstResponder()
    searchBar.alpha = 1
    navigationItem.titleView = searchBar
  }
  
  //MARK: Search Functions
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
    searchActive = true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
    searchBar.text?.removeAll()
    hideSearchBar()
    resultsCollectionView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredDataSource = resultsDataSource.filter({ (result) -> Bool in
      return result.evename.lowercased().range(of: searchText.lowercased()) != nil
    })
    if(filteredDataSource.count == 0){
      searchActive = false
    } else {
      searchActive = true
    }
    self.resultsCollectionView.reloadData()
  }
  
  override func reloadData(){
    fetchResults()
    self.resultsCollectionView.reloadData()
  }
  
  //MARK: Collection View Methods
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
    if searchActive == false{
      cell.eventName.text = resultsDataSource[indexPath.row].evename
      cell.roundNo.text = "Round " + resultsDataSource[indexPath.row].round
    }
    else{
      cell.eventName.text = filteredDataSource[indexPath.row].evename
      cell.roundNo.text = "Round " + filteredDataSource[indexPath.row].round
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if searchActive == false{
      return resultsDataSource.count
    }
    else{
      return filteredDataSource.count
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.bounds.width - 35)/4
    let height = width + 30
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  
  func fetchResults(){
    resultsDataSource = resultNetworkingObject.fetchResultsFromCoreData()
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.resultsCollectionView.setContentOffset(CGPoint.zero, animated: true)
  }
}



