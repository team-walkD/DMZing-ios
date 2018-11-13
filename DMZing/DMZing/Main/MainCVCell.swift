//
//  MainCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 28..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MainCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImgView: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var findLetterButton: UIButton!
    
    override func awakeFromNib() {
        findLetterButton.layer.cornerRadius = findLetterButton.frame.height/2
        titleImgView.roundCorners(corners: [.topLeft,.topRight], radius: 0.2)
        self.makeCellCornerRound(corners: [.topLeft,.topRight], cornerRadius: 10)
    }
}
