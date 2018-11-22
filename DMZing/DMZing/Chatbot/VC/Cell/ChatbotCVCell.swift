//
//  ChatbotCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ChatbotCVCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.makeRounded(cornerRadius: nil)
        backView.makeViewBorder(width: 1.5, color: UIColor.FlatColor.Blue.middleBlue)
    }
}
