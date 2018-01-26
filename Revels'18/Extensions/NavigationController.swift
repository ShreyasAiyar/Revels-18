//
//  NavigationController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 26/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  
  func hideHairline() {
    findHairline()?.isHidden = true
  }
  
  func showHairline() {
    findHairline()?.isHidden = false
  }
  
  func findHairline() -> UIImageView? {
    return navigationController?.navigationBar.subviews
      .flatMap { $0.subviews }
      .flatMap { $0 as? UIImageView }
      .filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
      .filter { $0.bounds.size.height <= 2 }
      .first
  }

  
}
