//
//  ColorChip.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//


import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIColor {
    struct FlatColor {
        struct Blue {
            static let lightBlue = UIColor(netHex: 0xC5DCE9)
            static let middleBlue = UIColor(netHex: 0x6DA8C7)
            static let deepBlue = UIColor(netHex: 0x1C3748)
           
        }
        struct Gray {
            static let barbuttonGray = UIColor(netHex: 0x707070)
        }
    }
}

