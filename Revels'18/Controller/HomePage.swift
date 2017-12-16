//
//  HomePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 10/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import SafariServices

class HomePage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let sectionHeaders:[String] = ["Today's Events","Schedule","Results"]
    let scrollView:UIScrollView = UIScrollView()
    let pinkColor:UIColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)


    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureScrollBar()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureScrollBar(){
        let imageFrame:CGRect = CGRect(x: 0, y: 0, width:self.view.frame.width*2, height: self.view.frame.height/4.2)
        scrollView.frame = imageFrame
        scrollView.delegate = self
        
        let revelsBanner:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
        revelsBanner.image = UIImage(named: "Revels Banner")
        revelsBanner.contentMode = .scaleToFill
        revelsBanner.clipsToBounds = true
        
        let proshowBanner:UIImageView = UIImageView(frame: CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: scrollView.frame.height))
        proshowBanner.image = UIImage(named: "Proshow Banner")
        proshowBanner.contentMode = .scaleToFill
        proshowBanner.clipsToBounds = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        scrollView.addSubview(revelsBanner)
        scrollView.addSubview(proshowBanner)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        tableView.tableHeaderView = scrollView
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    
    //MARK: Change PageWidth When More Images Added
    
    func moveToNextPage(){
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 2
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        cell.backgroundColor = UIColor.white
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionHeaders[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderCell") as! HomeHeaderCell
        headerCell.nameLabel.text = sectionHeaders[section]
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    @IBAction func moreButtonClicked(_ sender: UIBarButtonItem) {
        moreButtonClicked()
    }
}
