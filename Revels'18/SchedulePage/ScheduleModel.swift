//
//  ScheduleModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct Schedules{
  let eid:String
  let ename:String
  let catid:String
  let catname:String
  let round:String
  let venue:String
  let stime:String
  let etime:String
  let day:String
  let date:String
  let isRevels:String
  
  init(dictionary:Dictionary<String,String>) {
    self.eid = dictionary["eid"]!
    self.ename = dictionary["ename"]!
    self.catid = dictionary["catid"]!
    self.catname = dictionary["catname"]!
    self.round = dictionary["round"]!
    self.venue = dictionary["venue"]!
    self.stime = dictionary["stime"]!
    self.etime = dictionary["etime"]!
    self.day = dictionary["day"]!
    self.date = dictionary["date"]!
    self.isRevels = dictionary["isRevels"]!
  }
  
}

