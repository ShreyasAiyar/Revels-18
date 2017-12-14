//
//  RevelsHomePageController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import WebKit
import SafariServices


class RevelsHomePage: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.theverge.com")
        let safariViewController = SFSafariViewController(url: myURL!)
        present(safariViewController, animated: true, completion: nil)
    }
    
    
}
    


