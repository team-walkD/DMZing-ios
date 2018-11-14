//
//  ReviewDetailVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import LTScrollView
typealias MapInfo = (mapName : String, mapType : MapType)
class ReviewDetailVC: UIViewController, APIService, UIGestureRecognizerDelegate {
    
    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    
    let photoReviewVC = PhotoReviewVC()
    let articleReviewVC = ArticleReviewVC()
    var selectedIdx = 0 //어떤 유형의 리뷰가 선택 되었는지 (사진 / 글)
    var selectedMap : MapInfo? //어떤 맵이 선택되었는지
    var spotArr : [String] = []//맵 선택에 따른 스팟 어레이
    
    private lazy var viewControllers: [UIViewController] = {
        photoReviewVC.selectedMap = selectedMap
        articleReviewVC.selectedMap = selectedMap
        return [photoReviewVC, articleReviewVC]
    }()
    
    private lazy var titles: [String] = {
        return ["사진 리뷰", "상세 리뷰"]
    }()
    
    //헤더 뷰 생성 후, 그 안에 프로퍼티들 설정
    private lazy var headerView : UIView = {
        let headerView = ReviewDetailHeaderView.instanceFromNib()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 167)
        guard let selectedMap_ = selectedMap else {return headerView}
        headerView.titleLbl.text = "\(selectedMap_.mapName)하기 좋은 코스"
        return headerView
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.titleViewBgColor = .white
        layout.isNeedScale = false
        layout.titleFont = UIFont(name: AppleSDGothicNeo.Bold.rawValue, size: 16)!
        layout.titleColor = #colorLiteral(red: 0.4823529412, green: 0.5450980392, blue: 0.5843137255, alpha: 1)
        layout.titleSelectColor = UIColor.FlatColor.Blue.deepBlue
        layout.sliderHeight = 50.0
        layout.sliderWidth = 70
        layout.bottomLineHeight = 2
        layout.bottomLineColor = UIColor.FlatColor.Blue.middleBlue
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = 0
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34)  : view.bounds.height - Y
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    private lazy var advancedManager: LTAdvancedManager = {
        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            return headerView
        })
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        /* 设置悬停位置 */
        //   advancedManager.hoverY = 64
        
        /* 点击切换滚动过程动画 */
        //       advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        
        return advancedManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        // self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(advancedManager)
        advancedManagerConfig()
        setBackBtn()
       
    }
    
   
    
    func selectCoursePopup(){
        guard let selectedMap_ = selectedMap else {return}
        getSpotData(url: url("course/\(selectedMap_.mapType.rawValue)/places"))
    }
    
    func setPopupUI(){
        guard let selectedMap_ = selectedMap else {return}
        let title = "어떤 장소의 사진리뷰를 작성하시나요?"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let goToWriteVC = { (action: UIAlertAction!) -> Void in
            let reviewStoryboard = Storyboard.shared().reviewStoryboard
            if let writePhotoReviewVC = reviewStoryboard.instantiateViewController(withIdentifier:WritePhotoReviewVC.reuseIdentifier) as? WritePhotoReviewVC {
                guard let index = alert.actions.index(of: action)  else {return}
                writePhotoReviewVC.selectedCourse = (selectedMap_.mapType.rawValue, self.spotArr[index])
                self.present(writePhotoReviewVC, animated: true, completion: nil)
            }
        }
        spotArr.forEach { (item) in
            alert.addAction(UIAlertAction(title: item, style: .default, handler: goToWriteVC))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func writeAction(_ sender: Any) {
       
        if selectedIdx == 0 {
            selectCoursePopup()
        } else {
            guard let selectedMap_ = selectedMap else {return}
            let reviewStoryboard = Storyboard.shared().reviewStoryboard
            let writeEntryNavC = reviewStoryboard.instantiateViewController(withIdentifier:"reviewNavi") as! UINavigationController
            
            if let writeEntryVC = writeEntryNavC.topViewController as? WriteEntryVC {
                writeEntryVC.selectedCourseId = (selectedMap_.mapType.rawValue)
                self.present(writeEntryNavC, animated: true, completion: nil)
            }
        }
        
    }
    
    
    deinit {
        print("LTAdvancedManagerDemo < --> deinit")
    }
}

//LTAdvancedScrollViewDelegate
extension ReviewDetailVC : LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
        advancedManager.advancedDidSelectIndexHandle = {
            self.selectedIdx = $0
        }
        
    }
}

extension ReviewDetailVC {
    func getSpotData(url : String){
        GetSpotService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let spotData = data as? SpotVO
                guard let spotData_ = spotData else {return}
                self.spotArr = spotData_.map({ (item) in
                    item.name
                })
                self.setPopupUI()
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
