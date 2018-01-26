//
//  PopupViewController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 20/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var eventsDataSource:Events?
  var scheduleDataSource:Schedules?
  let informationHeaders:[String] = ["Category","Round","Date","Time","Venue","Team Of","Contact Name","Contact Number"]
  var eventID:String?
  let eventObject = EventsNetworking()
  let scheduleObject = ScheduleNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchEventsFromCoreData()
    tabBarController?.hidesBottomBarWhenPushed = true
    navigationController?.navigationBar.tintColor = UIColor.white
    title = eventsDataSource?.ename
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if(indexPath.section == 0){
      let cell = tableView.dequeueReusableCell(withIdentifier: "EventHeaderCell") as! EventHeaderCell
      cell.eventImage.image = UIImage(named: "Animania")
      return cell
    }
    else if(indexPath.section == 1){
      let cell = tableView.dequeueReusableCell(withIdentifier: "EventInformationCell") as! EventInformationCell
      cell.information.text = informationHeaders[indexPath.row]
      if(indexPath.row == 0){
        cell.informationValue.text = scheduleDataSource?.day
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 1){
        cell.informationValue.text = scheduleDataSource?.date
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 2){
        cell.informationValue.text = scheduleDataSource?.etime
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 3){
        cell.informationValue.text = scheduleDataSource?.venue
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 4){
        cell.informationValue.text = eventsDataSource?.emaxteamsize
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 5){
        cell.informationValue.text = eventsDataSource?.cntctname
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 6){
        cell.informationValue.text = eventsDataSource?.cntctno
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      return cell
    }
    else if(indexPath.section == 2){
      let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailCell") as! EventDetailCell
      cell.detailLabel.text = eventsDataSource?.edesc
      return cell
    }
    else {return UITableViewCell()}
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(section == 1){ return 7}
    else{ return 1 }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if(indexPath.section == 0){
      return 250
    }
    else if(indexPath.section == 1){
      return 50
    }
    else{
      return 300
    }
  }
  
  func fetchEventsFromCoreData(){
    let events = eventObject.fetchEventsFromCoreData()
    eventsDataSource = events.filter{return $0.eid == self.eventID}.first
    let schedule = scheduleObject.fetchScheduleFromCoreData()
    scheduleDataSource = schedule.filter{return $0.eid == eventsDataSource?.eid}.filter{return $0.day == eventsDataSource?.day}.first
  }
  

  @IBAction func didSelectCallButton(_ sender: Any) {
    guard let number = URL(string: "tel://" + (eventsDataSource?.cntctno)!) else{
      return
    }
    UIApplication.shared.open(number, options: [:], completionHandler: nil)
  }
  
  
}
