//
//  ArticleReviewVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias ArticleReviewVO = [ArticleReviewVOData]

struct ArticleReviewVOData: Codable {
    let id: Int
    let title, thumbnailURL: String
    let createdAt, courseID, startAt, endAt: Int
    let like: Bool
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbnailURL = "thumbnailUrl"
        case createdAt
        case courseID = "courseId"
        case startAt, endAt, like, likeCount
    }
}
