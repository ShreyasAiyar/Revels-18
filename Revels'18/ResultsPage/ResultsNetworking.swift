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
    
    let resultsURL = "https://api.mitportals.in/results/"
    let httpRequestObject = HTTPRequest()
    
    //MARK: Get JSON Data
    func resultsMain(completion: @escaping () -> ()){
        var results:[Results] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: resultsURL){ status in
            switch status{
            case .Success(let parsedJSON):
                for result in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let resultObject = Results(dictionary: result)
                    results.append(resultObject)
                }
                self.saveResultsToCoreData(resultData: results)
                completion()
                
            case .Error(let errorMessage):
                DispatchQueue.main.async {
                    print(errorMessage)
                    completion()
                }
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
            result.setValue(resultObject.name, forKey: "name")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
    }
    
    func fetchResultsFromCoreData() -> [Results]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let resultFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Result")
        
        var resultsCoreData:[NSManagedObject] = []
        var resultsArray:[Results] = []
        resultsCoreData = try! managedContext.fetch(resultFetchRequest)
        
        for result in resultsCoreData{
            var resultDictionary:Dictionary<String,String> = [:]
            resultDictionary["cat"] = result.value(forKey: "cat") as? String
            resultDictionary["eve"] = result.value(forKey: "eve") as? String
            resultDictionary["evename"] = result.value(forKey: "evename") as? String
            resultDictionary["pos"] = result.value(forKey: "pos") as? String
            resultDictionary["round"] = result.value(forKey: "round") as? String
            resultDictionary["tid"] = result.value(forKey: "tid") as? String
            resultDictionary["name"] = result.value(forKey: "name") as? String
            let resultObject = Results(dictionary: resultDictionary)
            resultsArray.append(resultObject)
        }
        return resultsArray
    }
}

