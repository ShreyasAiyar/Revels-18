//
//  CategoriesMode.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 03/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation


struct Categories{
    let cid:String
    let cname:String
    let cdesc:String
    
    init(dictionary:Dictionary<String,String>) {
        self.cid = dictionary["cid"]!
        self.cname = dictionary["cname"]!
        self.cdesc = dictionary["cdesc"]!
    }
}
