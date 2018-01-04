//
//  InstagramModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 31/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit

struct Instagram{
    let username:String
    let likesCount:Int
    let text:String
    let standardResolutionURL:String
    let profilePictureURL:String
    let location:String?
    let commentsCount:Int
    
    init(dictionary:Dictionary<String,Any>) {
        let user = dictionary["user"] as! [String:Any]
        self.username = user["username"] as! String
        
        let likes = dictionary["likes"] as! Dictionary<String,Any>
        self.likesCount = likes["count"] as! Int
        
        let caption = dictionary["caption"] as! Dictionary<String,Any>
        self.text = caption["text"] as! String
        
        let images = dictionary["images"] as! Dictionary<String,Any>
        let standard_resolution = images["standard_resolution"] as! Dictionary<String,Any>
        self.standardResolutionURL = standard_resolution["url"] as! String
        
        self.profilePictureURL = user["profile_picture"] as! String
        
        if let dictLocation = dictionary["location"] as? Dictionary<String,Any>?{
            self.location = dictLocation!["name"] as! String
        } else{
            self.location = ""
        }
        
        let comments = dictionary["comments"] as! Dictionary<String,Any>
        self.commentsCount = comments["count"] as! Int
        
    }
}
