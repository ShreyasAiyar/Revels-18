//
//  NetworkController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation

class NetworkController{
  
  let httpRequestObject = HTTPRequest()
  let eventsURL = "https://api.mitportals.in/events/"
  let instagramURL = "https://api.instagram.com/v1/tags/techtatva17/media/recent?access_token=630237785.f53975e.8dcfa635acf14fcbb99681c60519d04c"
  let resultsURL = "https://api.mitportals.in/results/"
  let categoriesURL = "https://api.mitportals.in/categories/"
  let scheduleURL = "https://api.mitportals.in/schedule/"
  
  let eventsObject = EventsNetworking()
  let resultsObject = ResultNetworking()
  let categoriesObject = CategoriesNetworking()
  let scheduleObject = ScheduleNetworking()
  
  var instagramObjects:[Instagram] = []
  
  func fetchEvents(completion:@escaping () -> ()){
    var events:[Events] = []
    httpRequestObject.makeHTTPRequestForEvents(eventsURL: eventsURL){
      result in
      switch result{
      case .Success(let parsedJSON):
        for event in parsedJSON["data"] as! [Dictionary<String,String>]{
          let eventObject = Events(dictionary: event)
          events.append(eventObject)
        }
        self.eventsObject.saveEventsToCoreData(eventsData: events)
        completion()
        
      case .Error(let errorMessage):
        print(errorMessage)
        DispatchQueue.main.async {
          completion()
        }
      }
    }
  }
  
  func fetchInstagram(completion: @escaping (_ instaObjects:[Instagram]) -> ()){
    var instaObjects:[Instagram] = []
    httpRequestObject.makeHTTPRequestForEvents(eventsURL: instagramURL){
      result in
      switch result{
      case .Success(let parsedJSON):
        let instaData = parsedJSON as Dictionary<String,Any>
        for instaDataItem in instaData["data"] as! [Dictionary<String,Any>]{
          let instaObject = Instagram(dictionary: instaDataItem)
          instaObjects.append(instaObject)
        }
        completion(instaObjects)
      case .Error(let errorString):
        DispatchQueue.main.async {
          print(errorString)
          completion(instaObjects)
        }
      }
    }
  }
  
  func fetchResults(completion: @escaping () -> ()){
    var results:[Results] = []
    httpRequestObject.makeHTTPRequestForEvents(eventsURL: resultsURL){ status in
      switch status{
      case .Success(let parsedJSON):
        for result in parsedJSON["data"] as! [Dictionary<String,String>]{
          let resultObject = Results(dictionary: result)
          results.append(resultObject)
        }
        self.resultsObject.saveResultsToCoreData(resultData: results)
        completion()
        
      case .Error(let errorMessage):
        DispatchQueue.main.async {
          print(errorMessage)
          completion()
        }
      }
    }
  }
  
  func fetchCategories(completion:@escaping () -> ()){
    var categories:[Categories] = []
    httpRequestObject.makeHTTPRequestForEvents(eventsURL: categoriesURL){
      result in
      switch result{
      case .Success(let parsedJSON):
        for category in parsedJSON["data"] as! [Dictionary<String,String>]{
          let categoryObject = Categories(dictionary: category)
          categories.append(categoryObject)
        }
        self.categoriesObject.saveCategoriesToCoreData(categoryData: categories)
        completion()
      case .Error(let errorMessage):
        DispatchQueue.main.async {
          print(errorMessage)
          completion()
        }
      }
    }
  }
  
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
        self.scheduleObject.saveSchedulesToCoreData(scheduleData: schedules)
        completion()
        
      case .Error(let errorMessage):
        print(errorMessage)
        DispatchQueue.main.async {
          completion()
        }
      }
    }
  }
  
  
  func fetchAllData(completion:@escaping (_ instaObjects:[Instagram]) -> ()){
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    fetchEvents{
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    fetchSchedules {
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    fetchResults {
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    fetchCategories {
      dispatchGroup.leave()
    }
    
    dispatchGroup.enter()
    fetchInstagram { (instragramObject) in
      self.instagramObjects = instragramObject
      dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) {
      NSLog("Finished Downloading All Data")
      completion(self.instagramObjects)
    }
  
  }
  
}
