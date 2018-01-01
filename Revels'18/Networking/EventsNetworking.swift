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
        print(events)
        
    }
    
    
    
    
    
    
}
