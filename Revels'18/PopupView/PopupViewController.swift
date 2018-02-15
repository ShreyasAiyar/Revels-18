//
//  PopupViewController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 20/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import UserNotifications

class PopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var eventsDataSource:Events?
  var scheduleDataSource:Schedules?
  let informationHeaders:[String] = ["Category","Round","Date","Time","Team Of","Contact Name","Contact Number"]
  var eventID:String?
  let eventObject = EventsNetworking()
  let scheduleObject = ScheduleNetworking()
  var dateTimeValue:Date!
  
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
        cell.informationValue.text = scheduleDataSource?.catname
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 1){
        cell.informationValue.text = scheduleDataSource?.round
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 2){
        cell.informationValue.text = scheduleDataSource?.date
        cell.eventInfoImage.image = UIImage(named: informationHeaders[indexPath.row])
      }
      if(indexPath.row == 3){
        cell.informationValue.text = scheduleDataSource?.stime
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
      return 100
    }
    else if(indexPath.section == 1){
      return 50
    }
    else{
      return 150
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
  
  @IBAction func didSelectAlarmButton(_ sender: Any) {
    let vc = UIViewController()
    let dateTimePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
    dateTimePicker.datePickerMode = .dateAndTime
    vc.preferredContentSize = CGSize(width: 250,height: 300)
    vc.view.addSubview(dateTimePicker)
     let alertController = UIAlertController(title: "Add Notification", message: "Add a date and time", preferredStyle: .alert)
    alertController.setValue(vc, forKey: "contentViewController")
    alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
      self.dateTimeValue = dateTimePicker.date
      self.createNotifications()
    }))
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true)
  }
  
  func createNotifications(){
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { (settings) in
      if settings.authorizationStatus == .authorized{
        NSLog("Creating A Notification")
        let content = UNMutableNotificationContent()
        NSLog("Date Time Value is \(self.dateTimeValue)")
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: self.dateTimeValue)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        content.title = (self.eventsDataSource?.ename)!
        content.body = (self.eventsDataSource?.cname)! + " has an event coming up!"
        content.sound = UNNotificationSound.default()
        
        let identifier = "Revels18Event"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
          if let error = error{
            NSLog(error.localizedDescription)
          }else{
            let alertController = UIAlertController(title: "Notification Created!", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
          }
          
        })
      }
      else{
        let alertController = UIAlertController(title: "Allow Notification Access", message: "Please allow notifications from settings", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
  }
}
