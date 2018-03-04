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
  var resultsDataSource:[[Results]] = [[]]
  var filteredDataSource:[[Results]] = []
  var searchBar = UISearchBar()
  var currentIndex:Int = 0
  var searchActive:Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchResults()
    createBarButtonItems()
    configureNavigationBar()
    searchBar.delegate = self
    filteredDataSource = resultsDataSource
  }
  
  override func createBarButtonItems() {
    super.createBarButtonItems()
    let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
    searchBarButtonItem.tintColor = UIColor.white
    let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
    moreButtonItem.image = UIImage(named: "More")
    self.navigationItem.setRightBarButtonItems([moreButtonItem,searchBarButtonItem], animated: true)
    moreButtonItem.tintColor = UIColor.white
  }
  
  @IBAction func didChangeSegmentedIndex(_ sender: Any) {
    self.currentIndex = segmentControl.selectedSegmentIndex
    self.resultsCollectionView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
  }
  
  override func searchButtonPressed() {
    super.searchButtonPressed()
    searchBar.searchBarStyle = .minimal
    searchBar.tintColor = UIColor.white
    let textField = searchBar.value(forKey: "searchField") as! UITextField
    textField.textColor = UIColor.white
    self.searchBar.becomeFirstResponder()
    searchBar.alpha = 1
    navigationItem.titleView = searchBar
  }
  
  //MARK: Search Functions
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    filteredDataSource[currentIndex] = resultsDataSource[currentIndex]
    searchBar.text = nil
    hideSearchBar()
    resultsCollectionView.reloadData()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText.isEmpty)
    filteredDataSource[currentIndex] = searchText.isEmpty ? resultsDataSource[currentIndex]:resultsDataSource[currentIndex].filter({ (result) -> Bool in
      return result.evename.range(of: searchText, options: .caseInsensitive) != nil
    })
    self.resultsCollectionView.reloadData()
  }
  
  override func reloadData(){
    startAnimating()
    let networkingObject = NetworkController()
    networkingObject.fetchAllData { (_) in
      self.stopAnimating()
      self.fetchResults()
    }
  }
  
  //MARK: Collection View Methods
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
    cell.eventName.text = filteredDataSource[currentIndex][indexPath.row].eve
    cell.roundNo.text = "Round " + filteredDataSource[currentIndex][indexPath.row].round
    cell.teamID.text = "Team ID: " + filteredDataSource[currentIndex][indexPath.row].tid
    cell.categoryImage.image = UIImage(named: filteredDataSource[currentIndex][indexPath.row].cat)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(filteredDataSource[currentIndex].isEmpty){
      resultsCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "No Results Data Found", secondaryMessage: "Click Refresh To Try Again", mainImage: "Revels18_Logo")
      return 0
    }else{
      resultsCollectionView.backgroundView = nil
      return filteredDataSource[currentIndex].count
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.bounds.width - 35)/4
    let height = width + 40
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let message = "Position: " + resultsDataSource[currentIndex][indexPath.row].pos + "\n" + "Round: " + resultsDataSource[currentIndex][indexPath.row].round
    let title = "Event Name: " + resultsDataSource[currentIndex][indexPath.row].evename
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertView.addAction(okAction)
    present(alertView, animated: true, completion: nil)
  }
  
  func fetchResults(){
    resultsDataSource.removeAll()
    resultsDataSource.append(resultNetworkingObject.fetchResultsFromCoreData())
    resultsDataSource.append(resultNetworkingObject.fetchSportsResultsFromCoreData())
    self.resultsCollectionView.reloadData()
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.resultsCollectionView.setContentOffset(CGPoint.zero, animated: true)
  }
}




