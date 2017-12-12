//
//  ResultsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResultsPage: UIViewController,NVActivityIndicatorViewable,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    
    let segmentLabels:[String] = ["Results","Sports Results"]
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Configuring Navigation Controller
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.clipsToBounds = true
        segmentControl.tintColor = pinkColor
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
        //MARK: Configuring Search Bar
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        //MARK: Configure Bar Button Items
        createBarButtonItems()
        
    }
    
        func searchButtonPressed() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
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
        
    }
    
    func createBarButtonItems(){
        let moreButtonItem:UIBarButtonItem = UIBarButtonItem()
        moreButtonItem.image = UIImage(named: "More")
        moreButtonItem.tintColor = pinkColor
        
        let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem()
        reloadDataButtonItem.image = UIImage(named: "Synchronize")
        reloadDataButtonItem.tintColor = pinkColor
        
        let searchBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        searchBarButtonItem.image = UIImage(named: "Search")
        searchBarButtonItem.tintColor = pinkColor
        searchBarButtonItem.action = #selector("searchBarPressed")
        
        self.navigationItem.setRightBarButtonItems([moreButtonItem,searchBarButtonItem], animated: true)
        self.navigationItem.setLeftBarButton(reloadDataButtonItem, animated: true)
        
        self.navigationItem.title = "Results"
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        cell.eventName.text = "Conclave"
        cell.roundNo.text = "1"
        
        
        cell.layer.cornerRadius = 10
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width)/5
        let yourHeight = yourWidth + 20
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    
    func resultsMain(){
        
    }

}
    


