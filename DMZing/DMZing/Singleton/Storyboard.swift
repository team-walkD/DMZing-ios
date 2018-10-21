//
//  Storyboard.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
class Storyboard {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let categoryStoryboard = UIStoryboard(name: "Course", bundle: nil)
    let mapStoryboard = UIStoryboard(name: "Community", bundle: nil)
    let mypageStoryboard = UIStoryboard(name: "Mypage", bundle: nil)
    
    struct StaticInstance {
        static var instance: Storyboard?
    }
    
    class func shared() -> Storyboard {
        if StaticInstance.instance == nil {
            StaticInstance.instance = Storyboard()
        }
        return StaticInstance.instance!
    }
}
