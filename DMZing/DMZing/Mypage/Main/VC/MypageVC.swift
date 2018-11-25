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
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var courseCntLbl:
    UILabel!
    @IBOutlet weak var reviewCntLbl: UILabel!
    @IBOutlet weak var pointCntLbl: UILabel!
    let cellTitleArr = ["FAQ", "설정 및 관리"]
    
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
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMainData(url: self.url("users/info"))
        }
        setupNavBarColor(color: .white)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoButton()
        setChatButton()
        setupTableView()
    }


    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
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
            let vc = UIStoryboard(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            //설정 및 관리로 이동
            let vc = UIStoryboard(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "manageNavi")
            self.present(vc, animated: true, completion: nil)
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
