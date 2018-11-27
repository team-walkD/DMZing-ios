//
//  MyCourseVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyCourseVC: UIViewController, APIService, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var myCourseArr : [MyCourseVOData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarColor(color: UIColor.FlatColor.Blue.lightBlue)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavBarColor(color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setBackBtn()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getMyCourseData(url: self.url("users/course"))
        }
    }    
  
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
    }
}

extension MyCourseVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCourseArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCourseTVCell.reuseIdentifier) as! MyCourseTVCell
        cell.configure(data: myCourseArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mypageStoryboard = Storyboard.shared().mypageStoryboard
        if let myPostVC = mypageStoryboard.instantiateViewController(withIdentifier:MyPostVC.reuseIdentifier) as? MyPostVC {
            myPostVC.courseId = myCourseArr[indexPath.row].cId
            self.navigationController?.pushViewController(myPostVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension MyCourseVC {
    func getMyCourseData(url : String){
        MyCourseService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let myCourseArr = data as? MyCourseVO
                if let myCourseArr_ = myCourseArr {
                    self.myCourseArr = myCourseArr_
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


