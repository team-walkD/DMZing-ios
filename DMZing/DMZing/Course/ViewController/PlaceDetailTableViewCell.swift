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
    @IBOutlet weak var reverseButton: UIButton!
    
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var pmLabel: UILabel!
    @IBOutlet weak var placeImageView: UIView!
    
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    
    @IBOutlet weak var nextImageView1: UIImageView!
    @IBOutlet weak var nextImageView2: NSLayoutConstraint!
    @IBOutlet weak var nextImageView3: UIImageView!
    @IBOutlet weak var nextLabel1: UILabel!
    @IBOutlet weak var nextLabel2: UILabel!
    @IBOutlet weak var nextLabel3: UILabel!
    
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.hideViewHeight.constant = 386
                
            } else {
                self.hideViewHeight.constant = 0.0
            }
        }
    }

}
