//
//  WriteEntryTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 9..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WriteEntryTVCell: UITableViewCell {

    @IBOutlet weak var outerView: RoundShadowView!
    
    @IBOutlet weak var dayLbl: UILabel!
    func configure(data : String){
        dayLbl.text = "DAY "+data
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
