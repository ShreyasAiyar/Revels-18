//
//  HTTPRequest.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HTTPRequest{
    enum Result<T>:Error{
        case Success(T)
        case Error(String)
    }
    
     func makeHTTPRequestForEvents (eventsURL:String, completion: @escaping (Result<[String:Any]>) -> ()){
        guard let url = URL(string:eventsURL) else{
            print("No URL Provided")
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            (data,reponse,error) in
            
            guard error == nil else{
                return completion(.Error("No Connection"))
            }
            guard let data = data else{
                print("No Data Found")
                return completion(.Error("No Data Found"))
            }
            let dataString:String! = String(data:data,encoding: .utf8)
            let jsonData = dataString.data(using: .utf8)!
            guard let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else{
                print("Parsing Failed")
                return completion(.Error("Parsing Failed"))
            }
            DispatchQueue.main.async {
                completion(.Success(parsedJSON!))
            }
        }
        task.resume()
    }
}
