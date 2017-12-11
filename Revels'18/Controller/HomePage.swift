//
//  HomePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 10/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class HomePage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let sectionHeaders:[String] = ["Events","Schedule","Results"]
    let scrollView:UIScrollView = UIScrollView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//        } else {
//        }
        
        let imageFrame:CGRect = CGRect(x: 0, y: 0, width:self.view.frame.width*2, height: self.view.frame.height/4.5)
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
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width
            , height: 80)
        let headerView = UIView(frame: headerFrame)
        
        
        let labelFrame:CGRect = CGRect(x: 10, y: 0, width: 100, height: 50)

        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.textColor = UIColor.red
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
        headerView.addSubview(headerLabel)
        
        let headerButton:UIButton = UIButton(type: UIButtonType.system)
        headerButton.setTitle("More", for: UIControlState.normal)
        headerButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        let buttonFrame:CGRect = CGRect(x: (view.frame.width - 70), y: 0, width: 80, height: 50)
        headerButton.frame = buttonFrame
        headerView.addSubview(headerButton)
        
        if(section == 0){
            headerLabel.text = "Categories"
        }
        else if(section == 1){
            headerLabel.text = "Events"
        }
        else if(section == 2){
            headerLabel.text = "Results"
        }
        
        
        return headerView
    }
    
    @IBAction func moreButtonClicked(_ sender: UIBarButtonItem) {
    
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.red
        let aboutAction =  UIAlertAction(title: "About Revels", style: .default){
            Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutRevels")
            self.present(aboutViewController, animated: true, completion: nil)
        }
        let developerAction = UIAlertAction(title: "Developers", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let proshowAction = UIAlertAction(title: "Proshow Portal", style: .default, handler: nil)
        
        alertController.addAction(aboutAction)
        alertController.addAction(cancelAction)
        alertController.addAction(developerAction)
        alertController.addAction(proshowAction)
        
        present(alertController, animated: true){
        }
    }
    
    
    
   
    

}
