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

class HomePage: UIViewController,UITableViewDelegate,UITableViewDataSource,SelectMoreButtonProtocol,NVActivityIndicatorViewable,UITabBarControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  let sectionHeaders:[String] = ["Today's Schedule","Categories","Results", "Instagram Feed"]
  let scrollView:UIScrollView = UIScrollView()
  
  var instaObjects:[Instagram] = []
  var categoriesDataSource:[Categories] = []
  var resultsDataSource:[Results] = []
  let networkingObject = NetworkController()
  let resultsNetworkingObject = ResultNetworking()
  let scheduleNetworkingObject = ScheduleNetworking()
  let categoriesNetworkingObject = CategoriesNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchAllData()
    tableView.register(UINib(nibName: "InstagramCell", bundle: nil), forCellReuseIdentifier: "InstaCell")
    configureNavigationBar()
    configureScrollBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
  }
  
  func configureScrollBar(){
    let imageFrame:CGRect = CGRect(x: 0, y: 0, width:self.view.frame.width*2, height: self.view.frame.height/4.3)
    scrollView.frame = imageFrame
    scrollView.delegate = self
    scrollView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let revelsBanner:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    revelsBanner.image = UIImage(named: "Revels Banner")
    revelsBanner.contentMode = .scaleToFill
    revelsBanner.clipsToBounds = true
    //revelsBanner.layer.cornerRadius = 5
    
    let proshowBanner:UIImageView = UIImageView(frame: CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    proshowBanner.image = UIImage(named: "Proshow Banner")
    proshowBanner.contentMode = .scaleToFill
    proshowBanner.clipsToBounds = true
    //proshowBanner.layer.cornerRadius = 5
    
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.isScrollEnabled = false
    
    scrollView.addSubview(revelsBanner)
    scrollView.addSubview(proshowBanner)
    
    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    tableView.tableHeaderView = scrollView
    
    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    
  }
  
  
  func moveToNextPage(){
    let pageWidth:CGFloat = self.scrollView.frame.width
    let maxWidth:CGFloat = pageWidth * 2
    let contentOffset:CGFloat = self.scrollView.contentOffset.x
    var slideToX = contentOffset + pageWidth
    if  contentOffset + pageWidth == maxWidth{
      slideToX = 0
    }
    self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sectionHeaders.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section >= 3){
      return instaObjects.count
    }
    else{
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
    cell.collectionView.reloadData()
    cell.collectionView.backgroundColor = UIColor.white
    cell.backgroundColor = UIColor.white
    if(indexPath.section < 3){
      cell.dataSource = self.resultsDataSource.map{return $0.evename}
      return cell
    }
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "InstaCell") as! InstagramCell
      print(indexPath.section)
      cell.nameLabel.text = instaObjects[indexPath.row].username
      cell.captionLabel.text = instaObjects[indexPath.row].text
      let instaURL = URL(string: instaObjects[indexPath.row].standardResolutionURL)
      let profileURL = URL(string : instaObjects[indexPath.row].profilePictureURL)
      cell.likeCount.text = "\(instaObjects[indexPath.row].likesCount)" + " likes"
      cell.locationLabel.text = instaObjects[indexPath.row].location
      cell.commentCount.text = "\(instaObjects[indexPath.row].commentsCount)" + " comments"
      cell.time.text = convertDate(date: instaObjects[indexPath.row].time)
      print(convertDate(date: instaObjects[indexPath.row].time))
      cell.instaView.sd_setShowActivityIndicatorView(true)
      cell.profileView.sd_setShowActivityIndicatorView(true)
      cell.instaView.sd_setIndicatorStyle(.gray)
      cell.profileView.sd_setIndicatorStyle(.gray)
      cell.instaView.sd_setImage(with: instaURL)
      cell.profileView.sd_setImage(with: profileURL)
      return cell
    }
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
      self.instaObjects = instaObject
      self.stopAnimating()
      self.tableView.reloadData()
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.tableView.setContentOffset(CGPoint.zero, animated: true)
  }
}
