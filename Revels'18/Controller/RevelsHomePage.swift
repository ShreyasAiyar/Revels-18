//
//  RevelsHomePageController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import WebKit


class RevelsHomePage: UIViewController,WKUIDelegate {

    var webView: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mainView: UIView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame:  mainView.frame, configuration: webConfiguration)
        webView.uiDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.theverge.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
}
    


