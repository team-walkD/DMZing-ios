//
//  ColorChip.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
class ColorChip {
    //rgb 197 220 233
    let lightBlue = #colorLiteral(red: 0.7725490196, green: 0.862745098, blue: 0.9137254902, alpha: 1)
    //rgb 109 168 199
    let middleBlue = #colorLiteral(red: 0.4274509804, green: 0.6588235294, blue: 0.7803921569, alpha: 1)
    //rgb 28 55 72
    let deepBlue = #colorLiteral(red: 0.1098039216, green: 0.2156862745, blue: 0.2823529412, alpha: 1)
    let barbuttonColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    
    struct StaticInstance {
        static var instance: ColorChip?
    }
    
    class func shared() -> ColorChip {
        if StaticInstance.instance == nil {
            StaticInstance.instance = ColorChip()
        }
        return StaticInstance.instance!
    }
}
