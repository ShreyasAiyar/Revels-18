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
    let eventsURL = "https://api.mitportals.in/events/"
    
    func eventsMain(completion:@escaping () -> ()){
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
                completion()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    completion()
                }
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
            event.setValue(eventObject.eid, forKey: "eid")
            event.setValue(eventObject.cid, forKey: "cid")
            event.setValue(eventObject.cname, forKey: "cname")
            event.setValue(eventObject.day, forKey: "day")
            event.setValue(eventObject.cntctname, forKey: "cntctname")
            event.setValue(eventObject.cntctno, forKey: "cntctno")
            event.setValue(eventObject.edesc, forKey: "edesc")
            event.setValue(eventObject.eid, forKey: "eid")
            event.setValue(eventObject.emaxteamsize, forKey: "emaxteamsize")
            event.setValue(eventObject.ename, forKey: "ename")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
    }
    
    func fetchEventsFromCoreData() -> [Events]{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext:NSManagedObjectContext = appDelegate!.persistentContainer.viewContext
        let eventsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        var coreDataEvents:[NSManagedObject] = []
        var events:[Events] = []
        coreDataEvents = try! managedContext.fetch(eventsFetchRequest)
        for event in coreDataEvents{
            var dictionary:Dictionary<String,String> = [:]
            dictionary["eid"] = event.value(forKey: "eid") as? String
            dictionary["cid"] = event.value(forKey: "cid") as? String
            dictionary["cname"] = event.value(forKey: "cname") as? String
            dictionary["day"] = event.value(forKey: "day") as? String
            dictionary["cntctname"] = event.value(forKey: "cntctname") as? String
            dictionary["cntctno"] = event.value(forKey: "cntctno") as? String
            dictionary["edesc"] = event.value(forKey: "edesc") as? String
            dictionary["eid"] = event.value(forKey: "eid") as? String
            dictionary["emaxteamsize"] = event.value(forKey: "emaxteamsize") as? String
            dictionary["ename"] = event.value(forKey: "ename") as? String
            let eventObject = Events(dictionary: dictionary)
            events.append(eventObject)
        }
        return events
    }
    
    
    
    
    
    
}
