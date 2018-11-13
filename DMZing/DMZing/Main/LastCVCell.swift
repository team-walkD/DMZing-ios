//
//  LasatCVCell.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class LastCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var findAnotherButton: UIButton!
    
    override func awakeFromNib() {
        findAnotherButton.layer.cornerRadius = findAnotherButton.frame.height/2
        titleImgView.makeRounded(cornerRadius: nil)
        self.makeCellCornerRound(corners: [.topLeft,.topRight], cornerRadius: 10)
    }
}
