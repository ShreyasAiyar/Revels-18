//
//  HomeViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 08/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension HomeViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! NewHomeViewCell
        cell.homeLabel.text = "Conclave"
        cell.layer.cornerRadius = 8
        collectionView.backgroundColor = UIColor.white
        return cell
    }
    
    
}
