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
  
  @objc func moreButtonClicked(){
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let aboutAction =  UIAlertAction(title: "About Revels", style: .default){
      Void in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutRevels")
      self.present(aboutViewController, animated: true, completion: nil)
    }
    
//    let proshowAction = UIAlertAction(title: "Proshow Portal", style: .default){
//      Void in
//      let myURL = URL(string: "http://alpha.mitrevels.in/index.php")
//      let safariViewController = SFSafariViewController(url: myURL!)
//      self.present(safariViewController, animated: true,completion: nil)
//    }
    
    let developerAction = UIAlertAction(title: "Developers", style: .default){
      Void in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let developerViewController = storyboard.instantiateViewController(withIdentifier: "DevelopersPage")
      self.present(developerViewController, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
    
    let workshopAction = UIAlertAction(title: "Workshops", style: .default) { (_) in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let workshopsViewController = storyboard.instantiateViewController(withIdentifier: "WorkshopsPage")
      self.present(workshopsViewController, animated: true, completion: nil)
    }
    
    alertController.addAction(aboutAction)
    alertController.addAction(cancelAction)
    alertController.addAction(developerAction)
    //alertController.addAction(proshowAction)
    alertController.addAction(workshopAction)
    
    present(alertController, animated: true){
    }
  }
  
  // MARK: Create Bar Button Items
  func createBarButtonItems(){
    let color:UIColor = UIColor.white
    let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
    moreButtonItem.image = UIImage(named: "More")
    moreButtonItem.tintColor = color
    
    let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
    reloadDataButtonItem.tintColor = color
    
    let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
    searchBarButtonItem.tintColor = color
    
    
    self.navigationItem.setRightBarButtonItems([moreButtonItem], animated: true)
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
    NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
    NVActivityIndicatorView.DEFAULT_COLOR = UIColor.white
  }

  
  @objc func presentNoNetworkView(primaryMessage:String,secondaryMessage:String,mainImage:String) -> UIView{
    let noDataView = NoDataView()
    noDataView.mainLabel.text = primaryMessage
    noDataView.secondaryLabel.text = secondaryMessage
    noDataView.noDataImageView.image = UIImage(named: mainImage)
    return noDataView
  }
  
  func presentFavoriteView(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let favoritesViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesPage")
    present(favoritesViewController, animated: true, completion: nil)
  }
  
  func convertDate(date:String) -> String{
    let convertedDate = Date(timeIntervalSince1970: Double(date)!)
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day,.hour,.minute,.second], from: convertedDate, to: currentDate)
    
    if components.day! > 0{
      formatter.allowedUnits = .day
    }
    else if components.hour! > 0{
      formatter.allowedUnits = .hour
    }
    else if components.minute! > 0{
      formatter.allowedUnits = .minute
    }
    else{
      formatter.allowedUnits = .second
    }
    let formatString = NSLocalizedString("%@ ago", comment: "Time")
    
    guard let timeString = formatter.string(from: components) else {
      return ""
    }
    return String(format: formatString, timeString)
    
  }
  
}

