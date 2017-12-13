//
//  SchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData

class SchedulePage: UIViewController,NVActivityIndicatorViewable,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cacheCheck = CacheCheck()
    let httpRequestObject = HTTPRequest()
    let scheduleNetworkingObject = ScheduleNetworking()
    let categoriesURL = "https://api.mitportals.in/schedule/"
    var scheduleDataSource:[[NSManagedObject]] = [[]]
    var currentIndex:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    func configureController(){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.clipsToBounds = true

        NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = "Fetching Data..."
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        collectionView.delegate = self
        collectionView.dataSource = self
        //searchBar.delegate = self
        fetchSchedules()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.section].value(forKey: "ename") as! String
        cell.timeLabel.text! = scheduleDataSource[currentIndex][indexPath.section].value(forKey: "stime") as! String
        cell.layer.cornerRadius = 8
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return scheduleDataSource[currentIndex].count
    }
    
    //MARK: Configuring Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.view.frame.width - 20
        let cellheight = CGFloat(80)
        return CGSize(width: cellWidth, height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        currentIndex = segmentedControl.selectedSegmentIndex
        print(currentIndex)
        collectionView.reloadData()
    }

    //MARK: Networking Call - Fetch Schedules
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
                self.collectionView.reloadData()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("You Seem To Be Offline")
                    NSLog("Connection Could Not Be Established")
                }
                
            }
        }
    }
    
    


}
