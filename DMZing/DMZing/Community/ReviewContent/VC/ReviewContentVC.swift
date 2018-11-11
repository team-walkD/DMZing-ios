//
//  ReviewContentVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 8..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ReviewContentVC: UIViewController, UIGestureRecognizerDelegate{
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        makeLayout()
        setBackBtn(color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
}

extension ReviewContentVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewContentTVCell.reuseIdentifier) as! ReviewContentTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            make.centerX.equalToSuperview()
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

