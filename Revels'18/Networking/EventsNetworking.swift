//
//  EventsNetworking.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 01/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct EventsNetworking{
    
    
    static func makeHTTPRequestForEvents(eventsURL:String, completion: @escaping ([String:Any]) -> ()){
        guard let url = URL(string:eventsURL) else{
            print("No URL Provided")
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            (data,reponse,error) in
            
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
            DispatchQueue.main.async {
                completion(parsedJSON!)
            }
        }
        task.resume()
    }
    
    
    static func eventsMain(){
        let eventsURL = "https://api.mitportals.in/events/"
        var events:[Events] = []
        
        makeHTTPRequestForEvents(eventsURL: eventsURL){
            parsedJSON in
            for event in parsedJSON["data"] as! [Dictionary<String,String>]{
                let eventObject = Events(dictionary: event)
                events.append(eventObject)
            }
        }

    }
    
    static func saveEventsToCoreData(eventsData:[Events]){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let eventsEntity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)
        let event:NSManagedObject! = NSManagedObject(entity: eventsEntity!, insertInto: managedContext)
        for eventObject in eventsData{
            event.setValue(eventObject.eid, forKey: "eventID")
        }
        
        do{
            try managedContext.save()
        }
        catch{
            print("Saving To CoreData Failed")
        }
        
        fetchEventsFromCoreData()
    }
    
    static func fetchEventsFromCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let eventsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        var events:[NSManagedObject] = []
        
        events = try! managedContext.fetch(eventsFetchRequest)
        for eventObject in events{
            print (eventObject.value(forKey: "eventID") as! String)
            
        }
        
    }
    
    
    
    
    
    
}