//
//  MypageMainVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 11..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct MypageMainVO: Codable {
    let email, nick: String
    let courseCount, reviewCount, dp: Int
}
