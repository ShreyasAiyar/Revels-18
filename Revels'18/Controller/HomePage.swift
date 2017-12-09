//
//  HomePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 08/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class HomePage: UITableViewController {
    
    let sectionHeaders:[String] = ["Events","Schedule","Results"]
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageFrame:CGRect = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!+20, width:
            (self.navigationController?.navigationBar.frame.width)!, height: 150)

        let image:UIImageView = UIImageView(frame: imageFrame)
        image.image = UIImage(named: "Revels Banner")
        self.tableView.tableHeaderView = image
        
        self.tableView.rowHeight = 110
        self.tableView.sectionIndexColor = UIColor.red
        
        self.tableView.backgroundColor = UIColor.lightGray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.white
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        cell.firstLabel.text = "Conclave"
        cell.secondLabel.text = "Conclave"
        cell.thirdLabel.text = "Conclave"
        cell.fourthLabel.text = "Conclave"
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
        cell.backgroundColor = UIColor.white
        
        return cell


    }
    
    

}
