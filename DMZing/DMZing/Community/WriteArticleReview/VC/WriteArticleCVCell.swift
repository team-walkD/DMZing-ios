//
//  WriteArticleCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 9..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WriteArticleCVCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImgView: UIImageView!

    func configure(data : String){
        mainImgView.setImgWithKF(url: data, defaultImg: #imageLiteral(resourceName: "photo_review_plus_img"))
    }
    
    
}
