//
//  RevelsCupController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 21/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class RevelsCupController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  @IBOutlet weak var revelsCupCollectionView: UICollectionView!
  var revelsCupDataSource:[RevelsCups] = []
  let refreshControl = UIRefreshControl()
  let revelsCupObject = RevelsCupNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    configureNavigationBar()
    createBarButtonItems()
    fetchRevelsCupData()
  }
  
  func configureCollectionView(){
    revelsCupCollectionView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if(revelsCupDataSource.isEmpty){
      revelsCupCollectionView.backgroundView = presentNoNetworkView(primaryMessage: "Revels Cup Details Haven't Arrived", secondaryMessage: "Be Patient...", mainImage: "Revels18_Logo")
      return 0
    }else{
      revelsCupCollectionView.backgroundView = nil
      return revelsCupDataSource.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RevelsCupCell", for: indexPath) as! RevelsCupCell
    cell.sportDate.text = revelsCupDataSource[indexPath.row].date
    cell.sportName.text = revelsCupDataSource[indexPath.row].sname
    cell.sportTime.text = revelsCupDataSource[indexPath.row].time
    cell.teamID1.text = "Team ID 1: " + revelsCupDataSource[indexPath.row].team1
    cell.teamID2.text = "Team ID 2: " + revelsCupDataSource[indexPath.row].team2
    cell.sportVenue.text = revelsCupDataSource[indexPath.row].venue
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.bounds.width - 10, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  override func reloadData() {
    refreshControl.endRefreshing()
  }
  
  func fetchRevelsCupData(){
    revelsCupDataSource = revelsCupObject.fetchRevelsCupFromCoreData()
    print(revelsCupDataSource)
  }
  
  
}
