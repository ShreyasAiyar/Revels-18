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
  let sectionHeaders:[String] = ["Events","Categories","Results", "#Revels18 On Instagram"]
  let scrollView:UIScrollView = UIScrollView()
  let refreshControl = UIRefreshControl()
  
  var instaObjects:[Instagram] = []
  var categoriesDataSource:[Categories] = []
  var resultsDataSource:[Results] = []
  var schedulesDataSource:[Schedules] = []
  var combinedDataSource:[[Any]] = [[]]
  let networkingObject = NetworkController()
  let resultsNetworkingObject = ResultNetworking()
  let scheduleNetworkingObject = ScheduleNetworking()
  let categoriesNetworkingObject = CategoriesNetworking()
  var indexPosition:Int?
  var bannerTimer:Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    setupTableView()
    fetchAllData()
    let defaults = UserDefaults.standard
    guard let loggedIn = defaults.value(forKey: "LoggedIn") as? Bool else{
      didSelectLoginButton(self)
      return
    }
    if(!loggedIn){
      didSelectLoginButton(self)
    }
  }
  
  func setupTableView(){
    tableView.allowsSelection = false
    tableView.backgroundView = presentNoNetworkView(primaryMessage: "No Data Found...", secondaryMessage: "Pull To Refresh To Try Again", mainImage: "Revels18_Logo")
    tableView.register(UINib(nibName: "InstagramCell", bundle: nil), forCellReuseIdentifier: "InstaCell")
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(fetchAllData), for: .valueChanged)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tabBarController?.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupQRCodeView()
  }
  
  func configureScrollBar(){
    if(bannerTimer != nil){
      bannerTimer?.invalidate()
      bannerTimer = nil
    }
    let imageFrame:CGRect = CGRect(x: 0, y: 0, width:self.view.frame.width*2, height: self.view.frame.height/3)
    scrollView.frame = imageFrame
    scrollView.delegate = self
    //scrollView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    scrollView.backgroundColor = UIColor.white
    
    let revelsBanner:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    revelsBanner.image = UIImage(named: "Revels18 Banner")
    revelsBanner.contentMode = .scaleToFill
    revelsBanner.clipsToBounds = true
    
    let proshowBanner:UIImageView = UIImageView(frame: CGRect(x: self.view.frame.width , y: 0, width: self.view.frame.width, height: scrollView.frame.height))
    proshowBanner.image = UIImage(named: "Proshow Ground Zero")
    proshowBanner.contentMode = .scaleToFill
    proshowBanner.clipsToBounds = true
    
    scrollView.showsHorizontalScrollIndicator = false
    
    scrollView.addSubview(revelsBanner)
    scrollView.addSubview(proshowBanner)
    scrollView.isPagingEnabled = true
    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
    tableView.tableHeaderView = scrollView
    if(bannerTimer == nil){
      bannerTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
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
    if categoriesDataSource.isEmpty {
      tableView.backgroundView = presentNoNetworkView(primaryMessage: "No Data Found...", secondaryMessage: "Pull To Refresh To Try Again", mainImage: "Revels18_Logo")
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
      cell.schedulesDataSource = schedulesDataSource
      cell.sectionIndex = 0
      return cell
    }
    else if(indexPath.section == 1){
      cell.categoriesDataSource = categoriesDataSource
      cell.sectionIndex = 1
      return cell
    }
    else if(indexPath.section == 2){
      cell.resultsDataSource = resultsDataSource
      cell.sectionIndex = 2
      return cell
    }
    else{
      let cell = tableView.dequeueReusableCell(withIdentifier: "InstaCell") as! InstagramCell
      cell.delegate = self
      cell.nameLabel.text = instaObjects[indexPath.row].username
      cell.captionLabel.text = instaObjects[indexPath.row].text
      let instaURL = URL(string: instaObjects[indexPath.row].standardResolutionURL)
      let profileURL = URL(string : instaObjects[indexPath.row].profilePictureURL)
      cell.url = instaObjects[indexPath.row].url
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
    let message = "Position: " + resultsDataSource[indexPosition].pos
    let title = "Event Name: " + resultsDataSource[indexPosition].evename
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertView.addAction(okAction)
    present(alertView, animated: true, completion: nil)
  }
  
  func selectedSchedule(indexPosition: Int) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let eventsVC = storyboard.instantiateViewController(withIdentifier: "PopupView") as! PopupViewController
    eventsVC.scheduleDataSource = schedulesDataSource[indexPosition]
    navigationController?.pushViewController(eventsVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderCell") as! HomeHeaderCell
    headerCell.delegate = self
    headerCell.nameLabel.text = sectionHeaders[section]
    headerCell.currentIndex = section
    if(section >= 3){
      headerCell.seeAllButton.isEnabled = false
    }
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if(combinedDataSource[section].isEmpty){
      return 0
    }
    else{
      return 40
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 3{
      return 170 + self.view.bounds.width
    }
    else{
      if(combinedDataSource[indexPath.section].isEmpty){
        return 0
      }
      else{
        return 120
      }
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
      self.combinedDataSource.removeAll()
      self.combinedDataSource.append(self.schedulesDataSource)
      self.combinedDataSource.append(self.categoriesDataSource)
      self.combinedDataSource.append(self.resultsDataSource)
      self.combinedDataSource.append(self.instaObjects)
      self.refreshControl.endRefreshing()
      self.stopAnimating()
      self.tableView.reloadData()
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    self.tableView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  func saveImageToPhotos(image:UIImage,url:String) {
    let downloadController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    downloadController.addAction(UIAlertAction(title: "Download Image", style: .default, handler: { _ in
      NSLog("Did Select Image To Save")
      UIImageWriteToSavedPhotosAlbum(image, self,  #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }))
    downloadController.addAction(UIAlertAction(title: "Visit Page", style: .default, handler: { (_) in
      let myURL = URL(string: url)
      let safariViewController = SFSafariViewController(url: myURL!)
      self.present(safariViewController, animated: true,completion: nil)
      
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
  
  // Login Controller
  
  @IBAction func didSelectLoginButton(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "DelegateLogin")
    //loginViewController.modalPresentationStyle = .overCurrentContext
    present(loginViewController, animated: true, completion: nil)
  }
  
  func didSelectQRButton(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let QRViewController = storyboard.instantiateViewController(withIdentifier: "QRLogin")
    present(QRViewController, animated: true, completion: nil)
  }
  
  func setupQRCodeView(){
    let defaults = UserDefaults.standard
    let loggedin = defaults.bool(forKey: "LoggedIn")
    if(loggedin){
      let QRImage = UIImage(named: "QRCode")
      let barButtonItem = UIBarButtonItem(image: QRImage, style: .plain, target: self, action: #selector(didSelectQRButton))
      barButtonItem.tintColor = UIColor.white
      navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
    else{
      let loginImage = UIImage(named: "Add-User")
      let barButtonItem = UIBarButtonItem(image: loginImage, style: .plain, target: self, action: #selector(didSelectLoginButton(_:)))
      barButtonItem.tintColor = UIColor.white
      navigationItem.setLeftBarButton(barButtonItem, animated: true)
    }
  }
}
