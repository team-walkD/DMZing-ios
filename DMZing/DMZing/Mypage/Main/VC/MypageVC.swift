//
//  MypageVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MypageVC: UIViewController, APIService {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var courseCntLbl:
    UILabel!
    @IBOutlet weak var reviewCntLbl: UILabel!
    @IBOutlet weak var pointCntLbl: UILabel!
    let cellTitleArr = ["FnQ", "설정 및 관리"]
    
    @IBAction func settingAction(_ sender: Any) {
        
    }
    
    @IBAction func mailMoreAction(_ sender: Any) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let myPostVC = mypageStoryboard.instantiateViewController(withIdentifier:MyPostVC.reuseIdentifier) as? MyPostVC {
            self.navigationController?.pushViewController(myPostVC, animated: true)
        }
    }
    
    @IBAction func courseAction(_ sender: Any) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let myCourseVC = mypageStoryboard.instantiateViewController(withIdentifier:MyCourseVC.reuseIdentifier) as? MyCourseVC {
            self.navigationController?.pushViewController(myCourseVC, animated: true)
        }
    }
    @IBAction func reviewAction(_ sender: Any) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let myReviewVC = mypageStoryboard.instantiateViewController(withIdentifier:MyReviewVC.reuseIdentifier) as? MyReviewVC {
            self.navigationController?.pushViewController(myReviewVC, animated: true)
        }
    }
    @IBAction func pointAction(_ sender: Any) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let myDPPointVC = mypageStoryboard.instantiateViewController(withIdentifier:MyDPPointVC.reuseIdentifier) as? MyDPPointVC {
            self.navigationController?.pushViewController(myDPPointVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getMainData(url: url("users/info"))
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
    }
    
}

extension MypageVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTVCell.reuseIdentifier) as! MyPageTVCell
        cell.configure(data : cellTitleArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //FnQ로 이동
        } else {
            //설정 및 관리로 이동
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MypageVC {
    func getMainData(url : String){
        MypageMainService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let mainData = data as? MypageMainVO
                self.nameLbl.text = mainData?.nick
                self.pointCntLbl.text = mainData?.dp.description
                self.reviewCntLbl.text = mainData?.reviewCount.description
                self.courseCntLbl.text = mainData?.courseCount.description
                self.emailLbl.text = mainData?.email
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
