//
//  LastPageViewController.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 01/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class LastPageViewController: UIViewController {
    
    
    @IBOutlet weak var continueButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 8

    }

    @IBAction func continueButtonSelected(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarView")
        self.present(tabBarController, animated: true, completion: nil)
        
    }
    
    
}
