//
//  CategoriesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CategoriesPage: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITabBarControllerDelegate,NVActivityIndicatorViewable,UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var categoriesDataSource:[Categories] = []
    var eventsDataSource:[Events] = []
    let httpRequestObject = HTTPRequest()
    let categoryNetworkingObject = CategoriesNetworking()
    let eventsNetworkingObject = EventsNetworking()
    var catid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtonItems()
        configureNavigationBar()
        categoriesMain()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        cell.categoryName.text = categoriesDataSource[indexPath.row].cname
        cell.layer.cornerRadius = 5
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.width - 20)/3
        let height = width + 20
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.catid = categoriesDataSource[indexPath.row].cid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetailSegue"{
            if let categoryDetailController = segue.destination as? CategoriesDetailController{
                categoryDetailController.categoriesDataSource = categoriesDataSource.filter{
                    $0.cid == self.catid
                }.first
//                categoryDetailController.eventsDataSource = self.eventsDataSource.filter{
//                    $0.cid == self.catid
                }
            }
        }
    
    func categoriesMain(){
        startAnimating()
        categoryNetworkingObject.categoriesMain {
            self.categoriesDataSource = self.categoryNetworkingObject.fetchCategoriesFromCoreData()
            self.stopAnimating()
            self.categoriesCollectionView.reloadData()
            self.eventsNetworkingObject.eventsMain {
                self.eventsDataSource = self.eventsNetworkingObject.fetchEventsFromCoreData()
                self.categoriesCollectionView.reloadData()
                self.stopAnimating()
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.categoriesCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    

    


}
