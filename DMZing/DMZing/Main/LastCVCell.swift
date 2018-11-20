//
//  LasatCVCell.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class LastCVCell: UICollectionViewCell {
     @IBOutlet weak var backWhiteView : UIView!
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
         backWhiteView.makeRoundOnlyTop(radius: 10)
    }
}
