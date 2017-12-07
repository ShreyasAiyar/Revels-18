//
//  AboutRevelsPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 05/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class AboutRevelsPage: UIViewController {

    
    @IBOutlet weak var aboutRevelsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutRevelsTextView.isEditable = false
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
