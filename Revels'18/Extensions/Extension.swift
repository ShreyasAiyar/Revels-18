//
//  Extension.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 15/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import NVActivityIndicatorView

extension UIViewController{
    
    func moreButtonClicked(){
        let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
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
    
    func createBarButtonItems(){
        let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
        let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
        moreButtonItem.image = UIImage(named: "More")
        moreButtonItem.tintColor = pinkColor
        
        let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        reloadDataButtonItem.tintColor = pinkColor
        
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        searchBarButtonItem.tintColor = pinkColor
        
        self.navigationItem.setRightBarButtonItems([moreButtonItem,searchBarButtonItem], animated: true)
        self.navigationItem.setLeftBarButton(reloadDataButtonItem, animated: true)
    }
    
    func reloadData(){
        
    }
    
    func searchButtonPressed(){
    }
    
    func hideSearchBar(){
        navigationItem.titleView = nil
        createBarButtonItems()
    }
    
    func configureNavigationBar(){
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.clipsToBounds = true
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
    }
    
    
}
