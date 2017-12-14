//
//  SchedulePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SafariServices
import CoreData

class SchedulePage: UIViewController,NVActivityIndicatorViewable,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar = UISearchBar()
    
    
    //MARK: Creating Objects
    let cacheCheck = CacheCheck()
    let httpRequestObject = HTTPRequest()
    let scheduleNetworkingObject = ScheduleNetworking()
    let categoriesURL = "https://api.mitportals.in/schedule/"
    var scheduleDataSource:[[NSManagedObject]] = [[]]
    var currentIndex:Int = 0
    let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
        configureController()
    }
    
    func configureController(){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.clipsToBounds = true

        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        collectionView.delegate = self
        collectionView.dataSource = self
        //searchBar.delegate = self
        fetchSchedules()
        
    }
    
    
    //MARK: Creating Search Bar Programatically
    func createBarButtonItems(){
        let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
        moreButtonItem.image = UIImage(named: "More")
        moreButtonItem.tintColor = pinkColor
        
        let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"Synchronize"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(reloadData))
        reloadDataButtonItem.tintColor = pinkColor
        
        let searchBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"Search"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(searchButtonPressed))
        searchBarButtonItem.tintColor = pinkColor
        
        self.navigationItem.setRightBarButtonItems([moreButtonItem,searchBarButtonItem], animated: true)
        self.navigationItem.setLeftBarButton(reloadDataButtonItem, animated: true)
        self.navigationItem.title = "Results"
        
    }
    //MARK: Reload Data When Reload Button Clicked
    func reloadData(){
        
    }
    
    //MARK: More Button Clicked
    func moreButtonClicked(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = pinkColor
        let aboutAction =  UIAlertAction(title: "About Revels", style: .default){
            Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutRevels")
            self.present(aboutViewController, animated: true, completion: nil)
        }
        
        let proshowAction = UIAlertAction(title: "Proshow Portal", style: .default){
            Void in
            let myURL = URL(string: "https://www.theverge.com")
            let safariViewController = SFSafariViewController(url: myURL!)
            self.present(safariViewController, animated: true,completion: nil)
        }
        
        let developerAction = UIAlertAction(title: "Developers", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        alertController.addAction(developerAction)
        alertController.addAction(proshowAction)
        
        present(alertController, animated: true){
        }
    }
    
    
    //MARK: Configure Search Button
    func searchButtonPressed() {
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
    
    func hideSearchBar(){
        navigationItem.titleView = nil
        createBarButtonItems()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        cell.eventName.text! = scheduleDataSource[currentIndex][indexPath.section].value(forKey: "ename") as! String
        cell.time.text! = (scheduleDataSource[currentIndex][indexPath.section].value(forKey: "stime") as! String) + " - " + (scheduleDataSource[currentIndex][indexPath.section].value(forKey: "etime") as! String)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return scheduleDataSource[currentIndex].count
    }
    
    //MARK: Configuring Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.view.frame.width
        let cellheight = CGFloat(80)
        return CGSize(width: cellWidth, height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: CGFloat(1))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let separatorLine = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ScheduleHeader", for: indexPath)
        let separatorFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat(1))
        separatorLine.frame = separatorFrame
        separatorLine.backgroundColor = UIColor.black
        return separatorLine
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
