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
    
    enum Result<T>:Error{
        case Success(T)
        case Error(String)
    }
    
    static func makeHTTPRequestForEvents (eventsURL:String, completion: @escaping (Result<[String:Any]>) -> ()){
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
    
    
    static func eventsMain() -> Bool{
        let eventsURL = "https://api.mitportals.in/events/"
        var events:[Events] = []
        
        makeHTTPRequestForEvents(eventsURL: eventsURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for event in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let eventObject = Events(dictionary: event)
                    events.append(eventObject)
                }
                saveEventsToCoreData(eventsData: events)
        
            case .Error(let errorMessage):
                print(errorMessage)
                return
        }
    }
        return false
            
}
        
        static func saveEventsToCoreData(eventsData:[Events]){
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return
            }
            let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            // MARK: Deleting Records From CoreData
            let eventsDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Event")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: eventsDeleteRequest)
            
            do{
                try managedContext.execute(batchDeleteRequest)
            }
            catch{
                print("Deleting Error Failed")
            }
            
            // MARK: Updating Records In CoreData After Deletion
            let eventsEntity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)
            for eventObject in eventsData{
                let event:NSManagedObject! = NSManagedObject(entity: eventsEntity!, insertInto: managedContext)
                event.setValue(eventObject.eid, forKey: "eventID")
                event.setValue(eventObject.cid, forKey: "eventCategoryID")
                event.setValue(eventObject.cname, forKey: "eventCategoryName")
                event.setValue(eventObject.day, forKey: "day")
                do{
                    try managedContext.save()
                }
                catch{
                    print("Saving To CoreData Failed")
                }
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
                print (eventObject.value(forKey: "eventID") as? String)
                
            }
            
        }
        
        
        
        
        
        
}
