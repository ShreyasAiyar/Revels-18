//
//  SportResultsModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 17/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct SportsResults{
  let teamID:String
  let catid:String
  let evename:String
  let roundno:String
  let position:String
  
  init(dictionary:Dictionary<String,String>){
    self.teamID = dictionary["teamid"]!
    self.catid = dictionary["catid"]!
    self.evename = dictionary["evename"]!
    self.roundno = dictionary["roundno"]!
    self.position = dictionary["position"]!
  }
  
}
