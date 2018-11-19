//
//  PhotoReviewPopupVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 19..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class PhotoReviewPopupVC: UIViewController {
    var photoImgUrl = ""
    @IBOutlet weak var photoImgView: UIImageView!
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImgView.setImgWithKF(url: photoImgUrl, defaultImg: UIImage())
        photoImgView.makeRounded(cornerRadius: 10)
        // Do any additional setup after loading the view.
    }

}
