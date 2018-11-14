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
    let mapType: MapType
    let title: String
    let isPicked: Bool
    var mapName : String {
        switch self.mapType.rawValue {
        case 1:
            return "데이트"
        case 2:
            return "역사기행"
        case 3:
            return "탐험"
        default:
            return ""
        }
    }
    enum CodingKeys: String, CodingKey {
        case title, isPicked
        case mapType = "id"
    }
}

