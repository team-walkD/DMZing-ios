//
//  MyCourseVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 14..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias MyCourseVO = [MyCourseVOData]

struct MyCourseVOData: Codable {
    let cId : Int
    let title: String
    let isPicked: Bool
    let mainDescription : String
    
    enum CodingKeys: String, CodingKey {
        case title, isPicked, mainDescription
        case cId = "id"
    }
}

