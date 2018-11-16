//
//  PhotoReviewCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class PhotoReviewCVCell: UICollectionViewCell {
    @IBOutlet weak var whiteBGView: RoundShadowView!
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var firstTagLbl: UILabel!
    @IBOutlet weak var secondTagLbl: UILabel!
    
    func configure(data : PhotoReviewVOData){
        dateLbl.text = data.startAt.timeStampToDate()
        titleLbl.text = data.placeName
       // firstTagLbl.text = data.tag[0]
       // secondTagLbl.text = data.tag[1]
        mainImgView.setImgWithKF(url: data.imageURL, defaultImg: #imageLiteral(resourceName: "review_default_img"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        whiteBGView.fillColor = .white
        whiteBGView.cornerRadius = 6
    }
    
}
