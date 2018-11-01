//
//  ArticleReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import LTScrollView

struct SampleArticleReviewStruct {
    let startDate : String
    let endDate : String
    let title : String
    let likeCount : Int
    let imgUrl : String
}
private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
class ArticleReviewVC : UIViewController, LTTableViewProtocal, APIService  {
    
    var articleReviewArr : [SampleArticleReviewStruct]  = [] {
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
        let nib = UINib.init(nibName: ArticleReviewCVCell.reuseIdentifier, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: ArticleReviewCVCell.reuseIdentifier)
        view.addSubview(collectionView)
        glt_scrollView = collectionView
        
        
        addDummyData()
    }
    
    private func addDummyData(){
        
        let a = SampleArticleReviewStruct(startDate: "2018.09.30", endDate: "2018.09.30", title: "수진날진의 여행기", likeCount: 10, imgUrl: "https://pbs.twimg.com/media/DUcm7xQVoAE5q4Z.jpg")
        let b = SampleArticleReviewStruct(startDate: "2018.09.30", endDate: "2018.09.30", title: "장드타는 왜 장드타", likeCount: 10, imgUrl: "https://pbs.twimg.com/media/DPDN06VVoAEfXG_.jpg")
        let c = SampleArticleReviewStruct(startDate: "2018.09.30", endDate: "2018.09.30", title: "예은 와서 뷰짠다", likeCount: 10, imgUrl: "https://post-phinf.pstatic.net/MjAxODA0MTBfMTQ2/MDAxNTIzMzQxMDQxODYw.aO_dJut4YK-3jjbJ_dw49KG5Cl8nGQjhbBX8S1elmE8g.sIvK_NXFGk7KYJo-OcUWExWGlJVxgMja-2SokwVf9wUg.JPEG/2.jpg?type=w1200")
        let d = SampleArticleReviewStruct(startDate: "2018.09.30", endDate: "2018.09.30", title: "승미야 일해!", likeCount: 10, imgUrl: "https://i.pinimg.com/originals/f0/a7/02/f0a70248f3c8d5887c2c66f49d7fc570.png")
        
        let e = SampleArticleReviewStruct(startDate: "2018.09.30", endDate: "2018.09.30", title: "융성픽", likeCount: 10, imgUrl: "https://pbs.twimg.com/media/C46e96dUMAMuD96.jpg")
        articleReviewArr.append(contentsOf: [a,b,c,d,e])
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
        
    }
    
}

