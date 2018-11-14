//
//  MypageDPVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 14..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct MypageDPVO: Codable {
    let totalDP: Int
    let dpHistoryDtos: [MypageDPVOHistory]
    
    enum CodingKeys: String, CodingKey {
        case totalDP = "totalDp"
        case dpHistoryDtos
    }
}

struct MypageDPVOHistory: Codable {
    let id, createdAt: Int
    let dpType: String
    let dp: Int
}
