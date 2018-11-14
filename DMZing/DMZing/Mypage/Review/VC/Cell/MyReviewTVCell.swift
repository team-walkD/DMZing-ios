//
//  MyReviewTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyReviewTVCell: UITableViewCell {
   
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typeImgView: UIImageView!
    
    func configure(data : MypageReviewVOData){
        dateLbl.text = data.createdAt.timeStampToDate()
        titleLbl.text = data.title
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
