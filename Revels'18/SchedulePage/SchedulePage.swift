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

class SchedulePage: UIViewController,NVActivityIndicatorViewable,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AddToFavoritesProtocol{
    
    @IBOutlet var favoritesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Creating Objects
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        favoritesView.layer.cornerRadius = 5
        createBarButtonItems()
        configureNavigationBar()
        fetchSchedules()
    }
    
    func addToFavorites(eid:String) {
        scheduleNetworkingObject.addFavoritesToCoreData(eid: eid)
        self.view.addSubview(favoritesView)
        favoritesView.center = self.tableView.center
        favoritesView.alpha = 0
        favoritesView.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.5){
            self.favoritesView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.favoritesView.alpha = 1
        }
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [.curveEaseIn], animations: {
            self.favoritesView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.favoritesView.alpha = 0
        }){ (success:Bool) in
            self.favoritesView.removeFromSuperview()
        }
    }
    
//   @IBAction func doneButtonSelected(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.favoritesView.alpha = 0
//        }){ (success:Bool) in
//            self.favoritesView.removeFromSuperview()
//        }
//    }
    
    
    //MARK: Reload Data When Reload Button Clicked
    override func reloadData(){
        //fetchSchedules()
        self.scheduleDataSource = scheduleNetworkingObject.fetchScheduleFromCoreData()
        self.tableView.reloadData()
    }

    //MARK: Configure Search Button
     override func searchButtonPressed() {
        super.searchButtonPressed()
        searchBar.text = ""
        searchBar.prompt = "Search Here"
        searchBar.showsCancelButton = true
        searchBar.alpha = 1
        navigationItem.titleView = searchBar
        self.searchBar.becomeFirstResponder()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        hideSearchBar()
        tableView.reloadData()
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleDataSource[currentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.delegate = self
        cell.eid = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "eid") as! String
        cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "ename") as! String
        cell.time.text! = (scheduleDataSource[currentIndex][indexPath.row ].value(forKey: "stime") as! String) + " - " + (scheduleDataSource[currentIndex][indexPath.section].value(forKey: "etime") as! String)
        cell.location.text! = scheduleDataSource[currentIndex][indexPath.row].value(forKey: "venue") as! String
        print(scheduleDataSource[currentIndex][indexPath.row].value(forKey: "favorite") as! Bool)
        if(scheduleDataSource[currentIndex][indexPath.row].value(forKey: "favorite") as! Bool  == true){
            cell.favouriteButton.isSelected = true
        }
        else{
            cell.favouriteButton.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelectedIndex[currentIndex] = indexPath.row
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == isSelectedIndex[currentIndex]{
            return CGFloat(150)
        }
        else{
            return CGFloat(80)
        }
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
                    self.stopAnimating()
                    self.scheduleDataSource = self.scheduleNetworkingObject.fetchScheduleFromCoreData()
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    


}
