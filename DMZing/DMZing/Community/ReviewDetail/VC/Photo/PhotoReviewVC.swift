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

extension Int{
    func getPortionalLength() -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        return (CGFloat(self)/375)*screenSize.width
    }
}

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
class PhotoReviewVC : UIViewController, LTTableViewProtocal, APIService  {

    var selectedMap : MapInfo?
    var photoReviewData : [PhotoReviewVOData] = [] {
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
        layout.itemSize = CGSize(width: 159.getPortionalLength(), height: 237.getPortionalLength())
        layout.minimumLineSpacing = 20.getPortionalLength()
        layout.minimumInteritemSpacing = 11.getPortionalLength()
        layout.sectionInset = UIEdgeInsetsMake(29.getPortionalLength(), 22.getPortionalLength(), 29.getPortionalLength(), 22.getPortionalLength())
        
        let collectionView = collectionViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), layout, self, self)
        collectionView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getPhotoReviewData(url: self.url("reviews/photo/last/0/course/\(self.selectedMap!.mapType)"))
        }
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
    
    }
}

//CollectionView Delegate, Datasource
extension PhotoReviewVC : UICollectionViewDelegate, UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoReviewData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoReviewCVCell.reuseIdentifier, for: indexPath) as! PhotoReviewCVCell
        cell.configure(data: photoReviewData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.keyWindow!.addSubview(popupView)
        popupView.mainImgView.setImgWithKF(url: photoReviewData[indexPath.row].imageURL, defaultImg: #imageLiteral(resourceName: "review_default_img"))
        popupView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    //페이지네이션
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard photoReviewData.count > 0 else {return}
        
        let lastItemIdx = photoReviewData.count-1
        let itemIdx = photoReviewData[lastItemIdx].id
        if indexPath.row == lastItemIdx {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let `self` = self else { return }
                self.getPhotoReviewData(url: self.url("reviews/photo/last/\(itemIdx)/course/\(self.selectedMap!.mapType)"), isFirst: false)
            }
        }
    }
}

extension PhotoReviewVC {
    func getPhotoReviewData(url : String, isFirst : Bool = true){
        GetPhotoReviewService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let photoData = data as? PhotoReviewVO
                guard let photoData_ = photoData else {return}
                if photoData_.count > 0 {
                    if isFirst {
                        self.photoReviewData = photoData_
                    } else {
                        self.photoReviewData.append(contentsOf: photoData_)
                    }
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


