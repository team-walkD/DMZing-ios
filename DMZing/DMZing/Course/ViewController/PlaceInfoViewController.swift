//
//  PlaceInfoViewController.swift
//  DMZing
//
//  Created by 김예은 on 11/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class PlaceInfoViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackBtn(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        setRightBarButtonItem()
        
        backView.makeRounded(cornerRadius: 10)
        backView.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)

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

//MARK: - UIView Shadow extension
extension UIView {

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
