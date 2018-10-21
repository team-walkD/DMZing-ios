//
//  PostSampleService.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import Foundation

//1. 어떤 프로토콜 따를건지 선언 -> Get / Post / PostWithPhoto
struct PostSampleService: PostableService{
    //2. 네트워크 결과물로서 받아온 형태의 VO 설정
    typealias NetworkData = SampleVO
    //3.static 으로 인스턴스 생성해서 바로 전급 가능하도록
    static let shareInstance = PostSampleService()
    //3-1. VC에서 쓸 함수 설정. 파라미터로 url과, parmas 딕셔너리 그리고 completion 받음
    func subscribe(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
         //3-2. PostableService 안의 함수 사용. 이로 인해 Alamofire 일일히 코드 안써도 됨
        post(url, params: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                    //4. resCode 에 따라서 분기
                case HttpResponseCode.postSuccess.rawValue :
                   //5. 성공했으면 .networkSuccess안에 데이터 담아서 보내고 VC 에서 받아 쓰기 completion(.networkSuccess(networkResult.resResult.data))
                    completion(.networkSuccess(networkResult.resResult.data))
                 //6. 성공아니면 다른 NetworkResult에 적당한거 만들거나 골라서 쏴주면 됨. 그리고 VC에서 그걸로 처리
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 201/500 rescode is \(networkResult.resCode)")
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
func subscribe(url : String, params : [String:Any]){
    PostSampleService.shareInstance.subscribe(url: url, params : params, completion: { [weak self] (result) in
        guard let `self` = self else { return }
        switch result {
        case .networkSuccess(let data):
            //data받아서 쓰셈
            self.mainData = data as? SampleVOData
        case .networkFail:
            self.networkSimpleAlert()
        default :
            self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            break
        }
    })
}
 */
