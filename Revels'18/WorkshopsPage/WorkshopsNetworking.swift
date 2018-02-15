//
//  WorkshopsNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 07/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WorkshopsNetworking{
  func saveWorkshopsToCoreData(workshopsData:[Workshops]){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
      return
    }
    let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    // MARK: Deleting Records From CoreData
    let workshopDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Workshop")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: workshopDeleteRequest)
    
    do{
      try managedContext.execute(batchDeleteRequest)
    }
    catch{
      print("Deleting Error Failed")
    }
    
    // MARK: Updating Records In CoreData After Deletion
    let scheduleEntity = NSEntityDescription.entity(forEntityName: "Workshop", in: managedContext)
    for workshopObject in workshopsData{
      let workshop:NSManagedObject! = NSManagedObject(entity: scheduleEntity!, insertInto: managedContext)
      workshop.setValue(workshopObject.cname, forKey: "cname")
      //workshop.setValue(workshopObject.numb, forKey: "numb")
      workshop.setValue(workshopObject.wcost, forKey: "wcost")
      workshop.setValue(workshopObject.wdesc, forKey: "wdesc")
      workshop.setValue(workshopObject.wid, forKey: "wid")
      workshop.setValue(workshopObject.wkhatam, forKey: "wkhatam")
      workshop.setValue(workshopObject.wname, forKey: "wname")
      workshop.setValue(workshopObject.wshuru, forKey: "wshuru")
      workshop.setValue(workshopObject.wvenue, forKey: "wvenue")
      do{
        try managedContext.save()
      }
      catch{
        print("Saving To CoreData Failed")
      }
    }
  }
  
  func fetchWorkshopsFromCoreData() -> [Workshops]{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let workshopsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workshop")
    var workshopsCoreData:[NSManagedObject] = []
    var workshops:[Workshops] = []
    
    workshopsCoreData = try! managedContext.fetch(workshopsFetchRequest)
    for workshopData in workshopsCoreData{
      var workshopsDictionary:Dictionary<String,String> = [:]
      workshopsDictionary["wid"] = workshopData.value(forKey: "wid") as? String
      workshopsDictionary["wname"] = workshopData.value(forKey: "wname") as? String
      workshopsDictionary["wcost"] = workshopData.value(forKey: "wcost") as? String
      workshopsDictionary["wshuru"] = workshopData.value(forKey: "wshuru") as? String
      workshopsDictionary["wkhatam"] = workshopData.value(forKey: "wkhatam") as? String
      workshopsDictionary["wdesc"] = workshopData.value(forKey: "wdesc") as? String
      workshopsDictionary["wvenue"] = workshopData.value(forKey: "wvenue") as? String
      workshopsDictionary["cname"] = workshopData.value(forKey: "cname") as? String
      //workshopsDictionary["numb"] = workshopData.value(forKey: "numb") as? String
      let workshopsObject = Workshops(dictionary: workshopsDictionary)
      workshops.append(workshopsObject)
    }
    return workshops
  }
}
