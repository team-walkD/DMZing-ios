//
//  RoundShadowView.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    var cornerRadius: CGFloat = 7.0
    var fillColor: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.06
            shadowLayer.shadowRadius = 4
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
