//
//  LoginPage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 13/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SafariServices

class LoginPage: UIViewController,NVActivityIndicatorViewable,UITextFieldDelegate{
  
  enum Status<T>:Error{
    case Success(T)
    case Error(String)
  }
  
  let url = URL(string:"https://mitportals.in/includes/login.php")
  let loginURL = URL(string: "mitportals.in/includes/getDetails.php")
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  var cookieValue:String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.cornerRadius = 5
    signUpButton.layer.cornerRadius = 5
    setupTextField()
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
      nextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return false
  }
  
  
  func setupTextField(){
    let userView = UIImageView(frame: CGRect(x: 20, y: 0, width: 25, height: 25))
    let passView = UIImageView(frame: CGRect(x: 20, y: 0, width: 25, height: 25))
    userNameTextField.leftViewMode = .always
    passwordTextField.leftViewMode = .always
    userView.image = UIImage(named: "Email")
    passView.image = UIImage(named: "Password")
    userNameTextField.leftView = userView
    passwordTextField.leftView = passView
    userNameTextField.tag = 0
    passwordTextField.tag = 1
    userNameTextField.delegate = self
    passwordTextField.delegate = self
  }

  @IBAction func didSelectContinueAsGuest(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func didSelectLoginButton(_ sender: Any) {
    if(!(userNameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!){
      performLogin(completion: { (status) in
        self.stopAnimating()
        switch status{
        case .Success(let parsedJSON):
          let payload = parsedJSON["payload"] as! [String:Any]
          let code = payload["code"] as! Int
          let alertController = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
          switch(code){
          case 1:
            let errorMessage = "Email Or Password Not Specified"
            alertController.message = errorMessage
            self.present(alertController, animated: true, completion: nil)
          case 2:
            let errorMessage = "Could Not Connect To Database"
            alertController.message = errorMessage
            self.present(alertController, animated: true, completion: nil)
          case 3:
            let errorMessage = "Login Successful. Please Change Your Password"
            alertController.message = errorMessage
            alertController.addAction(UIAlertAction(title: "Change Password", style: .default, handler: { (_) in
              let myURL = URL(string: "https://mitportals.in/loginform.php")
              let safariViewController = SFSafariViewController(url: myURL!)
              self.present(safariViewController, animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
          case 4:
            let errorMessage = "Login Successful"
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "LoggedIn")
            defaults.set(self.cookieValue, forKey: "Cookie")
            alertController.message = errorMessage
            self.dismiss(animated: true, completion: nil)
          case 5:
            let errorMessage = "Incorrect Email Or Password! Please Try Again"
            alertController.message = errorMessage
            self.present(alertController, animated: true, completion: nil)
          default:
            let errorMessage = "Unknown Error"
            alertController.message = errorMessage
            self.present(alertController, animated: true, completion: nil)
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
      // No Username,Password Entered
    else{
      let alertController = UIAlertController(title: "Error", message: "Please enter a username and password", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  // MARK: Perform Login
  func performLogin(completion:@escaping (Status<[String:Any]>) -> ()){
    startAnimating()
    var request = URLRequest(url: url!)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    let paramString = "email=" + userNameTextField.text! + "&password=" + passwordTextField.text!
    request.httpBody = paramString.data(using: .utf8)
    
    // POST Data For Login
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    
      guard let data = data else{
        return completion(.Error("Please Check Your Internet Connection"))
      }
      let dataString:String! = String(data:data,encoding: .utf8)
      let jsonData = dataString.data(using: .utf8)!
      guard let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else{ return completion(.Error("Check Your Internet Connection"))
      }
      // Cookie Value
      let cookieStorage = HTTPCookieStorage.shared
      let cookies = cookieStorage.cookies
      for cookie in cookies!{
        if(cookie.name == "PHPSESSID"){
        self.cookieValue = cookie.value
      }
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
  @IBAction func didSelectSignUpButton(_ sender: Any) {
    let myURL = URL(string: "https://mitportals.in/loginform.php")
    let safariViewController = SFSafariViewController(url: myURL!)
    self.present(safariViewController, animated: true, completion: nil)
  }
  func dismissKeyboard() {
    view.endEditing(true)
  }
  

  
}
