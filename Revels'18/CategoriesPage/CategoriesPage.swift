//
//  CategoriesPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 23/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoriesPage: UICollectionViewController,UITabBarControllerDelegate {
    
    
    let categoriesData:[Categories] = []
    let categoriesURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.delegate = self
    }
  

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.collectionView?.setContentOffset(CGPoint.zero, animated: true)
    }



}
