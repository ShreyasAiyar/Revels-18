//
//  CategoriesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ViewAnimator

class CategoriesPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITabBarControllerDelegate,NVActivityIndicatorViewable,UICollectionViewDelegateFlowLayout{
  
  
  @IBOutlet weak var categoriesCollectionView: UICollectionView!
  
  var categoriesDataSource:[Categories] = []
  var schedulesDataSource:[Schedules] = []
  let categoryNetworkingObject = CategoriesNetworking()
  let schedulesNetworkingObject = ScheduleNetworking()
  var catid:String?
  var didShowAnimation:Bool = false
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createBarButtonItems()
    configureNavigationBar()
    fetchCategories()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.delegate = self
    if(!didShowAnimation){
      let animation = AnimationType.from(direction: .top, offset: 30)
      categoriesCollectionView.animateViews(animations: [animation], reversed: false, initialAlpha: 0, finalAlpha: 1, delay: 0, duration: 0.3, animationInterval: 0.075, completion: nil)
      didShowAnimation = true
    }
  }
  
  override func reloadData() {
    let networkingObject = NetworkController()
    startAnimating()
    networkingObject.fetchAllData { _ in
      self.stopAnimating()
      self.fetchCategories()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(categoriesDataSource.isEmpty){
      categoriesCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "No Categories Data Found", secondaryMessage: "Click Refresh To Try Again", mainImage: "Revels18_Logo")
      return 0
    }else{
      categoriesCollectionView.backgroundView = nil
      return categoriesDataSource.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
    cell.categoryName.text = categoriesDataSource[indexPath.row].cname
    cell.categoryImage.image = UIImage(named: categoriesDataSource[indexPath.row].cname)
    cell.layer.cornerRadius = 5
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.bounds.width - 30)/3
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.catid = categoriesDataSource[indexPath.row].cid
  }
  
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    self.catid = categoriesDataSource[indexPath.row].cid
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "CategoryDetailSegue"{
      if let categoryDetailController = segue.destination as? CategoriesDetailController{
        categoryDetailController.categoriesDataSource = categoriesDataSource.filter{
          return $0.cid == self.catid}.first
      }
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.categoriesCollectionView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  func fetchCategories(){
    categoriesDataSource = categoryNetworkingObject.fetchCategoriesFromCoreData()
    self.categoriesCollectionView.reloadData()
  }
  
  
}
