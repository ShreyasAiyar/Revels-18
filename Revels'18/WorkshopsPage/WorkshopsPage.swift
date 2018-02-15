//
//  WorkshopsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class WorkshopsPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,WorkshopsFunctions,UICollectionViewDelegateFlowLayout {
  
  
  var workshopsDataSource:[Workshops] = []
  let workshopsNetworking = WorkshopsNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchWorkshopsFromCoreData()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return workshopsDataSource.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.width - 10, height: 180)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkshopsCell", for: indexPath) as! WorkshopsCell
    cell.delegate = self
    cell.position = indexPath.row
    cell.date.text = workshopsDataSource[indexPath.row].wshuru + "-" + workshopsDataSource[indexPath.row].wkhatam
    cell.name.text = workshopsDataSource[indexPath.row].cname
    cell.location.text = workshopsDataSource[indexPath.row].wvenue
    cell.price.text = workshopsDataSource[indexPath.row].wcost
    cell.workshopName.text = workshopsDataSource[indexPath.row].wname
    return cell
  }
  
  func fetchWorkshopsFromCoreData(){
    self.workshopsDataSource = workshopsNetworking.fetchWorkshopsFromCoreData()
  }
  
  func selectedInfoButton(position: Int) {
    let alertController = UIAlertController(title: workshopsDataSource[position].wname, message: workshopsDataSource[position].wdesc, preferredStyle: .alert)
    present(alertController, animated: true, completion: nil)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  }
  
  func selectedCallButton(position: Int) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
  
  @IBAction func didSelectDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  

  
  
  
  
}
