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
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var navi: UINavigationBar!
    
    var cid: Int = 0
    var num: String = ""
    var content: String = ""
    var restDay: String = ""
    var parking: String = ""
    var infoCenter: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        backView.makeRounded(cornerRadius: 10)
        backView.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        numberLabel.text = "0\(num)"
        contentTextView.text = content
        closedLabel.text = restDay
        parkingLabel.text = parking
        phoneLabel.text = infoCenter

    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        
        navi.isTranslucent = true
        navi.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navi.shadowImage = UIImage()
        navi.backgroundColor = UIColor.clear
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
