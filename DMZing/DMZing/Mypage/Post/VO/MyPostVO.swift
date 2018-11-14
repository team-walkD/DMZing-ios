//
//  MyPostVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 14..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias MyPostVO = [MyPostVOData]

struct MyPostVOData: Codable {
    let letterImageURL: String
    enum CodingKeys: String, CodingKey {
        case letterImageURL = "letterImageUrl"
    }
}
