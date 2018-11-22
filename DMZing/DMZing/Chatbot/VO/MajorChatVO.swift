//
//  MajorChatVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct MajorChatVO: Codable {
    let status: Int
    let message: String
    let result: [MajorChatVOResult]
}

struct MajorChatVOResult: Codable {
    let groups: Int
    let description: String
}
