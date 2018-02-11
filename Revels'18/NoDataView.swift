//
//  NoDataView.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 11/02/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class NoDataView: UIView {

  @IBOutlet weak var noDataImageView: UIImageView!
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var secondaryLabel: UILabel!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func loadView(){
    Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
  }
  
}
