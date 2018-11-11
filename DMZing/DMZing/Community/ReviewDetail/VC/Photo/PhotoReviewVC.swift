//
//  PhotoReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import LTScrollView
import SnapKit

struct SamplePhotoReviewStruct {
    let date : String
    let title : String
    let tag : [String]
    let imgUrl : String
}
private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
class PhotoReviewVC : UIViewController, LTTableViewProtocal, APIService  {
    
    var photoReviewArr : [SamplePhotoReviewStruct]  = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private lazy var popupView : PhotoReviewPopupView = {
        
        let popView = PhotoReviewPopupView.instanceFromNib()
        popView.cancleBtn.addTarget(self, action: #selector(popupCancleAction), for: .touchUpInside)
        return popView
    }()
    
  
    
    private lazy var collectionView: UICollectionView = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
      //  let H: CGFloat = glt_iphoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height  - 20
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 159, height: 237)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsetsMake(29, 22, 29, 22)
       
        let collectionView = collectionViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), layout, self, self)
        return collectionView
    }()
    
    func collectionViewConfig(_ frame: CGRect, _ collectionViewLayout : UICollectionViewLayout, _ delegate: UICollectionViewDelegate, _ dataSource: UICollectionViewDataSource) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        return collectionView
    }
    
    @objc func popupCancleAction(){
        self.popupView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: PhotoReviewCVCell.reuseIdentifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: PhotoReviewCVCell.reuseIdentifier)
        view.addSubview(collectionView)
        glt_scrollView = collectionView
        
//        if #available(iOS 11.0, *) {
//            collectionView.contentInsetAdjustmentBehavior = .never
//
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
        
        addDummyData()
    }
    
    private func addDummyData(){
        let a = SamplePhotoReviewStruct(date: "2018.09.30", title: "수진날진의 여행기", tag: ["#수진", "#날진"], imgUrl: "https://pbs.twimg.com/media/DUcm7xQVoAE5q4Z.jpg")
         let b = SamplePhotoReviewStruct(date: "2018.09.30", title: " 장드타는 왜 장드타", tag: ["#드래곤", "#타이거"], imgUrl: "https://pbs.twimg.com/media/DPDN06VVoAEfXG_.jpg")
         let c = SamplePhotoReviewStruct(date: "2018.09.30", title: "예은 와서 뷰짠다", tag: ["#맵", "#뷰노예"], imgUrl: "https://post-phinf.pstatic.net/MjAxODA0MTBfMTQ2/MDAxNTIzMzQxMDQxODYw.aO_dJut4YK-3jjbJ_dw49KG5Cl8nGQjhbBX8S1elmE8g.sIvK_NXFGk7KYJo-OcUWExWGlJVxgMja-2SokwVf9wUg.JPEG/2.jpg?type=w1200")
        let d = SamplePhotoReviewStruct(date: "2018.09.30", title: "승미야 일해!", tag: ["#제플린", "#업데이트"], imgUrl: "https://i.pinimg.com/originals/f0/a7/02/f0a70248f3c8d5887c2c66f49d7fc570.png")
        let e = SamplePhotoReviewStruct(date: "2018.09.30", title: "융선픽", tag: ["#픽픽", "#서강준"], imgUrl: "https://pbs.twimg.com/media/C46e96dUMAMuD96.jpg")

         photoReviewArr.append(contentsOf: [a,b,c,d,e])
    }
}

//CollectionView Delegate, Datasource
extension PhotoReviewVC : UICollectionViewDelegate, UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewArr.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCVCell.reuseIdentifier, for: indexPath) as! PhotoReviewCVCell
        cell.configure(data: photoReviewArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.keyWindow!.addSubview(popupView)
        popupView.mainImgView.setImgWithKF(url: photoReviewArr[indexPath.row].imgUrl, defaultImg: #imageLiteral(resourceName: "ccc"))
        popupView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}


