//
//  HomePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 10/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import SafariServices
import NVActivityIndicatorView
import SDWebImage
import ViewAnimator

class HomePage: UIViewController,UITableViewDelegate,UITableViewDataSource,SelectMoreButtonProtocol,NVActivityIndicatorViewable,UITabBarControllerDelegate,SaveImageProtocol,HomePageSelectionProtocol {
  
  @IBOutlet weak var tableView: UITableView!
  let sectionHeaders:[String] = ["Today's Schedule","Categories","Results", "#Revels18 On Instagram"]
  let scrollView:UIScrollView = UIScrollView()
  let refreshControl = UIRefreshControl()
  
  var instaObjects:[Instagram] = []
  var categoriesDataSource:[Categories] = []
  var resultsDataSource:[Results] = []
  var schedulesDataSource:[Schedules] = []
  let networkingObject = NetworkController()
  let resultsNetworkingObject = ResultNetworking()
  let scheduleNetworkingObject = ScheduleNetworking()
  let categoriesNetworkingObject = CategoriesNetworking()
  var indexPosition:Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    setupTableView()
    //fetchAllData()
  }
  
  func setupTableView(){
    tableView.allowsSelection = false
    tableView.backgroundView = presentNoNetworkView()
    tableView.register(UINib(nibName: "InstagramCell", bundle: nil), forCellReuseIdentifier: "InstaCell")
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(fetchAllData), for: .valueChanged)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
  }
  
  func configureScrollBar(){
    let imageFrame:CGRect = CGRect(x: 0, y: 0, width:self.view.frame.width*2, height: self.view.frame.height/4)
    scrollView.frame = imageFrame
    scrollView.delegate = self
    scrollView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let revelsBanner:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    revelsBanner.image = UIImage(named: "Revels Banner")
    revelsBanner.contentMode = .scaleToFill
    revelsBanner.clipsToBounds = true
    
    let proshowBanner:UIImageView = UIImageView(frame: CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    proshowBanner.image = UIImage(named: "Proshow Banner")
    proshowBanner.contentMode = .scaleToFill
    proshowBanner.clipsToBounds = true
    
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.addSubview(revelsBanner)
    scrollView.addSubview(proshowBanner)
    scrollView.isPagingEnabled = true
    
    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    tableView.tableHeaderView = scrollView

  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if schedulesDataSource.isEmpty {
      tableView.backgroundView = presentNoNetworkView()
      return 0
    }
    else {
      configureScrollBar()
      tableView.backgroundView = nil
      return sectionHeaders.count
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section >= 3){ return instaObjects.count}
    else{ return 1 }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
    cell.delegate = self
    cell.collectionView.reloadData()
    cell.collectionView.backgroundColor = UIColor.white
    if(indexPath.section == 0){
      cell.dataSource = schedulesDataSource.map{return $0.ename}
      cell.section = 0
      return cell
    }
    else if(indexPath.section == 1){
      cell.dataSource = categoriesDataSource.map{return $0.cname}
      cell.section = 1
      return cell
    }
    else if(indexPath.section == 2){
      cell.dataSource = resultsDataSource.map{return $0.evename}
      cell.section = 2
      return cell
    }
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "InstaCell") as! InstagramCell
      cell.delegate = self
      cell.nameLabel.text = instaObjects[indexPath.row].username
      cell.captionLabel.text = instaObjects[indexPath.row].text
      let instaURL = URL(string: instaObjects[indexPath.row].standardResolutionURL)
      let profileURL = URL(string : instaObjects[indexPath.row].profilePictureURL)
      cell.likeCount.text = "\(instaObjects[indexPath.row].likesCount)" + " likes"
      cell.locationLabel.text = instaObjects[indexPath.row].location
      cell.commentCount.text = "\(instaObjects[indexPath.row].commentsCount)" + " comments"
      cell.time.text = convertDate(date: instaObjects[indexPath.row].time)
      cell.instaView.sd_setShowActivityIndicatorView(true)
      cell.profileView.sd_setShowActivityIndicatorView(true)
      cell.instaView.sd_setIndicatorStyle(.gray)
      cell.profileView.sd_setIndicatorStyle(.gray)
      cell.instaView.sd_setImage(with: instaURL)
      cell.profileView.sd_setImage(with: profileURL)
      return cell
    }
  }
  
  func selectedCategories(indexPosition: Int) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let categoryDetailController = storyboard.instantiateViewController(withIdentifier: "CategoriesDetailController") as! CategoriesDetailController
    categoryDetailController.categoriesDataSource = categoriesDataSource[indexPosition]
    navigationController?.pushViewController(categoryDetailController, animated: true)
  }
  
  func selectedResults(indexPosition: Int) {
    
  }
  
  func selectedSchedule(indexPosition: Int) {
    
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderCell") as! HomeHeaderCell
    headerCell.delegate = self
    headerCell.nameLabel.text = sectionHeaders[section]
    headerCell.currentIndex = section
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(40)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 3{
      return 165 + self.view.bounds.width

    }
    else{
      return CGFloat(100)
    }
  }
  
  @IBAction func moreButtonSelected(_ sender: UIBarButtonItem) {
    moreButtonClicked()
  }
  
  @IBAction func favoriteButtonSelected(_ sender: Any) {
    presentFavoriteView()
  }
  
  func selectButtonClicked(currentIndex: Int) {
    switch currentIndex{
    case 0: self.tabBarController?.selectedIndex = 1
    case 1: self.tabBarController?.selectedIndex = 2
    case 2: self.tabBarController?.selectedIndex = 4
    default: print("Does Nothing")
    }
  }
  
  func fetchAllData(){
    startAnimating()
    networkingObject.fetchAllData { (instaObject) in
      self.categoriesDataSource = self.categoriesNetworkingObject.fetchCategoriesFromCoreData()
      self.resultsDataSource = self.resultsNetworkingObject.fetchResultsFromCoreData()
      self.schedulesDataSource = self.scheduleNetworkingObject.fetchScheduleFromCoreData()
      self.instaObjects = instaObject
      self.refreshControl.endRefreshing()
      self.stopAnimating()
      self.tableView.reloadData()
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.tableView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  func saveImageToPhotos(image:UIImage) {
    let downloadController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    downloadController.addAction(UIAlertAction(title: "Download Image", style: .default, handler: { _ in
      NSLog("Did Select Image To Save")
      UIImageWriteToSavedPhotosAlbum(image, self,  #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }))
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    downloadController.addAction(cancelAction)
    present(downloadController, animated: true, completion: nil)
  }

  
  func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if error != nil {
      let ac = UIAlertController(title: "Save Error", message: "Please allow Photos access in Settings", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    } else {
      let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to Photos.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
    }
  }
  
  
}
