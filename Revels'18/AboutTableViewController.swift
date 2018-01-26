//
//  AboutTableViewController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 20/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }

  @IBAction func didSelectDismissButton(_ sender: Any) {
  dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didSelectTwitterbutton(_ sender: UIButton) {
    let myURL = URL(string: "https://twitter.com/revelsmit")
    let safariViewController = SFSafariViewController(url: myURL!)
    self.present(safariViewController, animated: true,completion: nil)
  }

  @IBAction func didSelectYoutubeButton(_ sender: UIButton) {
    let myURL = URL(string: "https://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw")
    let safariViewController = SFSafariViewController(url: myURL!)
    self.present(safariViewController, animated: true,completion: nil)
  }
  
  @IBAction func didSelectInstagramButton(_ sender: UIButton) {
    let myURL = URL(string: "https://www.instagram.com/revelsmit")
    let safariViewController = SFSafariViewController(url: myURL!)
    self.present(safariViewController, animated: true,completion: nil)
  }
  
  @IBAction func didSelectFacebookButton(_ sender: UIButton) {
    let myURL = URL(string: "https://www.facebook.com/mitrevels/")
    let safariViewController = SFSafariViewController(url: myURL!)
    self.present(safariViewController, animated: true,completion: nil)
  }
  
  
  
  
}
