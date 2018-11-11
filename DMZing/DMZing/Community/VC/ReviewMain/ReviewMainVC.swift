//
//  ReviewMainVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 2..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

struct SampleReviewMainStruct {
    let cnt : Int
    let title : String
    let imgUrl : String
}

class ReviewMainVC: UIViewController {

    var reviewMainArr : [SampleReviewMainStruct] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        addDummyData()
        
    }
    
    private func addDummyData(){
        let imgUrlArr = ["https://pbs.twimg.com/media/DUcm7xQVoAE5q4Z.jpg", "https://pbs.twimg.com/media/DPDN06VVoAEfXG_.jpg", "https://post-phinf.pstatic.net/MjAxODA0MTBfMTQ2/MDAxNTIzMzQxMDQxODYw.aO_dJut4YK-3jjbJ_dw49KG5Cl8nGQjhbBX8S1elmE8g.sIvK_NXFGk7KYJo-OcUWExWGlJVxgMja-2SokwVf9wUg.JPEG/2.jpg?type=w1200",  "https://i.pinimg.com/originals/f0/a7/02/f0a70248f3c8d5887c2c66f49d7fc570.png","https://pbs.twimg.com/media/C46e96dUMAMuD96.jpg"]
        let titleArr = ["수진날진의 여행기", "장드타는 왜 장드타", "예은 와서 뷰짠다", "승미야 일해!", "융선픽"]
        let a = SampleReviewMainStruct(cnt: 10, title: titleArr[0], imgUrl: imgUrlArr[0])
        let b = SampleReviewMainStruct(cnt: 10, title: titleArr[1], imgUrl: imgUrlArr[1])
        let c = SampleReviewMainStruct(cnt: 10, title: titleArr[2], imgUrl: imgUrlArr[2])
        let d = SampleReviewMainStruct(cnt: 10, title: titleArr[3], imgUrl: imgUrlArr[3])
        let e = SampleReviewMainStruct(cnt: 10, title: titleArr[4], imgUrl: imgUrlArr[4])
        
        reviewMainArr.append(contentsOf: [a,b,c,d,e])
    }
    
    @IBAction func writeAction(_ sender: Any) {
        let reviewStoryboard = Storyboard.shared().reviewStoryboard
 
        let writeEntryVC = reviewStoryboard.instantiateViewController(withIdentifier:"reviewNavi")
        
        self.present(writeEntryVC, animated: true, completion: nil)
        
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
            cell.configure(data: reviewMainArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reviewStoryboard = Storyboard.shared().reviewStoryboard
        if let reviewDetailVC = reviewStoryboard.instantiateViewController(withIdentifier:ReviewDetailVC.reuseIdentifier) as? ReviewDetailVC {
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
