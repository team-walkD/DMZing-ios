//
//  MyPageTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyPageTVCell: UITableViewCell {

     @IBOutlet weak var titleLbl: UILabel!
    func configure(data : String){
        titleLbl.text = data
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
