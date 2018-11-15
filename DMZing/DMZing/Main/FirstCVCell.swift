//
//  FirstCVCell.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class FirstCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circle2View: UIView!
    @IBOutlet weak var circle3View: UIView!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    
    @IBOutlet weak var courseDetailButton: UIButton!
    
    override func awakeFromNib() {
      courseDetailButton.layer.cornerRadius = courseDetailButton.frame.height/2

       // titleImgView.roundCorners(corners: [.topLeft,.topRight], radius: 0.2)
       // self.makeCellCornerRound(corners: [.topLeft,.topRight], cornerRadius: 10)
    }
    
}
