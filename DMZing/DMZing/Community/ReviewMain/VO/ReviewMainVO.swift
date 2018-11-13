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
    let typeName: MapType
    let conut: Int
    let imageUrl : String
    let courseId : Int
}

enum MapType: String, Codable {
    case DATE = "데이트"
    case HISTORY = "역사기행"
    case ADVENTURE = "탐험"
}
