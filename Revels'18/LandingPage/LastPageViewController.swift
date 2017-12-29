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
        
        continueButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        continueButton.layer.cornerRadius = 5
        continueButton.alpha = 0
        self.continueButton.frame.origin.y -= 20
        UIView.animate(withDuration: 1){
            self.continueButton.frame.origin.y += 20
            self.continueButton.alpha = 1.0
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    

    @IBAction func continueButtonSelected(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarView")
        self.present(tabBarController, animated: true, completion: nil)
        
    }
    
    
    
    
}
