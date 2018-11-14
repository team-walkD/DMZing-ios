//
//  MyPostCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit


class MyPostCVCell: UICollectionViewCell {
    @IBOutlet weak var postImgView: UIImageView!
    
    func configure(data : String){
        postImgView.setImgWithKF(url: data, defaultImg: #imageLiteral(resourceName: "ccc"))
    }
    
}
