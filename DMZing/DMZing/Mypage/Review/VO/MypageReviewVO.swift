//
//  MypageReviewVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 11..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias MypageReviewVO = [MypageReviewVOData]
struct MypageReviewVOData: Codable {
    let id: Int
    let title, thumbnailURL: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbnailURL = "thumbnailUrl"
        case createdAt
    }
}





