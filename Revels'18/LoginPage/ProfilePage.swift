//
//  ProfilePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 17/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ProfilePage: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  var profileData:[Dictionary<String,String>]!
  
  @IBOutlet weak var profileTableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Registered Events"
    profileTableView.tableFooterView = UIView()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(profileData.isEmpty){
      profileTableView.backgroundView = presentNoNetworkView(primaryMessage: "No Registered Events Found", secondaryMessage: "You can scan event QR Codes to get started", mainImage: "Revels18_Logo")
    }
    return profileData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! UITableViewCell
    cell.textLabel?.text = "Event Name: " + profileData[indexPath.row]["event_name"]!
    cell.detailTextLabel?.text = "Team ID: " + profileData[indexPath.row]["team_id"]!
    
    return cell
  }
}
