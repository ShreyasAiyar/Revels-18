//
//  CoreDataStack.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 30/11/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack{
    
    func saveEventsData(eventsData:Dictionary<String,String>){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let eventsEntity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)
        let event:NSManagedObject! = NSManagedObject(entity: eventsEntity!, insertInto: managedContext)
        event.setValue(eventsData["eid"], forKey: "eventID")
    }
}
