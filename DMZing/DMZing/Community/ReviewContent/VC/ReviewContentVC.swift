//
//  ReviewContentVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 8..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewContentVC: UIViewController, UIGestureRecognizerDelegate, APIService{
    private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var topBlackView: UIView!
    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var centerWhiteView: UIView!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var startDateLbl: UITextField!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDateLbl: UITextField!
    @IBOutlet weak var smallWhiteView: UIView!
    @IBOutlet weak var heartWhiteView: UIView!
    @IBOutlet weak var heartShadowImgView: UIImageView!
    @IBOutlet weak var heartImgView: UIImageView!
    @IBOutlet weak var heartCntLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectedRId = 0
    var isSelected = false {
        didSet {
            heartImgView.image = isSelected ? #imageLiteral(resourceName: "heart_fill_icon") : #imageLiteral(resourceName: "heart_icon")
        }
    }
    var contentData : ReviewContentVO? {
        didSet {
            guard let contentData_ = contentData else {return}
            self.setUI(data: contentData_)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getReviewDetail(url: self.url("reviews/\(self.selectedRId)"))
        }
        tableView.dataSource = self
        tableView.delegate = self
        makeLayout()
        setBackBtn(color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUI(data : ReviewContentVO){
        titleLbl.text = data.title
        startDateLbl.text = data.startAt.timeStampToDate()
        endDateLbl.text = data.endAt.timeStampToDate()
        topImgView.setImgWithKF(url: data.thumbnailURL, defaultImg: #imageLiteral(resourceName: "review_default_basic_img"))
        heartCntLbl.text = data.likeCount.description
        heartImgView.image = data.like ? #imageLiteral(resourceName: "heart_fill_icon") : #imageLiteral(resourceName: "heart_icon")
        isSelected = data.like
    }
    
    @IBAction func likeAction(_ sender: Any) {
        likeContent(url: url("reviews/like/\(selectedRId)"))
    }
    
    @IBAction func reportAction(_ sender: Any) {
        simpleAlertwithHandler(title: "신고", message: "해당 게시물을 신고하시겠습니까?") { (_) in
            let params : [String : Any] = [
                "reviewId": self.selectedRId,
                "reportType": "DETAIL",
                "content": "글 리뷰 신고"
            ]
            self.reportContent(url: self.url("report"), params: params)
        }
    }
}

extension ReviewContentVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contentData_ = contentData else {return 0}
        return contentData_.postDto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewContentTVCell.reuseIdentifier) as! ReviewContentTVCell
        guard let contentData_ = contentData else {return cell}
        cell.configure(data : contentData_.postDto[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            //reach bottom
            return
        }
        let height : CGFloat = glt_iphoneX ? 359/812*812 : 359/812*667
        let minHeight : CGFloat = glt_iphoneX ? 292/812*812 : 292/812*667
        let y = height - (scrollView.contentOffset.y)
        
        let h = max(minHeight, y)
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: h)
        // topView.frame = rect
        
        topView.frame = rect
        makeConstraint()
    }
    
}

extension ReviewContentVC {
    
    func makeLayout(){
        let H : CGFloat = glt_iphoneX ? 359/812*812 : 359/812*667
        let rect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: H)
        topView.frame = rect
        makeConstraint()
        startDateView.makeViewBorder(width: 0.5, color: .white)
        endDateView.makeViewBorder(width: 0.5, color: .white)
        
    }
    
    
    func makeConstraint(){
        topImgView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            let statusBarH = UIApplication.shared.statusBarFrame.size.height
            let Y: CGFloat = statusBarH + 44
            make.top.equalToSuperview().offset(-Y)
            make.bottom.equalToSuperview().offset(-26.5)
        }
        topBlackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(topImgView)
        }
        
        centerWhiteView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            let statusBarH = UIApplication.shared.statusBarFrame.size.height
            let Y: CGFloat = statusBarH + 44
            make.centerY.equalTo(topImgView).offset(Y)
            make.width.equalTo(25)
            make.height.equalTo(0.5)
        }
        titleLbl.snp.makeConstraints { (make) in
           
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(centerWhiteView.snp.top).offset(-30)
        }
        smallWhiteView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(11)
            make.height.equalTo(0.5)
            make.top.equalTo(centerWhiteView.snp.bottom).offset(37)
            
        }
        startDateView.snp.makeConstraints { (make) in
            make.centerY.equalTo(smallWhiteView)
            make.trailing.equalTo(smallWhiteView.snp.leading).offset(-3)
            make.width.equalTo(92)
            make.height.equalTo(20)
            
        }
        endDateView.snp.makeConstraints { (make) in
            make.centerY.equalTo(smallWhiteView)
            make.leading.equalTo(smallWhiteView.snp.trailing).offset(3)
            make.width.equalTo(92)
            make.height.equalTo(20)
        }
        startDateLbl.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        endDateLbl.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        
        heartWhiteView.snp.makeConstraints { (make) in
            make.width.height.equalTo(53)
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(topBlackView.snp.bottom)
        }
        heartShadowImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(66)
            make.centerX.centerY.equalToSuperview()
            
        }
        heartImgView.snp.makeConstraints { (make) in
            make.width.equalTo(17)
            make.height.equalTo(15)
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        heartCntLbl.snp.makeConstraints { (make) in
            make.top.equalTo(heartImgView.snp.bottom).offset(4.5)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBlackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}

extension ReviewContentVC {
    func getReviewDetail(url : String){
        GetReviewContentService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let reviewData = data as? ReviewContentVO else {return}
                self.contentData = reviewData
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func likeContent(url : String){
        let params : [String : Any] = [:]
        WriteArticleService.shareInstance.writeArticleReview(url: url, params: params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                self.isSelected = !self.isSelected
                guard let likeCount = Int(self.heartCntLbl.text!) else {return}
                self.heartCntLbl.text = self.isSelected ? (likeCount+1).description : (likeCount-1).description
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func reportContent(url : String, params : [String : Any]){
        WriteArticleService.shareInstance.writeArticleReview(url: url, params: params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                self.simpleAlert(title: "성공", message: "해당 게시물을 신고했습니다")
                break
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
}

