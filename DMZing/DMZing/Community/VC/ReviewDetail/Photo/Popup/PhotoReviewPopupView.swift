//
//  PhotoReviewPopupView.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 2..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class PhotoReviewPopupView: UIView {
    
    @IBOutlet weak var cancleBtn: UIButton!
   
    @IBOutlet weak var mainImgView: UIImageView!
    class func instanceFromNib() -> PhotoReviewPopupView {
        let view = UINib(nibName: PhotoReviewPopupView.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PhotoReviewPopupView
        
        return view
    }
    
}
