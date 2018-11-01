//
//  ArticleReviewCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 2..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ArticleReviewCVCell: UICollectionViewCell {
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var likeCntLbl: UILabel!
    @IBOutlet weak var blackOpacityView : UIView!
    var mainImgView = UIImageView()
    
        
    func configure(data : SampleArticleReviewStruct){
        startDateLbl.text = data.startDate
        endDateLbl.text = data.endDate
        likeCntLbl.text = data.likeCount.description
        titleLbl.text = data.title
        mainImgView.setImgWithKF(url: data.imgUrl, defaultImg: #imageLiteral(resourceName: "ccc"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.clipsToBounds = false
        outerView.layer.applySketchShadow(alpha : 0.06, x : 0, y : 0, blur : 6, spread : 0)
        outerView.backgroundColor = UIColor.clear
        mainImgView.frame = outerView.bounds
        mainImgView.clipsToBounds = true
        mainImgView.layer.cornerRadius = 5
        outerView.addSubview(mainImgView)
        mainImgView.addSubview(blackOpacityView)
    }
}
