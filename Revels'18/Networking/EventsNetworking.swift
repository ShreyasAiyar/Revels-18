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

class EventsNetworking{
    
    let httpRequestObject = HTTPRequest()
    

    func eventsMain(){
        let eventsURL = "https://api.mitportals.in/events/"
        var events:[Events] = []
        
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: eventsURL){
            result in
            switch result{   
            case .Success(let parsedJSON):
                for event in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let eventObject = Events(dictionary: event)
                    events.append(eventObject)
                    
                }
                self.saveEventsToCoreData(eventsData: events)
        
            case .Error(let errorMessage):
                print(errorMessage)
                
        }
    }
            
}
        
        func saveEventsToCoreData(eventsData:[Events]){
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
        }
        
         func fetchEventsFromCoreData(){
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
