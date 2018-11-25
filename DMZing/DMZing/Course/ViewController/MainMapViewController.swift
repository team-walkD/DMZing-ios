//
//  MainMapViewController.swift
//  DMZing
//
//  Created by 김예은 on 09/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class MainMapViewController: UIViewController, APIService {
    
    enum Direction {
        case right
        case left
    }
    
    var courses : [Course] = [] {
        didSet {
            //TODO: 이미지 변경 확인
            mapImageView.kf.setImage(with: URL(string: courses[currentIdx].lineImageUrl), placeholder: UIImage())
//            mapImageView.image = arr[currentIdx]
            mapCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    @IBOutlet weak var mapImageView: UIImageView!
    
    var finalOffset : CGFloat = 0
    var startOffset  : CGFloat = 0
    var currentIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        
        setLogoButton()
        setChatButton()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMainCourseData(url: self.url("course"))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMainCourseData(url: self.url("course"))
        }
    }
}


//MARK: Server
extension MainMapViewController {
    
    func getMainCourseData(url : String){
        MainMapService.shareInstance.getMainCourseData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
                
            case .networkSuccess(let data):
                let mainCourseData = data as? CourseData
                
                if let mainCourseData_ = mainCourseData {
                    self.courses = mainCourseData_
                }
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }

    func postOrder(url : String){
        let params : [String : Any] = [:]

        OrderService.shareInstance.orderCourse(url: url, params: params,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                self.simpleAlert(title: "", message: """
                데이트하기 좋은 코스를
                구매하셨습니다!
                """)
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let `self` = self else { return }
                    self.getMainCourseData(url: self.url("course"))
                }
                
                
                break
            case .networkFail :
                self.networkSimpleAlert()
            case .duplicated :
                self.simpleAlert(title: "", message: "DP가 부족합니다.")
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

//MARK: - CollectionView Method
extension MainMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMapCollectionViewCell", for: indexPath) as! MainMapCollectionViewCell
        
        cell.courseImageView.kf.setImage(with: URL(string: courses[indexPath.row].imageUrl), placeholder: UIImage())
        cell.smallLabel.text = courses[indexPath.row].subDescription
        cell.largeLabel.text = courses[indexPath.row].title
        cell.pageLabel.text = String(courses[indexPath.row].id)
        cell.totalPageLabel.text = String(courses.count)
        cell.dpLabel.text = String("\(courses[indexPath.row].price)DP")
        
        if courses[indexPath.row].isPurchased {
            cell.hiddenImageView.isHidden = true
            cell.hiddenStackView.isHidden = true
            cell.hiddenLockImageView.isHidden = true
        } else {
            cell.hiddenImageView.isHidden = false
            cell.hiddenStackView.isHidden = false
            cell.hiddenLockImageView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if courses[indexPath.row].isPurchased {
            
            let coverVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "MapCoverViewController") as! MapCoverViewController
            
            coverVC.sub = courses[indexPath.row].subDescription
            coverVC.main = courses[indexPath.row].title
            coverVC.pick = courses[indexPath.row].pickCount
            coverVC.cid = courses[indexPath.row].id
            coverVC.imageUrl = courses[indexPath.row].imageUrl
            
            self.navigationController?.pushViewController(coverVC, animated: true)
            
        } else {
            mapAlertwithHandler(title: "", message: """
            데이트하기 좋은 코스를
            구매하시겠습니까?
            """) { (okHandler) in
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let `self` = self else { return }
                    self.postOrder(url: self.url("order/course/\(indexPath.row+1)"))
                }

            }
        }
    }
    
    func mapAlertwithHandler(title: String, message: String, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "구매하기",style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "닫기",style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MainMapViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327.getPortionalLength(), height: 344.getPortionalLength())
    }
    
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14.getPortionalLength()
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - CollectionView drag
extension MainMapViewController : UIScrollViewDelegate {
    /**
     현재 메인셀의 인덱스를 구하는 함수
     */
    private func indexOfMajorCell(direction : Direction) -> Int {
        var index = 0
        
        switch direction {
        case .right :
            index = currentIdx + 1
        case .left :
            index = currentIdx - 1
        }
        
        let numberOfItems = mapCollectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        currentIdx = safeIndex
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = mapCollectionView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        finalOffset = mapCollectionView.contentOffset.x
        //stop scrollview sliding
        targetContentOffset.pointee = scrollView.contentOffset
        
        if finalOffset > startOffset {
            //뒤로 넘기기
            let majorIdx = indexOfMajorCell(direction: .right)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mapCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //TODO: 이미지 변경 확인
            mapImageView.kf.setImage(with: URL(string: courses[currentIdx].lineImageUrl), placeholder: UIImage())
//             mapImageView.image = arr[currentIdx]
        } else if finalOffset < startOffset {
            //앞으로 가기
            let majorIdx = indexOfMajorCell(direction: .left)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mapCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //TODO: 이미지 변경 확인
            mapImageView.kf.setImage(with: URL(string: courses[currentIdx].lineImageUrl), placeholder: UIImage())
//             mapImageView.image = arr[currentIdx]
        } else {
            print("둘다 아님")
        }
    }
}



