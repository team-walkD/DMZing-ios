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
}

//MARK: - CollectionView Method
extension MainMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMapCollectionViewCell", for: indexPath) as! MainMapCollectionViewCell
        
        cell.courseImageView.kf.setImage(with: URL(string: courses[indexPath.row].imageUrl), placeholder: UIImage())
        cell.smallLabel.text = courses[indexPath.row].subDescription
        cell.largeLabel.text = courses[indexPath.row].mainDescription
        cell.pageLabel.text = String(courses[indexPath.row].id)
        cell.totalPageLabel.text = String(courses.count)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coverVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "MapCoverViewController") as! MapCoverViewController
        
        coverVC.sub = courses[indexPath.row].subDescription
        coverVC.main = courses[indexPath.row].mainDescription
        coverVC.pick = courses[indexPath.row].pickCount
        coverVC.id = courses[indexPath.row].id
        
        self.navigationController?.pushViewController(coverVC, animated: true)
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
        } else if finalOffset < startOffset {
            //앞으로 가기
            let majorIdx = indexOfMajorCell(direction: .left)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mapCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            //TODO: 이미지 변경 확인
            mapImageView.kf.setImage(with: URL(string: courses[currentIdx].lineImageUrl), placeholder: UIImage())
        } else {
            print("둘다 아님")
        }
    }
}



