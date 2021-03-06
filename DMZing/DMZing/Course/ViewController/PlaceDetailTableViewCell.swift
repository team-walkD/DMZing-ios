//
//  PlaceDetailTableViewCell.swift
//  DMZing
//
//  Created by 김예은 on 15/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class PlaceDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var hiddenTimeLabel: UILabel!
    @IBOutlet weak var hiddenStackView: UIStackView!
    
    @IBOutlet weak var nextImageView1: UIImageView!
    @IBOutlet weak var nextImageView2: UIImageView!
    @IBOutlet weak var nextImageView3: UIImageView!
    @IBOutlet weak var nextLabel1: UILabel!
    @IBOutlet weak var nextLabel2: UILabel!
    @IBOutlet weak var nextLabel3: UILabel!
    
    @IBOutlet weak var lineView: UIView!

}
