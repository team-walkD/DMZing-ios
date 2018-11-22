//
//  MyChatTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyChatTVCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!

    @IBOutlet weak var myNickLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
