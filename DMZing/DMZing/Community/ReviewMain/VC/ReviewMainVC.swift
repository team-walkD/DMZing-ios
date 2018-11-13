//
//  ReviewMainVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 2..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewMainVC: UIViewController, APIService {

    var reviewMainArr : [ReviewMainVOData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getReviewType(url: self.url("reviews/count"))
        }
    }

}

extension ReviewMainVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewMainArr.count
    }
    //헤더 뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReviewMainHeaderView",for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: ReviewMainCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewMainCVCell.reuseIdentifier, for: indexPath) as? ReviewMainCVCell {
            guard reviewMainArr.count > 0 else {return cell}
            cell.configure(data: reviewMainArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reviewStoryboard = Storyboard.shared().reviewStoryboard
        if let reviewDetailVC = reviewStoryboard.instantiateViewController(withIdentifier:ReviewDetailVC.reuseIdentifier) as? ReviewDetailVC {
            reviewDetailVC.selectedMapId = 1 //DATE, HISTORY, ADVENTURE
            self.navigationController?.pushViewController(reviewDetailVC, animated: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (scrollView.contentOffset.y > 50)
    }
}

extension ReviewMainVC: UICollectionViewDelegateFlowLayout {
    
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 143, height: 143)
    }
    
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 27
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ReviewMainVC {
    func getReviewType(url : String){
        GetReviewMainService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let reviewMainData = data as? ReviewMainVO
                if let reviewMainData_ = reviewMainData {
                    self.reviewMainArr = reviewMainData_
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
