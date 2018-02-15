//
//  DevelopersPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class DevelopersPage: UIViewController,UITableViewDataSource,UITableViewDelegate{
  
  var developerDataSource:[Developers] = []
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.backgroundColor = UIColor.clear
    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.view.frame
    self.tableView.backgroundView = blurEffectView
    self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    configureDeveloperController()
  }
  
  func configureDeveloperController(){
    let shreyasImage = UIImage(named: "Shreyas")
    let harshImage = UIImage(named: "Harsh")
    let anuragImage = UIImage(named: "Anurag")
    let saptarishiImage = UIImage(named: "Saptarishi")
    let rahulImage = UIImage(named: "Rahul")
    let gauthamImage = UIImage(named: "Gautham")
    let anjaliImage = UIImage(named: "Anjali")
    
    developerDataSource.append(Developers(developerName: "Shreyas Aiyar", developerImage: shreyasImage, developerPosition: "Cathead", developerMessage: "Revels-18 iOS Developer"))
    developerDataSource.append(Developers(developerName: "Harsh Mutha", developerImage: harshImage, developerPosition: "Organizer", developerMessage: "Revels-18"))
    developerDataSource.append(Developers(developerName: "Anurag Choudhary", developerImage: anuragImage, developerPosition: "Cathead", developerMessage: "Revels-18"))
    developerDataSource.append(Developers(developerName: "Saptarishi Roy", developerImage: saptarishiImage, developerPosition: "Organizer", developerMessage: "Revels-18"))
    developerDataSource.append(Developers(developerName: "Rahul Sathanapalli", developerImage: rahulImage, developerPosition: "Organizer", developerMessage: "Revels-18"))
    developerDataSource.append(Developers(developerName: "Gautham Vinod", developerImage: gauthamImage, developerPosition: "Cathead", developerMessage: "Revels-18"))
    developerDataSource.append(Developers(developerName: "Anjali Premjit", developerImage: anjaliImage, developerPosition: "Organizer", developerMessage: "Revels-18"))
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return developerDataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DeveloperCell") as! DeveloperCell
    cell.developerName.text = developerDataSource[indexPath.row].developerName
    cell.developerImage.image = developerDataSource[indexPath.row].developerImage!
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alertTitle = developerDataSource[indexPath.row].developerPosition
    let alertMessage = developerDataSource[indexPath.row].developerMessage
    let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let cancelButton = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(cancelButton)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
