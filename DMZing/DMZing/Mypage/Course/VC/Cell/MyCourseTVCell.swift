//
//  MyCourseTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyCourseTVCell: UITableViewCell {

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(data : MyCourseVOData){
        titleLbl.text = data.title
        descLbl.text = data.mapName+"하기 좋은 핫스팟"
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
