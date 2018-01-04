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
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
        
        let developerAction = UIAlertAction(title: "Developers", style: .default){
            Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let developerViewController = storyboard.instantiateViewController(withIdentifier: "DevelopersPage")
            self.present(developerViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        alertController.addAction(developerAction)
        alertController.addAction(proshowAction)
        
        present(alertController, animated: true){
        }
    }
    
    func createBarButtonItems(){
        let whiteColor:UIColor = UIColor.white
        let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
        moreButtonItem.image = UIImage(named: "More")
        moreButtonItem.tintColor = whiteColor
        
        let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        reloadDataButtonItem.tintColor = whiteColor
        
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        searchBarButtonItem.tintColor = whiteColor
        
        
        self.navigationItem.setRightBarButtonItems([moreButtonItem,searchBarButtonItem], animated: true)
        self.navigationItem.setLeftBarButton(reloadDataButtonItem, animated: true)
    }
    
    func reloadData(){
        
    }
    
    func searchButtonPressed(){
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
    }
    
    func hideSearchBar(){
        navigationItem.titleView = nil
        createBarButtonItems()
    }
    
    func configureNavigationBar(){
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
    }
    
    func presentEmptyView(){
        
    }
    
    func presentNoNetworkView(){
        
    }
    
    
}
