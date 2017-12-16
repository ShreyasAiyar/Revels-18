//
//  DevelopersModel.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 16/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit

struct Developers{
    let developerName:String
    let developerImage:UIImage?
    let developerPosition:String
    let developerMessage:String
    
    
    init(developerName:String,developerImage:UIImage?,developerPosition:String,developerMessage:String) {
        self.developerName = developerName
        self.developerImage = developerImage
        self.developerPosition = developerPosition
        self.developerMessage = developerMessage
    }
}
