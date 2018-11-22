//
//  LinkTableViewCell.swift
//  DMZing
//
//  Created by 김예은 on 22/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagLabel2: UILabel!
    
    @IBOutlet weak var linkLabel1: UILabel!
    @IBOutlet weak var linkTextView1: UITextView!
    @IBOutlet weak var linkImageView1: UIImageView!
    
    @IBOutlet weak var linkLabel2: UILabel!
    @IBOutlet weak var linkTextView2: UITextView!
    @IBOutlet weak var linkImageView2: UIImageView!
    
    @IBOutlet weak var linkLabel3: UILabel!
    @IBOutlet weak var linkTextView3: UITextView!
    @IBOutlet weak var linkImageView3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        backView.clipsToBounds = true
//        backView.layer.cornerRadius = 10
//        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
//        titleView.clipsToBounds = true
//         .layer.cornerRadius = 10
//        titleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
