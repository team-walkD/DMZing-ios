//
//  ReviewContentTVCell.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 8..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewContentTVCell: UITableViewCell {
    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottomWhiteView: UIView!
    var imgUrlArr = ["https://pbs.twimg.com/media/DUcm7xQVoAE5q4Z.jpg", "https://pbs.twimg.com/media/DPDN06VVoAEfXG_.jpg", "https://post-phinf.pstatic.net/MjAxODA0MTBfMTQ2/MDAxNTIzMzQxMDQxODYw.aO_dJut4YK-3jjbJ_dw49KG5Cl8nGQjhbBX8S1elmE8g.sIvK_NXFGk7KYJo-OcUWExWGlJVxgMja-2SokwVf9wUg.JPEG/2.jpg?type=w1200",  "https://i.pinimg.com/originals/f0/a7/02/f0a70248f3c8d5887c2c66f49d7fc570.png","https://pbs.twimg.com/media/C46e96dUMAMuD96.jpg"] {
        didSet {
            collectionView.reloadData()
        }
    }
    var finalOffset : CGFloat = 0
    var startOffset  : CGFloat = 0
    var currentIdx = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
         bottomWhiteView.layer.applySketchShadow(alpha : 0.06, x : 0, y : 5, blur : 6, spread : 0)
        contentLbl.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 1.25)
    }

}
//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ReviewContentTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = imgUrlArr.count
        return imgUrlArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ReviewContentCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewContentCVCell.reuseIdentifier, for: indexPath) as? ReviewContentCVCell{
            cell.configure(data: imgUrlArr[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ReviewContentTVCell: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size : Double = glt_iphoneX ? 300/812*812 : 300/812*667
         return CGSize(width: size, height: size)
    }
    
}

//MARK: - 컬렉션 뷰 드래깅
extension ReviewContentTVCell : UIScrollViewDelegate {
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
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        currentIdx = safeIndex
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = collectionView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        finalOffset = collectionView.contentOffset.x
        //stop scrollview sliding
        targetContentOffset.pointee = scrollView.contentOffset
        let majorIdx = finalOffset > startOffset ? indexOfMajorCell(direction: .right) : indexOfMajorCell(direction: .left)
        let indexPath = IndexPath(row: majorIdx, section: 0)
        self.pageControl.currentPage = majorIdx
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
