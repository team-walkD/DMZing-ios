//
//  MainMapViewController.swift
//  DMZing
//
//  Created by 김예은 on 09/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class MainMapViewController: UIViewController {
    
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
        
    }
    
}

//MARK: - CollectionView Method
extension MainMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMapCollectionViewCell", for: indexPath) as! MainMapCollectionViewCell
        
        cell.courseImageView.image = #imageLiteral(resourceName: "ccc.png")
        cell.smallLabel.text = "사진 찍기 좋은 핫스팟"
        cell.largeLabel.text = "데이트하기 좋은 코스"
        cell.pageLabel.text = "1/4"
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let cellWidth: CGFloat = 327

        let numberOfCells = floor(view.frame.size.width / cellWidth)
        let edgeInsets = (view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets)
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
        } else if finalOffset < startOffset {
            //앞으로 가기
            let majorIdx = indexOfMajorCell(direction: .left)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mapCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            print("둘다 아님")
        }
    }
}



