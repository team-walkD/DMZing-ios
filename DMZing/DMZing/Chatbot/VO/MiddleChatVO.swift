//
//  MiddleChatVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

struct MiddleChatVO: Codable {
    let status: Int
    let message: String
    let result: [MiddleChatVOResult]
}

struct MiddleChatVOResult: Codable {
    let id: Int
    let description: String
}
