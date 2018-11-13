//
//  ArticleReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import LTScrollView

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
class ArticleReviewVC : UIViewController, LTTableViewProtocal, APIService  {
    
    var selectedMap : MapType?
    var articleReviewArr : [ArticleReviewVOData]  = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        //  let H: CGFloat = glt_iphoneX ? (view.bounds.height - 64 - 24 - 34) : view.bounds.height  - 20
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 337, height: 210)
        layout.minimumLineSpacing = 21
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsetsMake(29, 22, 29, 22)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getArticleReviewData(url: self.url("reviews/last/0/course/\(self.selectedMap!.mapName)"))
        }
        let nib = UINib.init(nibName: ArticleReviewCVCell.reuseIdentifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: ArticleReviewCVCell.reuseIdentifier)
        view.addSubview(collectionView)
        glt_scrollView = collectionView
    }
}

//CollectionView Delegate, Datasource
extension ArticleReviewVC : UICollectionViewDelegate, UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleReviewArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleReviewCVCell.reuseIdentifier, for: indexPath) as! ArticleReviewCVCell
        //configure로
        cell.configure(data: articleReviewArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reviewStoryboard = Storyboard.shared().reviewStoryboard
        
        if let reviewContentVC = reviewStoryboard.instantiateViewController(withIdentifier:ReviewContentVC.reuseIdentifier) as? ReviewContentVC {
            reviewContentVC.selectedRId = articleReviewArr[indexPath.row].id
            self.navigationController?.pushViewController(reviewContentVC, animated: true)
        }
    }
    //페이지네이션
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard articleReviewArr.count > 0 else {return}
        let lastItemIdx = articleReviewArr.count-1
        let itemIdx = articleReviewArr[lastItemIdx].id
        if indexPath.row == lastItemIdx {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let `self` = self else { return }
                self.getArticleReviewData(url: self.url("reviews/last/\(itemIdx)/course/\(self.selectedMap!.mapName)"))
            }
        }
    }
    
}


extension ArticleReviewVC {
    func getArticleReviewData(url : String){
        GetArticleReviewService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let articleData = data as? ArticleReviewVO
                guard let articleData_ = articleData else {return}
                if articleData_.count > 0 {
                    self.articleReviewArr.append(contentsOf: articleData_)
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


