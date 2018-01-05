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
    let httpRequestObject = HTTPRequest()
    let categoryNetworkingObject = CategoriesNetworking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesMain()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func categoriesMain(){
        startAnimating()
        let categoriesURL = "https://api.mitportals.in/categories/"
        var categories:[Categories] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: categoriesURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for category in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let categoryObject = Categories(dictionary: category)
                    categories.append(categoryObject)
                }
                self.stopAnimating()
                self.categoriesDataSource = categories
                self.categoryNetworkingObject.saveCategoriesToCoreData(categoryData: categories)
                self.categoriesCollectionView.reloadSections([0])
                
            case .Error(let errorMessage):
                DispatchQueue.main.async {
                    print(errorMessage)
                    self.stopAnimating()
                    self.categoriesDataSource = self.categoryNetworkingObject.fetchCategoriesFromCoreData()
                }
            }
        }
        
    }
    
  
    
    
    

    


}
