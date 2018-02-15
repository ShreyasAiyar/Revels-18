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
import AVFoundation
import QRCodeReader


class QRPage: UIViewController,NVActivityIndicatorViewable,QRCodeReaderViewControllerDelegate{
  
  
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
  @IBOutlet var previewView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authenticateUser()
  }
  
  lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
    $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
  })
  
  @IBAction func didSelectRegisterForEvents(_ sender: Any) {
    readerVC.delegate = self
    readerVC.completionBlock = { (result: QRCodeReaderResult?) in
      if let QRString = result?.value{
        self.performEventScanning(with: QRString)
      }
    }
    present(readerVC, animated: true, completion: nil)
  }
  
  
  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()
    dismiss(animated: true, completion: nil)
  }
  
  func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    if let cameraName = newCaptureDevice.device.localizedName {
      print("Switching Capturing To: \(cameraName)")
    }
  }
  
  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    reader.stopScanning()
    dismiss(animated: true, completion: nil)
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
  
  func performEventScanning(with QRString:String){
    startAnimating()
    postEvent(with: QRString) {status in
      self.stopAnimating()
      switch status{
      case .Success(let parsedJSON):
        print(parsedJSON)
        let statusCode = parsedJSON["status"] as! Int
        let alertController = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        switch(statusCode){
        case 0:
          let message = parsedJSON["message"] as! String
          alertController.message = message
          self.present(alertController, animated: true, completion: nil)
        case 1:
          let message = parsedJSON["message"] as! String
          alertController.message = message
          self.present(alertController, animated: true, completion: nil)
        case 2:
          let message = parsedJSON["event_name"] as! String
          alertController.message = "Do You Want To Create A New Team For " + message
          self.present(alertController, animated: true, completion: nil)
          alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.createTeam()
          }))
        case 3:
          let message = "You have already registered"
          alertController.message = message
          self.present(alertController, animated: true, completion: nil)
        default:
          let message = "Unknown Error"
          alertController.message = message
          self.present(alertController, animated: true, completion: nil)
        }
      case .Error(let error):
        NSLog(error)
      }
    }
    
  }
  
  func postEvent(with QRString:String,completion:@escaping (Status<[String:Any]>)->()){
    let getEventURL = URL(string: "https://mitportals.in/includes/eventReg.php")
    var request = URLRequest(url: getEventURL!)
    let paramString = "qr=" + QRString
    print("QR String Is" + QRString)
    let newCookie = "PHPSESSID=" + cookieValue
    request.addValue(newCookie, forHTTPHeaderField: "Cookie")
    request.httpBody = paramString.data(using: .utf8)
    request.httpMethod = "POST"
    
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
  
  @IBAction func didSelectDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func addTeam(){
    
  }
  
  func createTeam(){
    NSLog("Creating Team...")
    confirmTeamDetails { (status) in
      switch status{
      case .Success(let parsedJSON):
        let alertController = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        let statusCode = parsedJSON["status"] as! Int
        let message = parsedJSON["message"] as! String
        alertController.message = message
        switch statusCode{
        case -1:
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        case 0:
          print("First Scan Of QR")
        case 1:
          print("Already Registered...")
        case 2:
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        case 3:
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        default:
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        }
      case .Error(let error):
        NSLog(error)
      }
    }
  }
  
  func confirmTeamDetails(completion:@escaping (Status<[String:Any]>)->()){
    let createTeamURL = URL(string: "https://mitportals.in/includes/create-team.php")
    let newCookie = "PHPSESSID=" + cookieValue
    var request = URLRequest(url: createTeamURL!)
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
