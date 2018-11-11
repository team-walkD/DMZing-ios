//
//  MapCoverViewController.swift
//  DMZing
//
//  Created by 김예은 on 11/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class MapCoverViewController: UIViewController {
    
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var pickLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()

        setBackBtn(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        setRightBarButtonItem()
    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = true
        
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    //MARK: rightBarButtonItem Setting
    func setRightBarButtonItem() {
        let rightButtonItem = UIBarButtonItem.init(
            title: "",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        
        rightButtonItem.image = #imageLiteral(resourceName: "walk_d_white_icon.png")
        rightButtonItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    //MARK: rightBarButtonItem Action
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        
    }
    
    //MARK: 보러가기 액션
    @IBAction func detailAction(_ sender: UIButton) {
        let infoVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "PlaceInfoViewController") as! PlaceInfoViewController
        
        self.navigationController?.pushViewController(infoVC, animated: true)
        
        
    }
    
}
