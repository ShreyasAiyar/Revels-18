//
//  ResultsNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 12/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ResultNetworking{
    
    let httpRequestObject = HTTPRequest()
    
    
    func resultsMain(){
        
        let resultsURL = "https://api.mitportals.in/results/"
        var results:[Results] = []
        
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: resultsURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for retrievedResults in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let resultObject = Results(dictionary: retrievedResults)
                    results.append(resultObject)
                }
                self.saveResultsToCoreData(resultData: results)
                
            case .Error(let errorMessage):
                print(errorMessage)
            }
        }
        
    }
    
    func saveResultsToCoreData(resultData:[Results]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // MARK: Deleting Records From CoreData
        let resultDeleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Result")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: resultDeleteRequest)
        
        do{
            try managedContext.execute(batchDeleteRequest)
        }
        catch{
            print("Deleting Error Failed")
        }
        
        // MARK: Updating Records In CoreData After Deletion
        let scheduleEntity = NSEntityDescription.entity(forEntityName: "Result", in: managedContext)
        for resultObject in resultData{
            let result:NSManagedObject! = NSManagedObject(entity: scheduleEntity!, insertInto: managedContext)
            result.setValue(resultObject.cat, forKey: "cat")
            result.setValue(resultObject.eve, forKey: "eve")
            result.setValue(resultObject.evename, forKey: "evename")
            result.setValue(resultObject.pos, forKey: "pos")
            result.setValue(resultObject.round, forKey: "round")
            result.setValue(resultObject.tid, forKey: "tid")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
        
    }
    
    func fetchResultsFromCoreData() -> [NSManagedObject]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let resultFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Result")
        
        var results:[NSManagedObject] = []
        results = try! managedContext.fetch(resultFetchRequest)
        return results
    }

}

