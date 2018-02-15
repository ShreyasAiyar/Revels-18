//
//  QRPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 14/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import CoreImage
import NVActivityIndicatorView

class QRPage: UIViewController,NVActivityIndicatorViewable {
  
  enum Status<T>:Error{
    case Success(T)
    case Error(String)
  }
  
  var cookieValue:String!
  
  
  @IBOutlet weak var delegateID: UILabel!
  @IBOutlet weak var regno: UILabel!
  @IBOutlet weak var phoneNumber: UILabel!
  @IBOutlet weak var email: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var QRView: UIImageView!
  @IBOutlet weak var welcomeMessage: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authenticateUser()
    
  }
  
  
  
  @IBAction func didSelectDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didSelectGenerateQRCode(_ sender: Any) {

  }
  
  @IBAction func didSelectLogoutButton(_ sender: Any) {
    let defaults = UserDefaults.standard
    defaults.set(false, forKey: "LoggedIn")
    defaults.set("", forKey: "Cookie")
    let alertViewController = UIAlertController(title: "Logout?", message: "Are you sure you want to logout", preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
      self.dismiss(animated: true, completion: nil)
    }))
    alertViewController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    present(alertViewController, animated: true, completion: nil)
  }
  
  func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)
      if let output = filter.outputImage?.applying(transform) {
        return UIImage(ciImage: output)
      }
    }
    
    return nil
  }
  
  
  func authenticateUser(){
    startAnimating()
    let defaults = UserDefaults.standard
    cookieValue = defaults.object(forKey: "Cookie") as! String
    getData(cookieValue: cookieValue) { (status) in
      switch status{
      case .Success(let parsedJSON):
        print(parsedJSON)
        self.welcomeMessage.text = "Name: " + (parsedJSON["student_name"] as? String)!
        self.delegateID.text = parsedJSON["student_delno"] as? String
        self.regno.text = parsedJSON["student_regno"] as? String
        self.phoneNumber.text = parsedJSON["student_phone"] as? String
        self.email.text = parsedJSON["student_mail"] as? String
        self.location.text = parsedJSON["student_college"] as? String
        self.QRView.image = self.generateQRCode(from: (parsedJSON["qr"] as? String)!)
        self.stopAnimating()
      case .Error(let error):
        print(error)
      }
    }
  }
  
  func getData(cookieValue:String,completion:@escaping(Status<[String:Any]>)->()){
    let loginURL = URL(string: "https://mitportals.in/includes/getDetails.php")
    var request = URLRequest(url: loginURL!)
    let newCookie = "PHPSESSID=" + cookieValue
    NSLog(newCookie)
    request.addValue(newCookie, forHTTPHeaderField: "Cookie")
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      guard error == nil else{
        return completion(.Error("Error. Please Check Your Internet Connection"))
      }
      guard let data = data else{
        return completion(.Error("Error. Please Check Your Internet Connection"))
      }
      let dataString:String! = String(data:data,encoding: .utf8)
      let jsonData = dataString.data(using: .utf8)!
      guard let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else{
        return
      }
      DispatchQueue.main.async {
        if let parsedJSON = parsedJSON{
          completion(.Success(parsedJSON))
        }else{
          completion(.Error("No Data. Check Your Internet Connection"))
        }
      }
    }
    task.resume()
  }
}
