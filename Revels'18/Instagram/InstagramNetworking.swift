//
//  InstagramNetworking.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 09/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import Foundation
import UIKit

class InstagramNetworking{
    
    let instagramURL = "https://api.instagram.com/v1/tags/techtatva17/media/recent?access_token=630237785.f53975e.8dcfa635acf14fcbb99681c60519d04c"
    let httpRequestObject = HTTPRequest()
    
    func fetchInstagram(completion: @escaping (_ instaObjects:[Instagram]) -> ()){
        var instaObjects:[Instagram] = []
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: instagramURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                let instaData = parsedJSON as Dictionary<String,Any>
                for instaDataItem in instaData["data"] as! [Dictionary<String,Any>]{
                    let instaObject = Instagram(dictionary: instaDataItem)
                    instaObjects.append(instaObject)
                }
                completion(instaObjects)
            case .Error(let errorString):
                DispatchQueue.main.async {
                    print(errorString)
                    completion(instaObjects)
                }
            }
        }
    }
    
}
