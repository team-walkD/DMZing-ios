//
//  Course.swift
//  DMZing
//
//  Created by 김예은 on 16/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import Foundation

typealias CourseData = [Course]

struct Course: Codable {
    let id: Int
    let imageUrl: String
    let isPurchased: Bool
    let lineImageUrl: String
    let mainDescription: String
    let pickCount: Int //추후 삭제
    let price: Int
    let subDescription: String
    let title: String
}

