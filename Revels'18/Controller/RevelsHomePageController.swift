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
        
        let revelsHomePageURL = URL(string: "http://alpha.mitrevels.in/index.php")
        let myRequest = URLRequest(url: revelsHomePageURL!)
        webView.load(myRequest)

    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    

    


}
