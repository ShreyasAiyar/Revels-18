//
//  DevelopersPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class DevelopersPage: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var developerDataSource:[Developers] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDeveloperController()
    }
    
    func configureDeveloperController(){
        let shreyasImage = UIImage(named: "Proshow Banner")
        let shreyasDeveloper = Developers(developerName: "Shreyas", developerImage: shreyasImage, developerPosition: "Cathead", developerMessage: "Supermarine")
        developerDataSource.append(shreyasDeveloper)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return developerDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeveloperCell") as! DeveloperCell
        cell.developerName.text = developerDataSource[indexPath.row].developerName
        cell.developerImage.image = developerDataSource[indexPath.row].developerImage!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertTitle = developerDataSource[indexPath.row].developerPosition
        let alertMessage = developerDataSource[indexPath.row].developerMessage
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
