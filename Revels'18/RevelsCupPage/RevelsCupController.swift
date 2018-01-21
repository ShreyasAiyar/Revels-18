//
//  RevelsCupController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 21/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class RevelsCupController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var revelsCupDataSource:[String] = []
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    configureNavigationBar()
  }
  
  func configureTableView(){
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(revelsCupDataSource.isEmpty){
      tableView.backgroundView = presentNoNetworkView()
      return 0
    }
    else{
      tableView.backgroundView = nil
      return revelsCupDataSource.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RevelsCupCell", for: indexPath)
    return cell
  }
  
  override func reloadData() {
    refreshControl.endRefreshing()
  }
  
  
}
