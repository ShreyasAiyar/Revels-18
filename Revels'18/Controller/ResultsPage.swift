//
//  ResultsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CoreData

class ResultsPage: UIViewController,NVActivityIndicatorViewable,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    
    let segmentLabels:[String] = ["Results","Sports Results"]
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    let resultsURL = "https://api.mitportals.in/results/"
    let resultNetworkingObject = ResultNetworking()
    var resultsDataSource:[NSManagedObject] = []
    let httpRequestObject = HTTPRequest()
    var searchBar = UISearchBar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsMain()
        createBarButtonItems()
        configureNavigationBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
    }

    
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
    

    override func reloadData(){
        resultsMain()
        self.resultsCollectionView.reloadData()
    }
    
    //MARK: Collection View Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        cell.eventName.text = resultsDataSource[indexPath.row].value(forKey: "eve") as? String
        cell.roundNo.text = resultsDataSource[indexPath.row].value(forKey: "round") as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsDataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (self.view.bounds.width)/5 - 10
        let yourHeight = yourWidth + 20
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    //MARK: Get JSON Data
    func resultsMain(){
        startAnimating()
        var results:[Results] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: resultsURL){
            status in
            switch status{
            case .Success(let parsedJSON):
                for result in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let resultObject = Results(dictionary: result)
                    results.append(resultObject)
                }
                self.resultNetworkingObject.saveResultsToCoreData(resultData: results)
                self.resultsDataSource = self.resultNetworkingObject.fetchResultsFromCoreData()
                self.stopAnimating()
                self.resultsCollectionView.reloadData()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("You Seem To Be Offline")
                }
                
            }
        }
        
    }

}
    


