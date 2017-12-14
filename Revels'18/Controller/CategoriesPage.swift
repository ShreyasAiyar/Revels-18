//
//  EventsCollectionCollectionViewController.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 30/11/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private let reuseIdentifier = "Cell"


class CategoriesPage: UICollectionViewController,NVActivityIndicatorViewable {

    //MARK: Creating Objects
    let cacheCheck = CacheCheck()
    let eventsNetworkingObject = EventsNetworking()
    let httpRequestObject = HTTPRequest()
    let eventsURL = "https://api.mitportals.in/events/"
    var events:[Events] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
    }
    
    func configureController(){
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 100
        NVActivityIndicatorView.DEFAULT_TYPE = .ballSpinFadeLoader
        eventsMain()
    }
    
    
    
    
    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    
        return cell
    }
    
    
    //MARK: Networking Call - Fetch Categories
    func eventsMain(){
        
        startAnimating()
        httpRequestObject.makeHTTPRequestForEvents(eventsURL: eventsURL){
            result in
            switch result{
            case .Success(let parsedJSON):
                for event in parsedJSON["data"] as! [Dictionary<String,String>]{
                    let eventObject = Events(dictionary: event)
                    self.events.append(eventObject)
                }
                self.eventsNetworkingObject.saveEventsToCoreData(eventsData: self.events)
                self.stopAnimating()
                
            case .Error(let errorMessage):
                print(errorMessage)
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("You Seem To Be Offline")
                    NSLog("Connection Could Not Be Established")
                }
                
            }
        }
        
    }


}
