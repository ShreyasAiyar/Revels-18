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
    let scheduleURL = "https://api.mitportals.in/schedule/"
    
    //MARK: Networking Call - Fetch Schedules
    func fetchSchedules(completion:@escaping () -> ()){
        var schedules:[Schedules] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: scheduleURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for schedule in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let scheduleObject = Schedules(dictionary: schedule)
                    schedules.append(scheduleObject)
                }
                self.saveSchedulesToCoreData(scheduleData: schedules)
                completion()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func saveSchedulesToCoreData(scheduleData:[Schedules]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // MARK: Deleting Records From CoreData
        let scheduleDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Schedule")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: scheduleDeleteRequest)
        
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
    
    func fetchScheduleFromCoreData() -> [Schedules]{

        var coreDataSchedules:[NSManagedObject] = []
        var schedules:[Schedules] = []
        var dayWiseSchedules:[[Schedules]] = [[]]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let scheduleFetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Schedule")
        
        coreDataSchedules = try! managedContext.fetch(scheduleFetchRequest)
        for coreDataSchedule in coreDataSchedules{
            var dictionary:Dictionary<String,String> = [:]
            dictionary["eid"] = coreDataSchedule.value(forKey: "eid") as? String
            dictionary["ename"] = coreDataSchedule.value(forKey: "ename") as? String
            dictionary["catid"] = coreDataSchedule.value(forKey: "catid") as? String
            dictionary["catname"] = coreDataSchedule.value(forKey: "catname") as? String
            dictionary["round"] = coreDataSchedule.value(forKey: "round") as? String
            dictionary["venue"] = coreDataSchedule.value(forKey: "venue") as? String
            dictionary["stime"] = coreDataSchedule.value(forKey: "stime") as? String
            dictionary["etime"] = coreDataSchedule.value(forKey: "etime") as? String
            dictionary["day"] = coreDataSchedule.value(forKey: "day") as? String
            dictionary["date"] = coreDataSchedule.value(forKey: "date") as? String
            let scheduleObject:Schedules = Schedules(dictionary: dictionary)
            schedules.append(scheduleObject)
        }
        dayWiseSchedules.append(schedules.filter{return $0.day == "1"})
        dayWiseSchedules.append(schedules.filter{return $0.day == "2"})
        dayWiseSchedules.append(schedules.filter{return $0.day == "3"})
        dayWiseSchedules.append(schedules.filter{return $0.day == "4"})
        
        return schedules
 
    }
    
    func addFavoritesToCoreData(eid:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let favoriteEntityDescription = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        let scheduleFetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Schedule")
        let eventIdPredicate = NSPredicate(format: "eid == %@",eid)
        scheduleFetchRequest.predicate = eventIdPredicate
        
        var schedules:[NSManagedObject] = []
        schedules = try! managedContext.fetch(scheduleFetchRequest)
        for favoriteObject in schedules{
            let favoriteEntity =  NSManagedObject(entity: favoriteEntityDescription!, insertInto: managedContext)
            favoriteEntity.setValue(favoriteObject.value(forKey: "eid"), forKey: "eid")
            favoriteEntity.setValue(favoriteObject.value(forKey: "ename"), forKey: "ename")
            favoriteEntity.setValue(favoriteObject.value(forKey: "catid"), forKey: "catid")
            favoriteEntity.setValue(favoriteObject.value(forKey: "catname"), forKey: "catname")
            favoriteEntity.setValue(favoriteObject.value(forKey: "round"), forKey: "round")
            favoriteEntity.setValue(favoriteObject.value(forKey: "venue"), forKey: "venue")
            favoriteEntity.setValue(favoriteObject.value(forKey: "stime"), forKey: "stime")
            favoriteEntity.setValue(favoriteObject.value(forKey: "etime"), forKey: "etime")
            favoriteEntity.setValue(favoriteObject.value(forKey: "day"), forKey: "day")
            favoriteEntity.setValue(favoriteObject.value(forKey: "date"), forKey: "date")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
    }
    
    func fetchFavoritesFromCoreData() -> [Schedules]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let favoritesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")

        var coreDatafavorites:[NSManagedObject] = []
        var favorites:[Schedules] = []
        
       coreDatafavorites = try! managedContext.fetch(favoritesFetchRequest)
        
        for favorite in coreDatafavorites{
            var favoriteDictionary:Dictionary<String,String> = [:]
            favoriteDictionary["catid"] = favorite.value(forKey: "catid") as? String
            favoriteDictionary["catname"] = favorite.value(forKey: "catname") as? String
            favoriteDictionary["date"] = favorite.value(forKey: "date") as? String
            favoriteDictionary["day"] = favorite.value(forKey: "day") as? String
            favoriteDictionary["eid"] = favorite.value(forKey: "eid") as? String
            favoriteDictionary["ename"] = favorite.value(forKey: "ename") as? String
            favoriteDictionary["etime"] = favorite.value(forKey: "etime") as? String
            favoriteDictionary["round"] = favorite.value(forKey: "round") as? String
            favoriteDictionary["stime"] = favorite.value(forKey: "stime") as? String
            favoriteDictionary["venue"] = favorite.value(forKey: "venue") as? String
            let categoryObject = Schedules(dictionary: favoriteDictionary)
            favorites.append(categoryObject)
        }
        return favorites
    }
    
    func removeFavorites(eid:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let scheduleDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorite")
        print("Function Got Called")
        let favoriteDeletePredicate = NSPredicate(format: "eid == %@",eid)
        scheduleDeleteRequest.predicate = favoriteDeletePredicate
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: scheduleDeleteRequest)
        
        do{
            try managedContext.execute(batchDeleteRequest)
            print("Deleted ",eid)
        }
        catch{
            print("Error Deleting Favorites")
        }
    }
}
