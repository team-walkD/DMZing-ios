//
//  CourseDetailViewController.swift
//  DMZing
//
//  Created by 김예은 on 12/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    
    @IBOutlet weak var detailButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -88, left: 0, bottom: 0, right: 0)
        
        setBackBtn(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        setRightBarButtonItem()
        
        backView1.makeRounded(cornerRadius: 10)
        backView1.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        backView2.makeRounded(cornerRadius: 10)
        backView2.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        detailButton.makeRounded(cornerRadius: 20)

        // Do any additional setup after loading the view.
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

}
