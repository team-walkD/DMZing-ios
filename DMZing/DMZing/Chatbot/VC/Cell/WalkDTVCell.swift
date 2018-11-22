//
//  WalkDTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WalkDTVCell: UITableViewCell {
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var walkDImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        walkDImg.makeRounded(cornerRadius: nil)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
