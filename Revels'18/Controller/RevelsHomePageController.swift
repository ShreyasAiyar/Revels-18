//
//  RevelsHomePageController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import WebKit


class RevelsHomePageController: UIViewController,WKUIDelegate {

    var webView:WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK : Change The HomePage URL
        
        let revelsHomePageURL = URL(string: "https://alpha.mitrevels.in/index.php")
        let myRequest = URLRequest(url: revelsHomePageURL!)
        self.webView!.load(myRequest)

    }
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView!

    }
    

    


}
