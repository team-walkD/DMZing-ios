//
//  ReviewDetailHeaderView.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewDetailHeaderView: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    class func instanceFromNib() -> ReviewDetailHeaderView {

        return UINib(nibName: ReviewDetailHeaderView.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReviewDetailHeaderView
    }
    
}
