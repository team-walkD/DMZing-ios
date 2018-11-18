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
    
        
    func configure(data : ArticleReviewVOData){
        startDateLbl.text = data.startAt.timeStampToDate()
        endDateLbl.text = data.endAt.timeStampToDate()
        likeCntLbl.text = data.likeCount.description
        titleLbl.text = data.title
        mainImgView.setImgWithKF(url: data.thumbnailURL, defaultImg: #imageLiteral(resourceName: "review_default_img"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.frame = CGRect(x: 0, y: 0, width: 327.getPortionalLength(), height: 200.getPortionalLength())
        outerView.clipsToBounds = false
        outerView.layer.applySketchShadow(alpha : 0.06, x : 0, y : 0, blur : 6, spread : 0)
        outerView.backgroundColor = UIColor.clear
        
        mainImgView.frame = outerView.bounds
        mainImgView.clipsToBounds = true
        mainImgView.layer.cornerRadius = 5
        blackOpacityView.frame = outerView.bounds
        blackOpacityView.clipsToBounds = true
        blackOpacityView.layer.cornerRadius = 5
        
        outerView.addSubview(mainImgView)
        mainImgView.addSubview(blackOpacityView)
    }
}
