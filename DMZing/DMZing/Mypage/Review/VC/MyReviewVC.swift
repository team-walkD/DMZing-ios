//
//  MyReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyReviewVC: UIViewController, APIService {

    @IBOutlet weak var tableView: UITableView!
    
    var mainData : [MypageReviewVOData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        getMainData(url: url("users/reviews"))
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.FlatColor.Blue.lightBlue
        //navigationController?.navigationBar.isTranslucent = false
    }
}

extension MyReviewVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyReviewTVCell.reuseIdentifier) as! MyReviewTVCell
        guard mainData.count > 0 else {return cell}
        cell.configure(data: mainData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyReviewVC {
    func getMainData(url : String){
        MypageReviewService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let mainData = data as? MypageReviewVO
                if let mainData_ = mainData {
                    self.mainData = mainData_
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
