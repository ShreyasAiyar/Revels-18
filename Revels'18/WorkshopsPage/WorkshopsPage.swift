//
//  WorkshopsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class WorkshopsPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  
  var workshopsDataSource:[Workshops] = []
  let workshopsNetworking = WorkshopsNetworking()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return workshopsDataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkshopsCell", for: indexPath)
    return cell
  }
  
  func fetchWorkshopsFromCoreData(){
    self.workshopsDataSource = workshopsNetworking.fetchWorkshopsFromCoreData()
  }
  
  
}
