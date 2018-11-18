//
//  MapCoverViewController.swift
//  DMZing
//
//  Created by 김예은 on 11/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class MapCoverViewController: UIViewController {
    
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var pickLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    var id: Int?
    var sub: String?
    var main: String?
    var pick: Int?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackBtn(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
//        setRightBarButtonItem()
        
        smallLabel.text = sub
        largeLabel.text = main
        pickLabel.text = String(gino(pick))
        backImageView.kf.setImage(with: URL(string: gsno(imageUrl)), placeholder: UIImage())
    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
//    //MARK: rightBarButtonItem Setting
//    func setRightBarButtonItem() {
//        let rightButtonItem = UIBarButtonItem.init(
//            title: "",
//            style: .done,
//            target: self,
//            action: #selector(rightButtonAction(sender:))
//        )
//
//        rightButtonItem.image = #imageLiteral(resourceName: "walk_d_white_icon.png")
//        rightButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.navigationItem.rightBarButtonItem = rightButtonItem
//    }
//
//    //MARK: rightBarButtonItem Action
//    @objc func rightButtonAction(sender: UIBarButtonItem) {
//
//    }
//

    
    //MARK: 보러가기 액션
    @IBAction func detailAction(_ sender: UIButton) {
        let infoVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
        
        infoVC.cid = gino(id)
        
        self.present(infoVC, animated: true, completion: nil)
        
    }
    
}
