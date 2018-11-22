//
//  SubChatVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct SubChatVO: Codable {
    let status: Int
    let message: String
    let result: [SubChatVOResult]
}

struct SubChatVOResult: Codable {
    let title, description: String
    let imgURL, webURL: String
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case imgURL = "img_url"
        case webURL = "web_url"
    }
}
