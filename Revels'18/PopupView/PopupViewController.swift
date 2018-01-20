//
//  PopupViewController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 20/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
  
  @IBOutlet weak var popupView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    popupView.layer.cornerRadius = 10
    popupView.layer.masksToBounds = true
  }
  @IBAction func doneButtonSelected(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
