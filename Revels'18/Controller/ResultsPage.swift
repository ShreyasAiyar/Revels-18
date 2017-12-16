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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
        configureNavigationBar()
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
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
        
    }
    
    //MARK: Collection View Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        cell.eventName.text = "Conclave"
        cell.roundNo.text = "1"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
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
        
    }

}
    


