//
//  HTTPRequests.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 29/11/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData

class HTTPRequests{
    
    let coreDataStack = CoreDataStack()
    
    enum HTTPRequestsError:Error{
        case noURLFound
        case noDataFound
    }
    
    
    func makeHTTPRequest(url:String,completion: @escaping ([String:Any]) -> ()){
        
        guard let url = URL(string:url) else{
            print("No URL Provided")
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            (data,reponse,error) in
            print("Inside The Completion Handler")
            guard error == nil else{
                return
            }
            guard let data = data else{
                print("No Data Found")
                return
            }
            let dataString:String! = String(data:data,encoding: .utf8)
            let jsonData = dataString.data(using: .utf8)!
            guard let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else{
                print("Parsing Failed")
                return
            }
                completion(parsedJSON!)
        }
        task.resume()
    }
    
    
    
    func updateData(){
        let eventsURL = "https://api.mitportals.in/events/"
//        let categoriesURL = "https://api.mitportals.in/categories/"
//        let resultsURL = "https://api.mitportals.in/results/"
//        let scheduleURL = "https://api.mitportals.in/schedule/"
//        let workshopsURL = "https://api.mitportals.in/workshops/"
//        let sportsURL = "https://api.mitportals.in/sports/"
        
        makeHTTPRequest(url: eventsURL){
            parsedJSON in
            self.saveEventsJSON(parsedJSON: parsedJSON)
        }
//        makeHTTPRequest(url: categoriesURL){
//            parsedJSON in
//            print(parsedJSON)
//        }
//        makeHTTPRequest(url: resultsURL){
//            parsedJSON in
//        }
//        makeHTTPRequest(url: scheduleURL){
//            parsedJSON in
//        }
//        makeHTTPRequest(url: workshopsURL){
//            parsedJSON in
//        }
//        makeHTTPRequest(url: sportsURL){
//            parsedJSON in
//            guard let parsedJSON = parsedJSON else{
//                print("Error in Parsing")
//                return
//            }
//
//        }
    }
    
    func saveEventsJSON(parsedJSON:[String:Any]){
        guard let data = parsedJSON["data"] else{
            return
        }
        for keyValues in data as! [Dictionary<String,String>]{
            coreDataStack.saveEventsData(eventsData: keyValues) 
        }
        
    }
        
}

