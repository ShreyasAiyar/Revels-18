 //
 //  CategoriesDetailController.swift
 //  Revels-18
 //
 //  Created by Shreyas Aiyar on 16/01/18.
 //  Copyright © 2018 Shreyas Aiyar. All rights reserved.
 //
 
 import UIKit
 
 class CategoriesDetailController: UIViewController,UITableViewDataSource,UITableViewDelegate,SelectedCategoriesProtocol{
  
  var categoriesDataSource:Categories?
  var scheduleDataSource:[[Schedules]] = [[]]
  let scheduleNetworkingObject = ScheduleNetworking()
  @IBOutlet weak var tableView: UITableView!
  let dayArray:[String] = ["Pre Revels","Day 1","Day 2","Day 3","Day 4"]
  let color:UIColor = UIColor(displayP3Red: 181/255, green: 28/255, blue: 18/255, alpha: 1)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createBarButtonItems()
    fetchSchedules()
    self.title = categoriesDataSource?.cname
    self.navigationController?.navigationBar.tintColor = UIColor.white
  }
  
  
  @objc override func createBarButtonItems() {
    let infoButton = UIButton(type: .infoLight)
    infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchDown)
    let barButton = UIBarButtonItem(customView: infoButton)
    self.navigationItem.rightBarButtonItem = barButton
  }
  
  func infoButtonTapped(){
    let alertController:UIAlertController = UIAlertController(title: categoriesDataSource?.cname, message: categoriesDataSource?.cdesc, preferredStyle: .alert)
    let dismissAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
    alertController.addAction(dismissAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if(scheduleDataSource[0].isEmpty && scheduleDataSource[1].isEmpty && scheduleDataSource[2].isEmpty && scheduleDataSource[3].isEmpty && scheduleDataSource[4].isEmpty){
      let message = "No Data Found For " + (categoriesDataSource?.cname)! + " As Of Yet"
      tableView.backgroundView = presentNoNetworkView(primaryMessage: message, secondaryMessage: "", mainImage: (self.categoriesDataSource?.cname)!)
      return 0
    }
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell") as! CategoryDetailCell
    cell.delegate = self
    cell.dataSource = scheduleDataSource[indexPath.section]
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailHeader") as! CategoryDetailHeader
    if(scheduleDataSource[section].isEmpty){
      return nil
    }
    headerCell.dayLabel.text = dayArray[section]
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if(scheduleDataSource[indexPath.section].isEmpty){
      return 0
    }else{
      return 120
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if(scheduleDataSource[section].isEmpty){
      return 0
    }else{
    return 40
    }
  }
  
  func fetchSchedules(){
    let data = scheduleNetworkingObject.fetchScheduleFromCoreData()
    let allSchedules = (data.filter{$0.isRevels == "1" && $0.catid == self.categoriesDataSource?.cid})
    let preRevels = (data.filter{$0.isRevels == "0" && $0.catid == self.categoriesDataSource?.cid})
    self.scheduleDataSource.removeAll()
    self.scheduleDataSource.append(preRevels)
    self.scheduleDataSource.append(allSchedules.filter{return $0.day == "1"})
    self.scheduleDataSource.append(allSchedules.filter{return $0.day == "2"})
    self.scheduleDataSource.append(allSchedules.filter{return $0.day == "3"})
    self.scheduleDataSource.append(allSchedules.filter{return $0.day == "4"})
    tableView.reloadData()
  }
  
  func selectedCategory(scheduleObject: Schedules) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupView") as! PopupViewController
    popupVC.scheduleDataSource = scheduleObject
    navigationController?.pushViewController(popupVC, animated: true)
    
  }
 }
