//
//  CoreDataStack.swift
//  Revels'18
//
//  Created by Shreyas on 30/11/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

import CoreData
import UIKit

class CoreDataStack{
    
    let container:NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context:NSManagedObjectContext = container.viewContext
}
