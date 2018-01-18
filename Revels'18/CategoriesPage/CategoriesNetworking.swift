//
//  CategoriesNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: Write Main Function For Categories

class CategoriesNetworking{
    
    let httpRequestObject = HTTPRequest()
    
    func categoriesMain(completion:@escaping () -> ()){
        let categoriesURL = "https://api.mitportals.in/categories/"
        var categories:[Categories] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: categoriesURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for category in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let categoryObject = Categories(dictionary: category)
                    categories.append(categoryObject)
                }
                self.saveCategoriesToCoreData(categoryData: categories)
                completion()
            case .Error(let errorMessage):
                DispatchQueue.main.async {
                    print(errorMessage)
                    completion()
                }
            }
        }
        
    }
    
    
    func saveCategoriesToCoreData(categoryData:[Categories]){
        
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
        let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)
        for categoryObject in categoryData{
            let category:NSManagedObject! = NSManagedObject(entity: categoryEntity!, insertInto: managedContext)
            category.setValue(categoryObject.cdesc, forKey: "cdesc")
            category.setValue(categoryObject.cid, forKey: "cid")
            category.setValue(categoryObject.cname, forKey: "cname")
            do{
                try managedContext.save()
            }
            catch{
                print("Saving To CoreData Failed")
            }
        }
        
    }
    
    func fetchCategoriesFromCoreData() -> [Categories]{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let categoriesFetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Category")
        
        var categories:[Categories] = []
        var coreDataCategories:[NSManagedObject] = []
        
        coreDataCategories = try! managedContext.fetch(categoriesFetchRequest)
        
        for category in coreDataCategories{
            var categoryDictionary:Dictionary<String,String> = [:]
            categoryDictionary["cid"] = category.value(forKey: "cid") as? String
            categoryDictionary["cname"] = category.value(forKey: "cname") as? String
            categoryDictionary["cdesc"] = (category.value(forKey: "cdesc") as! String)
            let categoryObject = Categories(dictionary: categoryDictionary)
            categories.append(categoryObject)
        }
        return categories
        
    }
    
}
