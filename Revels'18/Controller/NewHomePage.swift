//
//  NewHomePage.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 09/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewHomePage: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewHomeCell", for: indexPath) as! NewHomeViewCell
        cell.homeLabel.text = "Conclave"
        cell.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.lightGray.cgColor
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
        
        if (indexPath.section == 0){

        let imageFrame:CGRect = CGRect(x: 0, y: 0, width:(cellHeader.frame.width), height: 120)
        let image:UIImageView = UIImageView(frame: imageFrame)
        image.image = UIImage(named: "Revels Banner")
        cellHeader.addSubview(image)
        
        let labelFrame:CGRect = CGRect(x: 10, y: 125, width: 100, height: 50)
        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.text = "Events"
        headerLabel.textColor = UIColor.red
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
        cellHeader.addSubview(headerLabel)
        }
        else if(indexPath.section == 1){
        let labelFrame:CGRect = CGRect(x: 10, y: 0, width: 100, height: 50)
        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.text = "Categories"
        headerLabel.textColor = UIColor.red
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
        cellHeader.addSubview(headerLabel)
        }
        else if(indexPath.section == 2){
        let labelFrame:CGRect = CGRect(x: 10, y: 0, width: 100, height: 50)
        let headerLabel = UILabel(frame: labelFrame)
        headerLabel.text = "Results"
        headerLabel.textColor = UIColor.red
        headerLabel.font = UIFont.boldSystemFont(ofSize: headerLabel.font.pointSize)
        cellHeader.addSubview(headerLabel)
        }
        
        return cellHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let headerSize:CGSize
        if (section == 0){
            headerSize = CGSize(width: self.view.frame.width, height: 170)
        }
        else{
            headerSize = CGSize(width: self.view.frame.width, height: 50)
        }
            return headerSize
    }
    
}
