//
//  RevelsCupNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 15/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class RevelsCupNetworking{
  
  func saveRevelsCupToCoreData(revelsCupData:[RevelsCups]){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
      return
    }
    let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    // MARK: Deleting Records From CoreData
    let revelsCupDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"RevelsCup")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: revelsCupDeleteRequest)
    
    do{
      try managedContext.execute(batchDeleteRequest)
    }
    catch{
      print("Deleting Error Failed")
    }
    
    // MARK: Updating Records In CoreData After Deletion
    let revelsCupEntity = NSEntityDescription.entity(forEntityName: "RevelsCup", in: managedContext)
    for revelsCupObject in revelsCupData{
      let revelsCup:NSManagedObject! = NSManagedObject(entity: revelsCupEntity!, insertInto: managedContext)
      revelsCup.setValue(revelsCupObject.date, forKey: "date")
      revelsCup.setValue(revelsCupObject.sname, forKey: "sname")
      revelsCup.setValue(revelsCupObject.team1, forKey: "team1")
      revelsCup.setValue(revelsCupObject.team2, forKey: "team2")
      revelsCup.setValue(revelsCupObject.time, forKey: "time")
      revelsCup.setValue(revelsCupObject.venue, forKey: "venue")
      do{
        try managedContext.save()
      }
      catch{
        print("Saving To CoreData Failed")
      }
    }
  }
  
  func fetchRevelsCupFromCoreData() -> [RevelsCups]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let revelsCupFetchRequest = NSFetchRequest<NSManagedObject>(entityName:"RevelsCup")
    
    var revelsCup:[RevelsCups] = []
    var coreDataRevelsCup:[NSManagedObject] = []
    
    coreDataRevelsCup = try! managedContext.fetch(revelsCupFetchRequest)
    
    for revelsCupObject in coreDataRevelsCup{
      var revelsCupDictionary:Dictionary<String,String> = [:]
      revelsCupDictionary["date"] = revelsCupObject.value(forKey: "date") as? String
      revelsCupDictionary["sname"] = revelsCupObject.value(forKey: "sname") as? String
      revelsCupDictionary["team1"] = revelsCupObject.value(forKey: "team1") as? String
      revelsCupDictionary["team2"] = revelsCupObject.value(forKey: "team2") as? String
      revelsCupDictionary["time"] = revelsCupObject.value(forKey: "time") as? String
      revelsCupDictionary["venue"] = revelsCupObject.value(forKey: "venue") as? String
      let revelsCupDataObject = RevelsCups(dictionary: revelsCupDictionary)
      revelsCup.append(revelsCupDataObject)
    }
    return revelsCup
    
  }
  
}
