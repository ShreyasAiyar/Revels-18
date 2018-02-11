//
//  InstagramCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 31/12/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class InstagramCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileView: UIImageView!
  @IBOutlet weak var instaView: UIImageView!
  @IBOutlet weak var captionLabel: UITextView!
  @IBOutlet weak var likeCount: UILabel!
  @IBOutlet weak var commentCount: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var time: UILabel!
  
  var delegate:SaveImageProtocol?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileView.clipsToBounds = true
    profileView.layer.borderColor = UIColor.black.cgColor
    profileView.layer.borderWidth = 1
    profileView.layer.cornerRadius = profileView.frame.height/2
    
  }
  
  @IBAction func didSelectMoreButton(_ sender: Any) {
    delegate?.saveImageToPhotos(image: self.instaView.image!)
  }
}

protocol SaveImageProtocol{
  func saveImageToPhotos(image:UIImage)
}
