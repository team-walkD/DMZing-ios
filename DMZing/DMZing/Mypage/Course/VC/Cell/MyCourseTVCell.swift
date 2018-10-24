//
//  MyCourseTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyCourseTVCell: UITableViewCell {
    
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var bottomBackground: UIView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(row : Int){
        if row == 0 {
            topBackground.backgroundColor = ColorChip.shared().lightBlue
        } else {
            topBackground.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
