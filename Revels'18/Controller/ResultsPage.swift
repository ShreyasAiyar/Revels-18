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
    //var searchBarButtonItem: UIBarButtonItem?
    
    
    
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
        let developerAction = UIAlertAction(title: "Developers", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let proshowAction = UIAlertAction(title: "Proshow Portal", style: .default, handler: nil)
        
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        alertController.addAction(developerAction)
        alertController.addAction(proshowAction)
        
        present(alertController, animated: true){
        }
    }
    
    
    func reloadData(){
        
    }
    
    //MARK: Create Bar Button Items Programatically
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
    
    
    //MARK: Collection View Methods
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

    //MARK: Get JSON Data
    func resultsMain(){
        
    }

}
    


