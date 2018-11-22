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
    
    func configure(data : [SubChatVOResult], selectedMajor : String, selectedMiddle : String){
        tagLabel1.text = "#"+selectedMajor.prefix(3)
        tagLabel2.text = "#"+selectedMiddle
        linkLabel1.text = data[0].title
        linkTextView1.text = data[0].description
        linkImageView1.setImgWithKF(url: data[0].imgURL, defaultImg: UIImage())
        linkLabel2.text = data[1].title
        linkTextView2.text = data[1].description
        linkImageView2.setImgWithKF(url: data[1].imgURL, defaultImg: UIImage())
       /* linkLabel3.text = data[2].title
        linkTextView3.text = data[2].description
        linkImageView3.setImgWithKF(url: data[2].imgURL, defaultImg: UIImage())*/
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        linkImageView1.makeRounded(cornerRadius: nil)
        linkImageView2.makeRounded(cornerRadius: nil)
        linkImageView3.makeRounded(cornerRadius: nil)
    }

}
