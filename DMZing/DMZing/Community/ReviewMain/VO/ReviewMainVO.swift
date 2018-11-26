//
//  ReviewMainVO.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 13..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

typealias ReviewMainVO = [ReviewMainVOData]

struct ReviewMainVOData: Codable {
    let typeName: String
    let conut: Int
    let imageUrl : String
    let mapType : MapType
    
    enum CodingKeys: String, CodingKey {
        case typeName, conut, imageUrl
        case mapType = "courseId"
    }
}

enum MapType: Int, Codable {
    case DATE = 1
    case HISTORY = 2
    case ADVENTURE = 3
}
