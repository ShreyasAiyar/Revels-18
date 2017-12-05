//
//  ScheduleNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 04/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScheduleNetworking{
    
    let httpRequestObject = HTTPRequest()
    
    
    func scheduleMain(){
        
        let scheduleURL = "https://api.mitportals.in/categories/"
        var schedules:[Schedules] = []
        
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: scheduleURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for category in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let scheduleObject = Schedules(dictionary: category)
                    schedules.append(scheduleObject)
                }
                self.saveSchedulesToCoreData(scheduleData: schedules)
                
            case .Error(let errorMessage):
                print(errorMessage)
            }
        }
        
    }
    
    func saveSchedulesToCoreData(scheduleData:[Schedules]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // MARK: Deleting Records From CoreData
        let categoryDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryDeleteRequest)
        
        do{
            try managedContext.execute(batchDeleteRequest)
        }
        catch{
            print("Deleting Error Failed")
        }
        
        // MARK: Updating Records In CoreData After Deletion
        let scheduleEntity = NSEntityDescription.entity(forEntityName: "Schedule", in: managedContext)
        for scheduleObject in scheduleData{
            let schedule:NSManagedObject! = NSManagedObject(entity: scheduleEntity!, insertInto: managedContext)
            schedule.setValue(scheduleObject.catid, forKey: "catid")
            schedule.setValue(scheduleObject.catname, forKey: "catname")
            schedule.setValue(scheduleObject.date, forKey: "date")
            schedule.setValue(scheduleObject.day, forKey: "day")
            schedule.setValue(scheduleObject.eid, forKey: "eid")
            schedule.setValue(scheduleObject.ename, forKey: "ename")
            schedule.setValue(scheduleObject.etime, forKey: "etime")
            schedule.setValue(scheduleObject.round, forKey: "round")
            schedule.setValue(scheduleObject.stime, forKey: "stime")
            schedule.setValue(scheduleObject.venue, forKey: "venue")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
        
    }
    
    func fetchScheduleFromCoreData() -> [[NSManagedObject]]{
        var day1Schedules:[NSManagedObject] = []
        var day2Schedules:[NSManagedObject] = []
        var day3Schedules:[NSManagedObject] = []
        var day4Schedules:[NSManagedObject] = []
        var allDays:[[NSManagedObject]] = [[]]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let scheduleFetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Schedule")
        
        let day1Predicate = NSPredicate(format: "day == 1")
        let day2Predicate = NSPredicate(format: "day == 2")
        let day3Predicate = NSPredicate(format: "day == 3")
        let day4Predicate = NSPredicate(format: "day == 4")
        
        scheduleFetchRequest.predicate = day1Predicate
        day1Schedules = try! managedContext.fetch(scheduleFetchRequest)
        allDays.append(day1Schedules)
        
        scheduleFetchRequest.predicate = day2Predicate
        day2Schedules = try! managedContext.fetch(scheduleFetchRequest)
        allDays.append(day2Schedules)
        
        scheduleFetchRequest.predicate = day3Predicate
        day3Schedules = try! managedContext.fetch(scheduleFetchRequest)
        allDays.append(day3Schedules)
        
        scheduleFetchRequest.predicate = day4Predicate
        day4Schedules = try! managedContext.fetch(scheduleFetchRequest)
        allDays.append(day4Schedules)
        
        return allDays
        
 
    }
    
    
    
    
}
