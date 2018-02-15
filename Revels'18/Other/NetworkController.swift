//
//  NetworkController.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation

class NetworkController{
  
  let eventsURL = "https://api.mitportals.in/events/"
  let instagramURL = "https://api.instagram.com/v1/tags/Revels18/media/recent?access_token=630237785.f53975e.8dcfa635acf14fcbb99681c60519d04c"
  let resultsURL = "https://api.mitportals.in/results/"
  let sportsURL = "https://api.mitportals.in/sports/"
  let categoriesURL = "https://api.mitportals.in/categories/"
  let scheduleURL = "https://api.mitportals.in/schedule/"
  let workshopURL = "https://api.mitportals.in/workshops/"
  let revelsCupURL = "https://api.mitportals.in/revelscup/"

  
  let eventsObject = EventsNetworking()
  let resultsObject = ResultNetworking()
  let categoriesObject = CategoriesNetworking()
  let scheduleObject = ScheduleNetworking()
  let revelsCupObject = RevelsCupNetworking()
  var instagramObjects:[Instagram] = []
  
  enum Status<T>:Error{
    case Success(T)
    case Error(String)
  }
  
  func makeHTTPRequestForEvents (eventsURL:String, completion: @escaping (Status<[String:Any]>) -> ()){
    guard let url = URL(string:eventsURL) else{
      print("No URL Provided")
      return
    }
    
    let task = URLSession.shared.dataTask(with: url){
      (data,reponse,error) in
      
      guard error == nil else{
        return completion(.Error("No Connection"))
      }
      guard let data = data else{
        print("No Data Found")
        return completion(.Error("No Data Found"))
      }
      

      let dataString:String! = String(data:data,encoding: .utf8)
      let jsonData = dataString.data(using: .utf8)!
      guard let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData) as? [String:Any] else{
        print("Parsing Failed")
        return completion(.Error("Parsing Failed"))
      }

      DispatchQueue.main.async {
        if let parsedJSON = parsedJSON{
          completion(.Success(parsedJSON))
        }else{
          completion(.Error("No Data"))
        }
        
      }
    }
    task.resume()
  }
  
  func fetchEvents(completion:@escaping () -> ()){
    var events:[Events] = []
    makeHTTPRequestForEvents(eventsURL: eventsURL){
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
    makeHTTPRequestForEvents(eventsURL: instagramURL){
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
    makeHTTPRequestForEvents(eventsURL: resultsURL){ status in
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
    makeHTTPRequestForEvents(eventsURL: categoriesURL){
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
    makeHTTPRequestForEvents(eventsURL: scheduleURL){
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
  
  func fetchRevelsCupData(completion:@escaping () -> ()){
    var revelsCups:[RevelsCups] = []
    makeHTTPRequestForEvents(eventsURL: revelsCupURL){
      result in
      switch result{
      case .Success(let parsedJSON):
        for revelsCup in parsedJSON["data"] as! [Dictionary<String,String>]{
          let revelsCupObject = RevelsCups(dictionary: revelsCup)
          revelsCups.append(revelsCupObject)
        }
        self.revelsCupObject.saveRevelsCupToCoreData(revelsCupData: revelsCups)
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
      print("Events Done")
    }
    dispatchGroup.enter()
    fetchSchedules {
      dispatchGroup.leave()
      print("Schedules Done")
    }
    dispatchGroup.enter()
    fetchResults {
      dispatchGroup.leave()
      print("Results Done")
    }
    dispatchGroup.enter()
    fetchCategories {
      dispatchGroup.leave()
      print("Categories Done")
    }
    
    dispatchGroup.enter()
    fetchInstagram { (instragramObject) in
      self.instagramObjects = instragramObject
      dispatchGroup.leave()
      print("Insta Done")
    }
    
    dispatchGroup.enter()
    fetchRevelsCupData {
      dispatchGroup.leave()
      print("RevelsCup Done")
    }
    
    dispatchGroup.notify(queue: .main) {
      NSLog("Finished Downloading All Data")
      completion(self.instagramObjects)
    }
  
  }
  
}
