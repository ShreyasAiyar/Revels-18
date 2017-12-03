//
//  ScheduleModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct Schedule{
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
    
    init(dictionary:Dictionary<String,String>) {
        self.eid = dictionary["eid"]
        self.ename = dictionary["ename"]
        self.catid = dictionary["catid"]
        self.catname = dictionary["catname"]
        
    }
    
    
    
    
    
}

