//
//  RevelsCupModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 15/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct RevelsCups{
  let sname:String
  let date:String
  let time:String
  let venue:String
  let team1:String
  let team2:String
  
  init(dictionary:Dictionary<String,String>){
    self.sname = dictionary["sname"]!
    self.date = dictionary["date"]!
    self.time = dictionary["time"]!
    self.venue = dictionary["venue"]!
    self.team1 = dictionary["team1"]!
    self.team2 = dictionary["team2"]!
    
  }
}
