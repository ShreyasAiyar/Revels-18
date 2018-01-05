//
//  NewSchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 05/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import UIKit
import NVActivityIndicatorView
import CoreData


class NewSchedulePage: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,NVActivityIndicatorPresenter {
    
    let cacheCheck = CacheCheck()
    let httpRequestObject = HTTPRequest()
    let scheduleNetworkingObject = ScheduleNetworking()
    let categoriesURL = "https://api.mitportals.in/schedule/"
    var scheduleDataSource:[[NSManagedObject]] = [[]]
    var filteredDataSource:[[NSManagedObject]] = [[]]
    var currentIndex:Int = 0
    var searchBar = UISearchBar()
    var shouldShowSearchResults = false
    var isSelectedIndex:[Int] = [-1,-1,-1,-1]

    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewScheduleCell", for: indexPath) as! NewScheduleCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        let height = 70
        return CGSize(width: width, height: height)

    }
    
    func fetchSchedules(){
        startAnimating()
        var schedules:[Schedules] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: categoriesURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for schedule in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let scheduleObject = Schedules(dictionary: schedule)
                    schedules.append(scheduleObject)
                }
                self.scheduleNetworkingObject.saveSchedulesToCoreData(scheduleData: schedules)
                self.scheduleDataSource = self.scheduleNetworkingObject.fetchScheduleFromCoreData()
                self.stopAnimating()
                self.tableView.reloadSections([0], with: .left)
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.scheduleDataSource = self.scheduleNetworkingObject.fetchScheduleFromCoreData()
                    self.tableView.reloadSections([0], with: .left)
                }
                
            }
        }
    }
    
 
    


}
