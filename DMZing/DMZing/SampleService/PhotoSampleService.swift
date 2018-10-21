//
//  PhotoSampleService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

//1. 어떤 프로토콜 따를건지 선언 -> Get / Post / PostWithPhoto
struct PhotoSampleService : PostablewithPhoto {
    //2. 네트워크 결과물로서 받아온 형태의 VO 설정
    typealias NetworkData = SampleVO
    //3.static 으로 인스턴스 생성해서 바로 전급 가능하도록
    static let shareInstance = PhotoSampleService()
    //3-1. VC에서 쓸 함수 설정. 파라미터로 url과 completion 받음
    func editProfile(url : String, params : [String : Any], image : [String : Data]?, completion : @escaping (NetworkResult<Any>) -> Void){
        //3-2. PostablewithPhoto 안의 함수 사용. 이로 인해 Alamofire 일일히 코드 안써도 됨
        savePhotoContent(url, params: params, imageData: image) { (result) in
            switch result {
                //4. resCode 에 따라서 분기
            case .success(let networkResult):
                switch networkResult.resCode {
                    //5. 성공했으면 .networkSuccess안에 데이터 담아서 보내고 VC 에서 받아 쓰기
                case HttpResponseCode.postSuccess.rawValue :
                    completion(.networkSuccess(""))
                    //6. 성공아니면 다른 NetworkResult에 적당한거 만들거나 골라서 쏴주면 됨. 그리고 VC에서 그걸로 처리
                case HttpResponseCode.conflict.rawValue :
                    completion(.duplicated)
                default :
                    print("no 201/409 - statusCode is \(networkResult.resCode)")
                    break
                }
                break
            case .error(let errMsg) :
                print(errMsg)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
    }
}

/*
  VC 예시
func editProfile(url : String, editedName : String ){
    let params : [String : Any] = [
        "name" : editedName
    ]
    
    var images : [String : Data]?
    
    //imageData는 Data? 타입의 VC 지역변수
    if let image = imageData {
        images = [
            "profile_img" : image
        ]
    }
    
    PhotoSampleService.shareInstance.editProfile(url: url, params: params, image: images, completion: { [weak self] (result) in
        guard let `self` = self else { return }
        switch result {
        case .networkSuccess(_):
            let alertTitle = "확인"
            let alertMsg = "수정완료"
            self.simpleAlert(title: alertTitle, message: alertMsg)
        case .duplicated :
            let alertTitle = "오류"
            let alertMsg = "이미 사용중인 닉네임입니다"
            self.simpleAlert(title: alertTitle, message: alertMsg)
        case .networkFail :
            self.networkSimpleAlert()
        default :
            self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            break
        }
    })
}
 */
