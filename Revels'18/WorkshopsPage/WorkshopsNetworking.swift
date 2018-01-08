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
        workshop.setValue(workshopObject.numb, forKey: "numb")
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
