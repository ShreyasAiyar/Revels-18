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
  var scheduleDataSource:[Schedules]?
  let scheduleNetworkingObject = ScheduleNetworking()
  @IBOutlet weak var tableView: UITableView!
  let dayArray:[String] = ["Day 1","Day 2","Day 3","Day 4"]
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
    if(scheduleDataSource?.isEmpty)!{
      let message = (categoriesDataSource?.cname)! + " has no events for this day"
      tableView.backgroundView = presentNoNetworkView(primaryMessage: message, secondaryMessage: "Blame It On Sys Admin", mainImage: "Revels18_Logo")
      return 0
    }
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell") as! CategoryDetailCell
    cell.delegate = self
    switch(indexPath.section){
    case 0:
      cell.dataSource = scheduleDataSource!.filter{return $0.day == "1"}
    case 1:
      cell.dataSource = scheduleDataSource!.filter{return $0.day == "2"}
    case 2:
      cell.dataSource = scheduleDataSource!.filter{return $0.day == "3"}
    case 3:
      cell.dataSource = scheduleDataSource!.filter{return $0.day == "4"}
    default:
      print("No Data")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailHeader") as! CategoryDetailHeader
    headerCell.dayLabel.text = dayArray[section]
    return headerCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if((scheduleDataSource?.filter{return $0.day == "\(indexPath.section - 1)"})?.isEmpty)!{
      return 0
    }else{
    return 120
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func fetchSchedules(){
    let data = scheduleNetworkingObject.fetchScheduleFromCoreData()
    let allSchedules = data.filter{return $0.isRevels == "1"}
    scheduleDataSource = allSchedules.filter{return $0.catid == self.categoriesDataSource?.cid}
    tableView.reloadData()
  }
  
  func selectedCategory(scheduleObject: Schedules) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupView") as! PopupViewController
    popupVC.eventID = scheduleObject.eid
    navigationController?.pushViewController(popupVC, animated: true)
    
  }
 }
