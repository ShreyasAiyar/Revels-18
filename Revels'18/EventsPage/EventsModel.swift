//
//  Events.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 01/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation


struct Events{
    var ename:String
    var eid:String
    var edesc:String
    var emaxteamsize:String
    var cid:String
    var cname:String
    var cntctname:String
    var cntctno:String
    var day:String

    
    init(dictionary: Dictionary<String,String>) {
        self.ename = dictionary["ename"]!
        self.eid = dictionary["eid"]!
        self.edesc = dictionary["edesc"]!
        self.emaxteamsize = dictionary["emaxteamsize"]!
        self.cid = dictionary["cid"]!
        self.cname = dictionary["cname"]!
        self.cntctno = dictionary["cntctno"]!
        self.cntctname = dictionary["cntctname"]!
        self.day = dictionary["day"]!

    }
    
    
}
