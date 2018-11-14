//
//  MyDPPointTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyDPPointTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var moneyCntLbl: UILabel!
    @IBOutlet weak var moneyDescLbl: UILabel!

    func configure(data : MypageDPVOHistory){
        titleLbl.text = data.dpType
        dateLbl.text = data.createdAt.timeStampToDate(dateFormat: "MM.dd(EEE)")
        moneyCntLbl.text = data.dp.description + " DP"
        moneyDescLbl.text = data.dp >= 0 ? "충전" : "차감"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
