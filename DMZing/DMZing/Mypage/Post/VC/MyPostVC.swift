//
//  MyPostVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyPostVC: UIViewController, APIService {
    @IBOutlet weak var collectionView: UICollectionView!
    var courseId = 0
    var postImgArr : [MyPostVOData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setBackBtn()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMyPostData(url: self.url("users/\(self.courseId)/mail"))
        }
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.FlatColor.Blue.lightBlue
    }

}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension MyPostVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    //헤더 뷰
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "postCollectionHeaderView",
                                                                         for: indexPath)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImgArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPostCVCell.reuseIdentifier, for : indexPath) as! MyPostCVCell
        guard postImgArr.count > 0 else {return cell}
        cell.configure(data: postImgArr[indexPath.row].letterImageURL)
        return cell
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension MyPostVC: UICollectionViewDelegateFlowLayout {
    //section내의
    //-간격 위아래
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //-간격 왼쪽오른쪽
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 363)
    }
}



extension MyPostVC {
    func getMyPostData(url : String){
        MyPostService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let myPostArr = data as? MyPostVO else {return }
                self.postImgArr = myPostArr
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
