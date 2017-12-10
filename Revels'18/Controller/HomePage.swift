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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
        }
        
        let imageFrame:CGRect = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!+20, width:
            (self.navigationController?.navigationBar.frame.width)!, height: 150)
        
        
        
        let image:UIImageView = UIImageView(frame: imageFrame)
        image.image = UIImage(named: "Revels Banner")
        tableView.tableHeaderView = image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        cell.backgroundColor = UIColor.lightGray
        cell.layer.cornerRadius = 10
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionHeaders[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width
            , height: 80)
        let headerView = UIView(frame: headerFrame)
        
        
        let labelFrame:CGRect = CGRect(x: 10, y: 0, width: 100, height: 50)

        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.text = "Categories"
        headerLabel.textColor = UIColor.red
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
        headerView.addSubview(headerLabel)
        
        
        let headerButton:UIButton = UIButton(type: UIButtonType.system)
        headerButton.setTitle("More", for: UIControlState.normal)
        headerButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        let buttonFrame:CGRect = CGRect(x: (view.frame.width - 70), y: 0, width: 80, height: 50)
        headerButton.frame = buttonFrame
        headerView.addSubview(headerButton)
        
        
        return headerView
    }
    
    @IBAction func moreButtonClicked(_ sender: UIBarButtonItem) {
    
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
   
    

}
