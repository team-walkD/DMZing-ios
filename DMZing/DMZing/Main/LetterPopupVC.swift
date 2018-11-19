//
//  LetterPopupVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 19..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class LetterPopupVC: UIViewController {

    var letterImgUrl = ""
    @IBOutlet weak var letterImgView: UIImageView!
    
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        letterImgView.setImgWithKF(url: letterImgUrl, defaultImg: UIImage())
        letterImgView.makeRounded(cornerRadius: 10)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
