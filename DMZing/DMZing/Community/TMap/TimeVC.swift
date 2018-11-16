//
//  TimeVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 17..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class TimeVC: UIViewController, APIService {
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lat = Y Long = X
        let startX1 = 127.4459299 //long
        let startY1 = 36.363467 //lat
        let endX1 = 127.4394301//long
        let endY1 = 36.3653323 //lat38.5763238583
        //통신 1,2,3,4 에 대한 lat long 각각 asyn 로 돌리고 그것들이 다 끝나면 ui 업데이트 시켜야함
        self.calculateCarTime(startLat: startY1, startLong: startX1, endLat: endY1, endLong: endX1)
    }
}

//통신
extension TimeVC {
    
    func calculateCarTime(startLat : Double, startLong : Double, endLat : Double, endLong : Double){
        let version = 1
        let tollgateFareOption = 1
        let url = "http://api2.sktelecom.com/tmap/routes?version=\(version)&appKey=\(tMapKey)&tollgateFareOption=\(tollgateFareOption)&endX=\(endLong)&endY=\(endLat)&startX=\(startLong)&startY=\(startLat)"
        CalculateTimeService.shareInstance.calculateTimeToNext(url: url, params: [:], completion: { [weak self] (result) in

            guard let `self` = self else { return}
            switch result {
            case .networkSuccess(let data):
                guard let data_ = data as? CalculateTimeVO else {return}
                guard let time = data_.features.first?.properties.carTime, let distance = data_.features.first?.properties.carDistance else {return}
                print(time, distance)
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            }
        })
    }
}
