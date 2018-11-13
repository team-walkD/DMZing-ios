//
//  PhotoReviewVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias PhotoReviewVO = [PhotoReviewVOData]

struct PhotoReviewVOData: Codable {
    let startAt: Int
    let imageURL, placeName: String
    let courseID: Int
    
    enum CodingKeys: String, CodingKey {
        case startAt
        case imageURL = "imageUrl"
        case placeName
        case courseID = "courseId"
    }
}
