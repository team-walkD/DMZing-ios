//
//  ReviewDetailVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import LTScrollView

class ReviewDetailVC: UIViewController, APIService, UIGestureRecognizerDelegate {
    
    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    
    let photoReviewVC = PhotoReviewVC()
    let articleReviewVC = ArticleReviewVC()
    
   /* var myBoardData : [MyPageVODataBoard]  = [] {
        didSet {
            myFeedVC.myBoardData = myBoardData
        }
    }
    var myScrapData : [MyPageVODataScrap]  = [] {
        didSet {
            myScrapVC.myScrapData = myScrapData
        }
    }*/
    
    private lazy var viewControllers: [UIViewController] = {
        return [photoReviewVC, articleReviewVC]
    }()
    
    private lazy var titles: [String] = {
        return ["사진 리뷰", "상세 리뷰"]
    }()
    
    //헤더 뷰 생성 후, 그 안에 프로퍼티들 설정
    private lazy var headerView : UIView = {
        let headerView = ReviewDetailHeaderView.instanceFromNib()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 167)
        return headerView
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.titleViewBgColor = .white
        layout.isNeedScale = false
        layout.titleFont = UIFont(name: AppleSDGothicNeo.Bold.rawValue, size: 16)!
        layout.titleColor = #colorLiteral(red: 0.4823529412, green: 0.5450980392, blue: 0.5843137255, alpha: 1)
        layout.titleSelectColor = ColorChip.shared().deepBlue
        layout.sliderHeight = 50.0
        layout.sliderWidth = 70
        layout.bottomLineHeight = 2
        layout.bottomLineColor = ColorChip.shared().middleBlue
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
        view.backgroundColor = UIColor.white
        // self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(advancedManager)
        advancedManagerConfig()
        setBackBtn()
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
            print("현재 인덱스는 -> \($0)")
        }
        
    }
}
