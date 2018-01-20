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
  
  // MARK: More Button Clicked
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
      let myURL = URL(string: "http://alpha.mitrevels.in/index.php")
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
  
  // MARK: Create Bar Button Items
  func createBarButtonItems(){
    //let color:UIColor = self.view.tintColor
    //let color:UIColor = UIColor.white
    //let color:UIColor = UIColor(red: 224/255, green: 116/255, blue: 40/255, alpha: 1)
    let color:UIColor = UIColor(displayP3Red: 181/255, green: 28/255, blue: 18/255, alpha: 1)
    let moreButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"More"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moreButtonClicked))
    moreButtonItem.image = UIImage(named: "More")
    moreButtonItem.tintColor = color
    
    let reloadDataButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
    reloadDataButtonItem.tintColor = color
    
    let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
    searchBarButtonItem.tintColor = color
    
    
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
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
    //NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor.white
    NVActivityIndicatorView.DEFAULT_COLOR = UIColor.black
  }
  
  func presentEmptyView(){
    if !UIAccessibilityIsReduceTransparencyEnabled() {
      view.backgroundColor = .clear
      let blurEffect = UIBlurEffect(style: .dark)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = (self.tabBarController?.view.bounds)!
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.tabBarController?.view.addSubview(blurEffectView)
    } else {
      view.backgroundColor = .black
    }
  }
  
  func presentNoNetworkView(){
    
  }
  
  func presentFavoriteView(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let favoritesViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesPage")
    self.present(favoritesViewController, animated: true, completion: nil)
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

