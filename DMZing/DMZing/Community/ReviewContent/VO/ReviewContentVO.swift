//
//  ReviewContentVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation
struct ReviewContentVO: Codable {
    let id: Int
    let title, thumbnailURL: String
    let createdAt, courseID, startAt, endAt: Int
    let like: Bool
    let likeCount: Int
    let postDto: [ReviewContentVOPostDTO]
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case thumbnailURL = "thumbnailUrl"
        case createdAt
        case courseID = "courseId"
        case startAt, endAt, like, likeCount, postDto
    }
}

struct ReviewContentVOPostDTO: Codable {
    let day: Int
    let postImgURL: [String]
    let title, content: String
    
    enum CodingKeys: String, CodingKey {
        case day
        case postImgURL = "postImgUrl"
        case title, content
    }
}
