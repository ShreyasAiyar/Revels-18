//
//  ResultsModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation

struct Results{
    let tid:String
    let cat:String
    let eve:String
    let evename:String
    let round:String
    let pos:String
    let name:String
    
    init(dictionary:Dictionary<String,String>) {
        self.tid = dictionary["tid"]!
        self.cat = dictionary["cat"]!
        self.eve = dictionary["eve"]!
        self.evename = dictionary["evename"]!
        self.round = dictionary["round"]!
        self.pos = dictionary["pos"]!
        self.name = self.evename
    }
    
}
