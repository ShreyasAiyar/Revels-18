//
//  CacheCheck.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 02/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CacheCheck{
    
    func checkIfCacheExists() -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return false
        }
        
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let eventsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        var events:[NSManagedObject] = []
        events = try! managedContext.fetch(eventsFetchRequest)
        print(events.count)
        if (events.count == 0){
            return false
        }
        else{
            return true
        }
    }
    
}
