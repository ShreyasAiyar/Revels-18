//
//  WorkshopsModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct Workshops{
    
    let wid:String
    let wname:String
    let wcost:String
    let wshuru:String
    let wkhatam:String
    let wdesc:String
    let wvenue:String
    let cname:String?
    let numb:String?
    
    init(dictionary:Dictionary<String,String>) {
        self.wid = dictionary["wid"]
        self.wname = dictionary["wname"]
        self.wcost = dictionary["wcost"]
        self.wshuru = dictionary["wshuru"]
        self.wkhatam = dictionary["wkhatama"]
        self.wdesc = dictionary["wdesc"]
        self.wvenue = dictionary["wvenue"]
        self.cname = dictionary["cname"]
        self.numb = dictionary["numb"]
    }
    
}
