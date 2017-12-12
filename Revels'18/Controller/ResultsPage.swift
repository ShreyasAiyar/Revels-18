//
//  ResultsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResultsPage: UIViewController,NVActivityIndicatorViewable {
    
    let segmentLabels:[String] = ["Results","Sports Results"]
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.clipsToBounds = true
        segmentControl.tintColor = pinkColor
    }
    
    
    
    
    
    
    func resultsMain(){
        
    }


    

}
