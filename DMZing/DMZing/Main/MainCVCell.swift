//
//  MainCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 28..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

extension UIView{
    func makeRoundOnlyTop(radius : CGFloat){
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

class MainCVCell: UICollectionViewCell,APIService {
    
    @IBOutlet weak var titleImgView: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var findLetterButton: UIButton!

    var findLetterHandler : ((_ idx : Int, _ sender : UIButton)->Void)?
  
    
    override func awakeFromNib() {
        findLetterButton.layer.cornerRadius = findLetterButton.frame.height/2
        findLetterButton.addTarget(self, action: #selector(find(_:)), for: .touchUpInside)
        titleImgView.makeRoundOnlyTop(radius: 10)
    }
    
    @objc func find(_ sender: UIButton){

        findLetterHandler!(sender.tag, sender)

    }
}
