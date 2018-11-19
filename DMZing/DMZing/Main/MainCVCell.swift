//
//  MainCVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 28..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MainCVCell: UICollectionViewCell,APIService {
    
    @IBOutlet weak var titleImgView: UIImageView!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var findLetterButton: UIButton!
    //수진
    var findLetterHandler : ((_ idx : Int, _ sender : UIButton)->Void)?
    /*let userDefault = UserDefaults.standard*/
    
    override func awakeFromNib() {
        findLetterButton.layer.cornerRadius = findLetterButton.frame.height/2
        titleImgView.roundCorners(corners: [.topLeft,.topRight], radius: 0.2)
        self.makeCellCornerRound(corners: [.topLeft,.topRight], cornerRadius: 10)
        
        findLetterButton.addTarget(self, action: #selector(find(_:)), for: .touchUpInside)
    }
    
    @objc func find(_ sender: UIButton){
        //수진
        findLetterHandler!(sender.tag, sender)
        /*var cid = userDefault.data(forKey: "cid")
        
        var pid = sender.tag
        
        let URL = url("mission")
        
        let body: [String: Any] = [
            "cid": cid,
            "pid": pid,
            "latitude": 38.1879930099,
            "longitude": 127.2182962522
        ]*/
    }
}
