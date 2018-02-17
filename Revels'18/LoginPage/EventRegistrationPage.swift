//
//  EventRegistrationPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import NVActivityIndicatorView

class EventRegistrationPage: UIViewController,QRCodeReaderViewControllerDelegate,NVActivityIndicatorViewable{
  
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var teamID: UILabel!
  @IBOutlet weak var presentTeamSize: UILabel!
  @IBOutlet weak var maxTeamSize: UILabel!
  
  var eventNameValue:String?
  var teamIDValue:String?
  var presentTeamSizeValue:Int?
  var maxTeamSizeValue:String?
  
  lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
    $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
  })
  
  
  enum Status<T>:Error{
    case Success(T)
    case Error(String)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setValues()
    createTeam()
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
  
  func setValues(){
    eventName.text = eventNameValue!
    teamID.text = teamIDValue!
    presentTeamSize.text = "\(presentTeamSizeValue!)"
    maxTeamSize.text = maxTeamSizeValue!
  }
  
  
  @IBAction func didSelectDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didSelectScanQRCodeButton(_ sender: Any) {
    readerVC.delegate = self
    readerVC.completionBlock = { (result: QRCodeReaderResult?) in
      if let QRString = result?.value{
        NSLog(QRString)
        self.addTeamMate(with: QRString)
      }
    }
    self.present(self.readerVC, animated: true, completion: nil)
    
  }
  
  
  func createTeam(){
    startAnimating()
    NSLog("Creating Team...")
    confirmTeamDetails { (status) in
      self.stopAnimating()
      switch status{
      case .Success(let parsedJSON):
        print(parsedJSON)
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
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        case 1:
          alertController.message = "Add Teammates"
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
        case 4:
          print("Success Scenario")
          let teamID = parsedJSON["team_id"] as! Int
          self.teamID.text = "\(teamID)"
          alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
          self.present(alertController, animated: true, completion: nil)
        default:
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
          }))
          self.present(alertController, animated: true, completion: nil)
        }
      case .Error(let error):
        DispatchQueue.main.async {
          let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  // MARK: GET Request
  
  func confirmTeamDetails(completion:@escaping (Status<[String:Any]>)->()){
    let createTeamURL = URL(string: "https://mitportals.in/includes/create-team.php")
    let defaults = UserDefaults.standard
    let cookieValue = defaults.value(forKey: "Cookie") as! String
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
  
  // MARK: Add Teammate
  
  func addTeamMate(with QRString:String){
    startAnimating()
    postTeamMateDetails(with: QRString, completion: { (status) in
        self.stopAnimating()
        switch(status){
        case .Success(let parsedJSON):
          let statusCode = parsedJSON["status"] as! Int
          let message = parsedJSON["message"] as! String
          let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alertController, animated: true, completion: nil)
          if(statusCode == 4){
            let count = Int(self.presentTeamSize.text!)
            self.presentTeamSize.text = "\(count! + 1)"
          }
          
        case .Error(let error):
          DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
          }
        }
      
    })
    
  }
  
  func postTeamMateDetails(with QRString:String,completion:@escaping (Status<[String:Any]>)->()){
    let addTeamMateURL = URL(string: "https://mitportals.in/includes/add-to-team.php")
    let defaults = UserDefaults.standard
    let cookieValue = defaults.value(forKey: "Cookie") as! String
    let newCookie = "PHPSESSID=" + cookieValue
    var request = URLRequest(url: addTeamMateURL!)
    request.addValue(newCookie, forHTTPHeaderField: "Cookie")
    request.httpMethod = "POST"
    let paramString = "qr=" + QRString
    request.httpBody = paramString.data(using: .utf8)
    
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
