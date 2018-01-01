//
//  ResultsModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct Results{
    var tid:String
    var cat:String
    var eve:String
    var evename:String
    var round:String
    var pos:String
    
    init(dictionary:Dictionary<String,String>) {
        self.tid = dictionary["tid"]!
        self.cat = dictionary["cat"]!
        self.eve = dictionary["eve"]!
        self.evename = dictionary["evename"]!
        self.round = dictionary["round"]!
        self.pos = dictionary["pos"]!
    }
    
}
