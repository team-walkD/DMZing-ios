//
//  ReviewMainCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 2..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewMainCVCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cntLbl: UILabel!
   
    func configure(data : SampleReviewMainStruct){
        cntLbl.text = data.cnt.description
        titleLbl.text = data.title
        mainImgView.setImgWithKF(url: data.imgUrl, defaultImg: #imageLiteral(resourceName: "ccc"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.makeRounded(cornerRadius: nil)
        backView.makeViewBorder(width: 0.5, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        blueView.makeRounded(cornerRadius: nil)
    }
}
