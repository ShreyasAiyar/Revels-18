 //
//  CategoriesDetailController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class CategoriesDetailController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let sectionHeaders:[String] = ["Day 1","Day 2","Day 3","Day 4"]
    var categoriesDataSource:Categories?
    var scheduleDataSource:[Schedules]?
    let scheduleNetworkingObject = ScheduleNetworking()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
        fetchSchedules()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func createBarButtonItems() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchDown)
        let barButton = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func infoButtonTapped(){
        let alertController:UIAlertController = UIAlertController(title: categoriesDataSource?.cname, message: categoriesDataSource?.cdesc, preferredStyle: .alert)
        let dismissAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell") as! CategoryDetailCell
        switch(indexPath.section){
        case 0:
            cell.dataSource = scheduleDataSource!.filter{return $0.day == "1"}
        case 1:
            cell.dataSource = scheduleDataSource!.filter{return $0.day == "2"}
        case 2:
            cell.dataSource = scheduleDataSource!.filter{return $0.day == "3"}
        case 3:
            cell.dataSource = scheduleDataSource!.filter{return $0.day == "4"}
        default:
            print("No Data")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sectionHeaders[section]
    }
    
    func fetchSchedules(){
        let data = scheduleNetworkingObject.fetchScheduleFromCoreData()
        scheduleDataSource = data.filter{
            return $0.catid == self.categoriesDataSource?.cid
        }
        tableView.reloadData()
    }
}
