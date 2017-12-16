//
//  SchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreData

class SchedulePage: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Creating Objects
    let cacheCheck = CacheCheck()
    let httpRequestObject = HTTPRequest()
    let scheduleNetworkingObject = ScheduleNetworking()
    let categoriesURL = "https://api.mitportals.in/schedule/"
    var scheduleDataSource:[[NSManagedObject]] = [[]]
    var currentIndex:Int = 0
    var isSelected:[[Bool]] = [[]]
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        createBarButtonItems()
        configureNavigationBar()
        fetchSchedules()
    }
    
    //MARK: Reload Data When Reload Button Clicked
    override func reloadData(){
        fetchSchedules()
        self.tableView.reloadData()
    }

    //MARK: Configure Search Button
    override func searchButtonPressed() {
        searchBar.alpha = 0
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
        navigationItem.titleView = searchBar
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleDataSource[currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "ename") as! String
        cell.time.text! = (scheduleDataSource[currentIndex][indexPath.row ].value(forKey: "stime") as! String) + " - " + (scheduleDataSource[currentIndex][indexPath.section].value(forKey: "etime") as! String)
        cell.location.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "venue") as! String
        
        return cell
    }
    
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        currentIndex = segmentedControl.selectedSegmentIndex
        print(currentIndex)
        tableView.reloadData()
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
                self.tableView.reloadData()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("You Seem To Be Offline")
                }
                
            }
        }
    }
    
    


}
