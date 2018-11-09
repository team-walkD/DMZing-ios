//
//  MainMapViewController.swift
//  DMZing
//
//  Created by 김예은 on 09/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class MainMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CollectionView
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        
    }
    
    //MARK: - CollectionView Method
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
    
}

//extension MainMapViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 375, height: (344/375)*collectionView.frame.width)
//    }
//}




